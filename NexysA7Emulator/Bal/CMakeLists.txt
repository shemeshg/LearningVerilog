# [[[cog
# import cog
# from CMakeCog import getCmake
# cog.outl(getCmake())
# ]]]

SET(GEN_HPP TRUE)
if(GEN_HPP)
    make_directory(${CMAKE_CURRENT_BINARY_DIR}/hpp)
make_directory(${CMAKE_CURRENT_BINARY_DIR}/prptHpp)


    set(HPP_GEN_FILES
        ${CMAKE_SOURCE_DIR}/scripts/hppTemplates.txt
        ${CMAKE_CURRENT_SOURCE_DIR}/hpp/mytype.hpp
${CMAKE_CURRENT_SOURCE_DIR}/prptHpp/MyTypePrivate.hpp
    )
    add_custom_target(runScript_c7e9047dcad220c49dd24c7e1404b79292ba93d4d1bbef3bb841f56e27c53d60 ALL
        COMMAND python3 ${CMAKE_SOURCE_DIR}/scripts/parseHpp.py ${HPP_GEN_FILES}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Running parseHpp shell script")

    # Run a shell script before everything else
    execute_process(
        COMMAND python3 ${CMAKE_SOURCE_DIR}/scripts/parseHpp.py ${HPP_GEN_FILES}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        RESULT_VARIABLE result
    )

    # Check the result of the script execution
    if(NOT result EQUAL 0)
        message(FATAL_ERROR "Script execution failed with result: ${result}")
    endif()

    # Continue with the rest of your CMake configuration
endif()
                     

find_package(QT NAMES Qt6 Qt5 COMPONENTS Concurrent Gui REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Concurrent Gui REQUIRED)


add_library(Bal STATIC
  ${CMAKE_CURRENT_BINARY_DIR}/hpp/mytype.cpp
${CMAKE_CURRENT_BINARY_DIR}/hpp/mytype.h
${CMAKE_CURRENT_BINARY_DIR}/prptHpp/MyTypePrivate.h
)        
                     

qt6_add_qml_module(Bal
        URI Bal
        VERSION 1.0
        SOURCES
         )


target_include_directories(Bal PRIVATE ${CMAKE_CURRENT_BINARY_DIR}/hpp
${CMAKE_CURRENT_BINARY_DIR}/prptHpp)                     
        
target_link_libraries(Bal PRIVATE Qt${QT_VERSION_MAJOR}::Concurrent
Qt${QT_VERSION_MAJOR}::Gui) 

if(GEN_HPP)
  add_dependencies(Bal runScript_c7e9047dcad220c49dd24c7e1404b79292ba93d4d1bbef3bb841f56e27c53d60)
endif()
        
# [[[end]]]