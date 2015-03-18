# Similar code exist in VISPConfig.cmake

if(NOT DEFINED VISP_STATIC)
  # look for global setting
  if(NOT DEFINED BUILD_SHARED_LIBS OR BUILD_SHARED_LIBS)
    set(VISP_STATIC OFF)
  else()
    set(VISP_STATIC ON)
  endif()
endif()

if(MSVC)
  if(CMAKE_CL_64)
    set(VISP_ARCH x64)
  else()
    set(VISP_ARCH x86)
  endif()
  if(MSVC_VERSION EQUAL 1400)
    set(VISP_RUNTIME vc8)
  elseif(MSVC_VERSION EQUAL 1500)
    set(VISP_RUNTIME vc9)
  elseif(MSVC_VERSION EQUAL 1600)
    set(VISP_RUNTIME vc10)
  elseif(MSVC_VERSION EQUAL 1700)
    set(VISP_RUNTIME vc11)
  elseif(MSVC_VERSION EQUAL 1800)
    set(VISP_RUNTIME vc12)
  endif()
elseif(MINGW)
  set(VISP_RUNTIME mingw)

  execute_process(COMMAND ${CMAKE_CXX_COMPILER} -dumpmachine
                  OUTPUT_VARIABLE VISP_GCC_TARGET_MACHINE
                  OUTPUT_STRIP_TRAILING_WHITESPACE)
  if(VISP_GCC_TARGET_MACHINE MATCHES "64")
    set(MINGW64 1)
    set(VISP_ARCH x64)
  else()
    set(VISP_ARCH x86)
  endif()
endif()
