# Copyright (c) 2007-2016 Hartmut Kaiser
#
# SPDX-License-Identifier: BSL-1.0
# Distributed under the Boost Software License, Version 1.0. (See accompanying
# file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

include(HPX_AddLibrary)

if(HPX_WITH_PARCEL_COALESCING)
  hpx_debug("add_coalescing_module")
  add_hpx_library(
    parcel_coalescing INTERNAL_FLAGS PLUGIN
    SOURCES
      "${PROJECT_SOURCE_DIR}/plugins/parcel/coalescing/coalescing_message_handler.cpp"
      "${PROJECT_SOURCE_DIR}/plugins/parcel/coalescing/coalescing_counter_registry.cpp"
      "${PROJECT_SOURCE_DIR}/plugins/parcel/coalescing/performance_counters.cpp"
    HEADERS
      "${PROJECT_SOURCE_DIR}/hpx/plugins/parcel/coalescing_message_handler_registration.hpp"
      "${PROJECT_SOURCE_DIR}/hpx/plugins/parcel/coalescing_message_handler.hpp"
      "${PROJECT_SOURCE_DIR}/hpx/plugins/parcel/coalescing_counter_registry.hpp"
      "${PROJECT_SOURCE_DIR}/hpx/plugins/parcel/message_buffer.hpp"
    FOLDER "Core/Plugins/MessageHandler" ${HPX_WITH_UNITY_BUILD_OPTION}
  )

  if(TARGET APEX::apex)
    target_link_libraries(parcel_coalescing PRIVATE APEX::apex)
  endif()
  target_compile_definitions(
    parcel_coalescing PRIVATE HPX_PARCEL_COALESCING_MODULE_EXPORTS
  )

  add_hpx_pseudo_dependencies(plugins.parcel.coalescing parcel_coalescing)
  add_hpx_pseudo_dependencies(core plugins.parcel.coalescing)
endif()
