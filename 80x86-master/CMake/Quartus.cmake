function(add_fpga)
    set(options "")
    set(oneValueArgs PROJECT FAMILY PART)
    set(multiValueArgs SOURCES DEPENDS)
    cmake_parse_arguments(add_fpga "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    foreach(source ${add_fpga_SOURCES})
        list(APPEND SOURCE_ARGS --source=${source})
        get_source_file_property(res ${source} COMPILE_FLAGS)
        if(NOT res STREQUAL "NOTFOUND")
            list(APPEND extra_compile_flags ${res})
        endif()
    endforeach(source)

    # Use a relative path for the SDC file otherwise Quartus will add it in a
    # second time as a relative path and then that causes delays to be added
    # twice
    file(RELATIVE_PATH sdc_file ${CMAKE_CURRENT_BINARY_DIR}
         ${CMAKE_CURRENT_SOURCE_DIR}/${add_fpga_PROJECT}.sdc)

    add_custom_command(OUTPUT ${add_fpga_PROJECT}.qpf
                       COMMAND rm -rf db incremental_db ${add_fpga_PROJECT}.qpf
                       COMMAND ${QUARTUS_SH_EXECUTABLE} --prepare -f ${add_fpga_FAMILY} -t ${add_fpga_PROJECT} ${add_fpga_PROJECT}
                       DEPENDS ${add_fpga_PROJECT}.qsf ${add_fpga_SOURCES})
    add_custom_command(OUTPUT ${add_fpga_PROJECT}.map.rpt
                       COMMAND ${QUARTUS_MAP_EXECUTABLE} ${SOURCE_ARGS} ${extra_compile_flags} --family ${add_fpga_FAMILY} --optimize=speed ${add_fpga_PROJECT}
                       DEPENDS ${add_fpga_DEPENDS} ${add_fpga_PROJECT}.qpf ${add_fpga_PROJECT}.qsf)
    add_custom_command(OUTPUT ${add_fpga_PROJECT}.fit.rpt
                       COMMAND ${QUARTUS_FIT_EXECUTABLE} --part=${add_fpga_PART} --read_settings_file=on --set=SDC_FILE=${sdc_file} ${add_fpga_PROJECT}
                       DEPENDS ${add_fpga_PROJECT}.map.rpt ${add_fpga_PROJECT}.sdc)
    add_custom_command(OUTPUT ${add_fpga_PROJECT}.asm.rpt
                       COMMAND ${QUARTUS_ASM_EXECUTABLE} ${add_fpga_PROJECT}
                       DEPENDS ${add_fpga_PROJECT}.fit.rpt)
    add_custom_command(OUTPUT ${add_fpga_PROJECT}.sta.rpt ${add_fpga_PROJECT}.sof
                       COMMAND ${QUARTUS_STA_EXECUTABLE} ${add_fpga_PROJECT}
                       DEPENDS ${add_fpga_PROJECT}.asm.rpt)
endfunction()
