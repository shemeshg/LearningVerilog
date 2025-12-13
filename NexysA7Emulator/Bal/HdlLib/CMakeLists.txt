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
include(${CMAKE_CURRENT_SOURCE_DIR}/verilog_sources.cmake)

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
target_link_options(HdlLib PUBLIC
    "-Wl,-U,__Z15vl_time_stamp64v"
    "-Wl,-U,__Z13sc_time_stampv"
)
