

set(MYSRC Lambda.cpp)

add_executable(Lambda ${MYSRC})
target_compile_features(Lambda PUBLIC cxx_std_14)
include_directories(../..)
target_link_libraries(Lambda yakl)

set_source_files_properties(${MYSRC} PROPERTIES COMPILE_FLAGS "${YAKL_CXX_FLAGS}")
if ("${ARCH}" STREQUAL "CUDA")
  set_source_files_properties(${MYSRC} PROPERTIES LANGUAGE CUDA)
  include_directories(../../cub)
endif()
if ("${ARCH}" STREQUAL "HIP")
  include_directories(../../hipCUB/hipcub/include)
  include_directories(../../rocPRIM/rocprim/include)
endif()

add_test(NAME Lambda_test COMMAND ./Lambda)

