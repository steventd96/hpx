# Copyright (c) 2007-2011 Hartmut Kaiser
# Copyright (c) 2011      Bryce Lelbach
#
# Distributed under the Boost Software License, Version 1.0. (See accompanying 
# file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

set(HPX_ADDCOMPONENT_LOADED TRUE)

include(HPX_Include)

hpx_include(Message
            ParseArguments
            Install)

macro(add_hpx_component name)
  # retrieve arguments
  hpx_parse_arguments(${name}
    "MODULE;SOURCES;HEADERS;DEPENDENCIES;INI" "ESSENTIAL" ${ARGN})

  hpx_print_list("DEBUG" "add_component.${name}" "Sources for ${name}" ${name}_SOURCES)
  hpx_print_list("DEBUG" "add_component.${name}" "Headers for ${name}" ${name}_HEADERS)
  hpx_print_list("DEBUG" "add_component.${name}" "Dependencies for ${name}" ${name}_DEPENDENCIES)
  hpx_print_list("DEBUG" "add_component.${name}" "Configuration files for ${name}" ${name}_INI)

  if(${name}_ESSENTIAL)
    add_library(${name}_component SHARED 
      ${${name}_SOURCES} ${${name}_HEADERS})
  else()
    add_library(${name}_component SHARED EXCLUDE_FROM_ALL
      ${${name}_SOURCES} ${${name}_HEADERS})
  endif() 

  set(prefix "")

  if(NOT MSVC)
    target_link_libraries(${name}_component
      ${${name}_DEPENDENCIES} ${hpx_LIBRARIES} ${BOOST_FOUND_LIBRARIES})
    set(prefix "hpx_component_")
    # main_target is checked by the ini install code, to see if ini files for
    # this component need to be installed
    set(main_target lib${prefix}${name}.so)
    set(install_targets
      lib${prefix}${name}.so
      lib${prefix}${name}.so.${HPX_SOVERSION}
      lib${prefix}${name}.so.${HPX_VERSION})
  else()
    target_link_libraries(${name}_component
      ${${name}_DEPENDENCIES} ${hpx_LIBRARIES} ${BOOST_FOUND_LIBRARIES})
    set(main_target ${name}.dll)
    set(install_targets ${name}.dll)
  endif()

  # set properties of generated shared library
  set_target_properties(${name}_component PROPERTIES
    # create *nix style library versions + symbolic links
    VERSION ${HPX_VERSION}      
    SOVERSION ${HPX_SOVERSION}
    # allow creating static and shared libs without conflicts
    CLEAN_DIRECT_OUTPUT 1 
    OUTPUT_NAME ${prefix}${name})
  
  set_property(TARGET ${name}_component APPEND
               PROPERTY COMPILE_DEFINITIONS
               "HPX_COMPONENT_NAME=${name}"
               "HPX_COMPONENT_EXPORTS")
  
  if(NOT ${name}_MODULE)
    set(${name}_MODULE "Unspecified")
    hpx_warn("add_component.${name}" "Module was not specified for component.")
  endif()

  if(${name}_ESSENTIAL) 
    install(TARGETS ${name}_component
      RUNTIME DESTINATION lib
      ARCHIVE DESTINATION lib
      LIBRARY DESTINATION lib
      COMPONENT ${${name}_MODULE}
      PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE
                  GROUP_READ GROUP_EXECUTE
                  WORLD_READ WORLD_EXECUTE)

    if(${name}_INI)
      install(FILES ${${name}_INI}
        DESTINATION ${CMAKE_INSTALL_PREFIX}/share/hpx/ini
        COMPONENT ${${name}_MODULE}
        PERMISSIONS OWNER_READ OWNER_WRITE 
                    GROUP_READ 
                    WORLD_READ)
    endif()
  else()
    foreach(target ${install_targets})
      hpx_component_install(${${name}_MODULE} ${target})
    endforeach()

    foreach(target ${${name}_INI})
      hpx_ini_install(${${name}_MODULE} ${main_target} ${target})
    endforeach()
  endif()
endmacro()

