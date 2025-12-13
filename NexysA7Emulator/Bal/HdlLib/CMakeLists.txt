## START VERILATOR
add_library(HdlLib STATIC) # or SHARED for a shared library
set_target_properties(HdlLib PROPERTIES AUTOMOC OFF AUTOUIC OFF AUTORCC OFF)
target_compile_features(HdlLib PUBLIC cxx_std_14)


find_package(verilator REQUIRED)
if(NOT verilator_FOUND)
    message(
        FATAL_ERROR
        "Verilator was not found. Either install it, or set the VERILATOR_ROOT environment variable"
    )
endif()

set(VERILOG_SRC
    ${CMAKE_CURRENT_SOURCE_DIR}/hdl/types_pkg.sv
    ${CMAKE_CURRENT_SOURCE_DIR}/hdl/dec_cat_map.sv
    ${CMAKE_CURRENT_SOURCE_DIR}/hdl/bin_to_bcd.sv
    ${CMAKE_CURRENT_SOURCE_DIR}/hdl/seg_display_calc.sv
    ${CMAKE_CURRENT_SOURCE_DIR}/hdl/add_sub_mult.sv
    ${CMAKE_CURRENT_SOURCE_DIR}/hdl/select_action.sv
    ${CMAKE_CURRENT_SOURCE_DIR}/hdl/select_btn_action.sv
    ${CMAKE_CURRENT_SOURCE_DIR}/hdl/unbounce_btn.sv
    ${CMAKE_CURRENT_SOURCE_DIR}/hdl/unbounce_array.sv
    ${CMAKE_CURRENT_SOURCE_DIR}/hdl/top.sv
)

set(TOP_NAME "top")
message(STATUS "Verilator sources list contains: ${VERILOG_SRC}")
verilate(
   HdlLib
    SOURCES ${VERILOG_SRC}
    TOP_MODULE ${TOP_NAME}
    PREFIX "V${TOP_NAME}" # The C++ class prefix (e.g., VYourTopModuleName)
    # Add any extra Verilator flags here as arguments
    VERILATOR_ARGS -cc --trace --trace-structs --timing
)


## END_VERILATOR

