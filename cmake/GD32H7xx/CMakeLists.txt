cmake_minimum_required(VERSION 3.22)
if (NOT MCU_SERIES STREQUAL "GD32H7XX")
    message(FATAL_ERROR "The gd32h7xx library applies to the series defined by GD32H7XX, but you chose ${MCU_SERIES}, please check if the project is configured correctly!")
endif ()
project(gd32h7xx)
add_library(${PROJECT_NAME} INTERFACE)

# Enable CMake support for ASM and C languages
enable_language(C ASM)

target_include_directories(${PROJECT_NAME} INTERFACE
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Include
        ../../CMSIS/GD/GD32H7xx/Include
        ../../CMSIS/GD/GD32H7xx/Inc
)

target_sources(${PROJECT_NAME} INTERFACE
        ../../GD32H7xx/gcc_startup/startup_gd32h7xx.S
        ../../CMSIS/GD/GD32H7xx/Source/system_gd32h7xx.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_adc.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_can.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_cau.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_cau_aes.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_cau_des.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_cau_tdes.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_cmp.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_cpdm.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_crc.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_ctc.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_dac.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_dbg.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_dci.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_dma.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_edout.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_efuse.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_enet.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_exmc.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_exti.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_fac.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_fmc.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_fwdgt.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_gpio.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_hau.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_hau_sha_md5.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_hpdf.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_hwsem.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_i2c.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_ipa.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_lpdts.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_mdio.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_mdma.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_misc.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_ospi.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_ospim.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_pmu.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_rameccmu.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_rcu.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_rspdif.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_rtc.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_rtdec.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_sai.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_sdio.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_spi.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_syscfg.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_timer.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_tli.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_tmu.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_trigsel.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_trng.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_usart.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_vref.c
        ../../GD32H7xx/GD32H7xx_standard_peripheral/Source/gd32h7xx_wwdgt.c
)

target_link_directories(${PROJECT_NAME} INTERFACE
)

target_link_libraries(${PROJECT_NAME} INTERFACE
)

target_compile_definitions(${PROJECT_NAME} INTERFACE GD32H7XX)

# Validate that code is compatible with C standard
if(CMAKE_C_STANDARD LESS 11)
    message(ERROR "Generated code requires C11 or higher")
endif()