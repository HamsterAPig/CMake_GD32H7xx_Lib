if (NOT MCU_SERIES)
    message(FATAL_ERROR "MCU_SERIES must be specified!")
endif ()
message("MCU_SERIES is ${MCU_SERIES}")
set(LIB_DIR_PREFIX CMake_GD32_Firmware)

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

set(CMAKE_C_COMPILER_FORCED TRUE)
set(CMAKE_CXX_COMPILER_FORCED TRUE)
set(CMAKE_C_COMPILER_ID GNU)
set(CMAKE_CXX_COMPILER_ID GNU)

# Some default GCC settings
# arm-none-eabi- must be part of path environment
set(TOOLCHAIN_PREFIX arm-none-eabi-)

set(CMAKE_C_COMPILER ${TOOLCHAIN_PREFIX}gcc)
set(CMAKE_ASM_COMPILER ${CMAKE_C_COMPILER})
set(CMAKE_CXX_COMPILER ${TOOLCHAIN_PREFIX}g++)
set(CMAKE_LINKER ${TOOLCHAIN_PREFIX}g++)
set(CMAKE_OBJCOPY ${TOOLCHAIN_PREFIX}objcopy)
set(CMAKE_SIZE ${TOOLCHAIN_PREFIX}size)

set(CMAKE_EXECUTABLE_SUFFIX_ASM ".elf")
set(CMAKE_EXECUTABLE_SUFFIX_C ".elf")
set(CMAKE_EXECUTABLE_SUFFIX_CXX ".elf")

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

if ("${CMAKE_BUILD_TYPE}" STREQUAL "Release")
    message(STATUS "Maximum optimization for speed")
    add_compile_options(-Ofast)
elseif ("${CMAKE_BUILD_TYPE}" STREQUAL "RelWithDebInfo")
    message(STATUS "Maximum optimization for speed, debug info included")
    add_compile_options(-Ofast -g)
elseif ("${CMAKE_BUILD_TYPE}" STREQUAL "MinSizeRel")
    message(STATUS "Maximum optimization for size")
    add_compile_options(-Os)
else ()
    message(STATUS "Minimal optimization, debug info included")
    add_compile_options(-Og -g)
endif ()

# configure mcu
if (MCU_SERIES STREQUAL "GD32H7XX")
    set(HARD_FLOAT_PARAM -mfloat-abi=hard -mfpu=fpv4-sp-d16)
    set(SOFT_FLOAT_PARAM -mfloat-abi=soft)
    set(PROCESSOR_PLATFORM -mcpu=cortex-m7 -mthumb -mthumb-interwork)
    set(LINK_FILE_NAME gd32h7xx_flash.ld)
endif ()

# generate link script file
configure_file(${CMAKE_SOURCE_DIR}/${LIB_DIR_PREFIX}/ldscripts/${LINK_FILE_NAME}.in ${LINK_FILE_NAME} @ONLY)
set(LINKER_SCRIPT ${CMAKE_BINARY_DIR}/${LINK_FILE_NAME})

# float support
if (ENABLE_HARD_FLOAT)
    add_compile_options(${HARD_FLOAT_PARAM})
    add_link_options(${HARD_FLOAT_PARAM})
    message("Using hard float")
else ()
    add_compile_options(${SOFT_FLOAT_PARAM})
    message("Using soft float")
endif ()

add_compile_options(${PROCESSOR_PLATFORM})
add_compile_options(-ffunction-sections -fdata-sections -fno-common -fmessage-length=0 -fsigned-char)
add_compile_options(-specs=nano.specs)
add_compile_options(
        $<$<COMPILE_LANGUAGE:CXX>:-fno-rtti>
        $<$<COMPILE_LANGUAGE:CXX>:-fno-exceptions>
        $<$<COMPILE_LANGUAGE:CXX>:-fno-threadsafe-statics>

        $<$<COMPILE_LANGUAGE:ASM>:-MMD>
        $<$<COMPILE_LANGUAGE:ASM>:-MP>
        # Enable assembler files preprocessing
        $<$<COMPILE_LANGUAGE:ASM>:-x$<SEMICOLON>assembler-with-cpp>
)

add_link_options(-Wl,-gc-sections,--print-memory-usage,-Map=${CMAKE_BINARY_DIR}/${CMAKE_PROJECT_NAME}.map)
add_link_options(-Wl,--start-group -lc -lm -Wl,--end-group)
add_link_options(-specs=nano.specs)
add_link_options(${PROCESSOR_PLATFORM})
add_link_options(-T ${LINKER_SCRIPT})