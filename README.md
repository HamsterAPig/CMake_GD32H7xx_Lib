# CMake GD32 Firmware
> 使用Cmake管理的GD32固件库，调用gcc-arm-none-eabi作为交叉编译器

## 环境
本工程目前在`arm-gnu-toolchain-13.2.rel1-mingw-w64-i686-arm-none-eabi`下测试通过

# Usage
首先克隆本工程，注意如无必要不要更改本工程的名字，即`CMake_GD32_Firmware`，部分构建选项依赖于这个名字否则找不到相关路径。

## 目录结构
全项目建议的目录结构如下
```angular2html
project
├─App
│  ├─Inc
│  └─Src
├─CMakeLists.txt
└─CMake_GD32_Firmware
    ├─3rdparty
    ├─cmake
    ├─CMSIS
    ├─GD32H7xx
    └─ldscripts
```

这里以GD32H7xx为例给出顶层`CMakelists.txt`文件
```cmake
cmake_minimum_required(VERSION 3.22)

# Setup compiler settings
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS ON)

# Define the build type
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Debug")
endif()

# Define MCU Series
set(MCU_SERIES "GD32H7XX" CACHE STRING "Select the MCU Series (e.g, GD32H7xx)")
set(MIN_HEAP_SIZE 0x200 CACHE STRING "Minimum heap size in bytes" FORCE)
set(MIN_STACK_SIZE 0x400 CACHE STRING "Minimum stack size in bytes" FORCE)
option(ENABLE_PRINTF "Enable printf support" ON)
option(RUN_IN_RAM "Program running in ram" OFF)

# Set the project name
set(CMAKE_PROJECT_NAME CMake_GD32_Firmware)

# Include toolchain file
include("CMake_GD32_Firmware/cmake/gcc-arm-none-eabi.cmake")

# Enable compile command to ease indexing with e.g. clangd
set(CMAKE_EXPORT_COMPILE_COMMANDS TRUE)

# Core project settings
project(${CMAKE_PROJECT_NAME} C CXX ASM)

message("Build type: " ${CMAKE_BUILD_TYPE})

# Create an executable object type
add_executable(${CMAKE_PROJECT_NAME})

# Add STM32CubeMX generated sources
add_subdirectory(CMake_GD32_Firmware/cmake/GD32H7xx)
if (ENABLE_PRINTF)
    add_subdirectory(CMake_GD32_Firmware/3rdparty/printf)
    list(APPEND USER_LIBRARIES MCUPrintfLib)
endif ()

# Link directories setup
target_link_directories(${CMAKE_PROJECT_NAME} PRIVATE
        # Add user defined library search paths
)

# Add sources to executable
target_sources(${CMAKE_PROJECT_NAME} PRIVATE
        # Add user sources here
        App/Src/gd32h7xx_it.c
        App/Src/gd32h759i_eval.c
        App/Src/main.c
        App/Src/systick.c
)

# Add include paths
target_include_directories(${CMAKE_PROJECT_NAME} PRIVATE
        # Add user defined include paths
        App/Inc
)

# Add project symbols (macros)
target_compile_definitions(${CMAKE_PROJECT_NAME} PRIVATE
        # Add user defined symbols
)

# Add linked libraries
target_link_libraries(${CMAKE_PROJECT_NAME}
        gd32h7xx
        # Add user defined libraries
        ${USER_LIBRARIES}
)

set(HEX_FILE ${PROJECT_BINARY_DIR}/${PROJECT_NAME}.hex)
set(BIN_FILE ${PROJECT_BINARY_DIR}/${PROJECT_NAME}.bin)

add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
        COMMAND ${CMAKE_OBJCOPY} -Oihex $<TARGET_FILE:${PROJECT_NAME}> ${HEX_FILE}
        COMMAND ${CMAKE_OBJCOPY} -Obinary $<TARGET_FILE:${PROJECT_NAME}> ${BIN_FILE}
        COMMENT "Building ${HEX_FILE}
Building ${BIN_FILE}")
```

注意配置文件当中的`target_include_directories`于`target_sources`需要改成和工程相对应的文件

## 编译选项
在使用的时候需要使用`cmakd -D`选项将MCU系列传递进去，默认是`GD32H7xx`，以下是一些选项说明
1. `MCU_SERIES`: MCU类型，e.g, GD32H7xx
2. `ENABLE_HARD_FLOAT`: 启用硬件浮点
3. `ENABLE_PRINTF`: 启用第三方的printf实现，具体见 https://github.com/HamsterAPig/printf 
4. `MIN_HEAP_SIZE `: 最小堆空间
5. `MIN_STACK_SIZE `: 最小栈空间
> 注意： 修改了最小堆栈空间大小的话，需要重新加载以下CMake工程，因为链接脚本是CMake动态生成的，实际的构建脚本在构建输出目录下

# 支持计划
目前仅支持GD32H7系列的库