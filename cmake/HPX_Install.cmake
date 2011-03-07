# Copyright (c) 2011 Bryce Lelbach
#
# Distributed under the Boost Software License, Version 1.0. (See accompanying 
# file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

# Abusive hacks that allow us to have installable targets that are not built
# by default

set(HPX_INSTALL_LOADED TRUE)

macro(hpx_install module bin)
  set(install_code
      "file(INSTALL FILES ${CMAKE_CURRENT_BINARY_DIR}/${bin}
            DESTINATION ${CMAKE_INSTALL_PREFIX}/bin
            TYPE EXECUTABLE 
            OPTIONAL
            PERMISSIONS OWNER_READ OWNER_EXECUTE OWNER_WRITE
                        GROUP_READ GROUP_EXECUTE
                        WORLD_READ WORLD_EXECUTE)")
  install(CODE "${install_code}" COMPONENT ${module})
endmacro()

macro(hpx_component_install module lib)
  set(install_code
      "file(INSTALL FILES ${CMAKE_CURRENT_BINARY_DIR}/${lib}
            DESTINATION ${CMAKE_INSTALL_PREFIX}/lib
            TYPE SHARED_LIBRARY 
            OPTIONAL
            PERMISSIONS OWNER_READ OWNER_EXECUTE OWNER_WRITE
                        GROUP_READ GROUP_EXECUTE
                        WORLD_READ WORLD_EXECUTE)")
  install(CODE "${install_code}" COMPONENT ${module})
endmacro()

macro(hpx_ini_install module name ini)
  set(install_code
      "if(EXISTS "${name}")
          file(INSTALL FILES ${CMAKE_CURRENT_SOURCE_DIR}/${ini}
               DESTINATION ${CMAKE_INSTALL_PREFIX}/share/hpx/ini
               OPTIONAL
               PERMISSIONS OWNER_READ OWNER_WRITE 
                           GROUP_READ 
                           WORLD_READ)
       endif()")
  install(CODE "${install_code}" COMPONENT ${module})
endmacro()

