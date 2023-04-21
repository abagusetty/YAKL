#!/bin/bash
source reset_env.sh
module load PrgEnv-amd/8.3.3 craype-accel-amd-gfx90a

###############################################
## User configurable options
###############################################
export CTEST_BUILD_NAME=main-amdgcn-PrgEnv-amd8.3.3-debug
export CC=cc
export CXX=CC
export FC=ftn
export YAKL_ARCH="HIP"
export YAKL_VERBOSE=ON
export YAKL_VERBOSE_FILE=ON
export YAKL_DEBUG=ON
export YAKL_HAVE_MPI=ON
export YAKL_ENABLE_STREAMS=ON
export YAKL_AUTO_PROFILE=ON
export YAKL_PROFILE=ON
export YAKL_AUTO_FENCE=ON
export YAKL_B4B=ON
export YAKL_MANAGED_MEMORY=OFF
export YAKL_MEMORY_DEBUG=ON
export YAKL_TARGET_SUFFIX=""
export YAKL_F90_FLAGS="-O0 -g"
export YAKL_CXX_FLAGS=""
export YAKL_OPENMP_FLAGS=""
export YAKL_CUDA_FLAGS=""
export YAKL_HIP_FLAGS="-O0 -g -munsafe-fp-atomics -Wno-unused-result -D__HIP_ROCclr__ -D__HIP_ARCH_GFX90A__=1 --rocm-path=${ROCM_PATH} --offload-arch=gfx90a -x hip"
export YAKL_SYCL_FLAGS=""
export CTEST_GCOV=0
export CTEST_VALGRIND=0
export YAKL_UNIT_CXX_LINK_FLAGS="--rocm-path=${ROCM_PATH} -L${ROCM_PATH}/lib -lamdhip64"
export CMAKE_EXE_LINKER_FLAGS=" -L${ROCM_PATH}/lib -lamdhip64"
export MPI_COMMAND=""
# export GATOR_DISABLE=0
# export GATOR_INITIAL_MB=1024
# export GATOR_GROW_MB=1024
# export GATOR_BLOCK_BYTES=1024
###############################################

test_home=/lustre/orion/cli115/world-shared/yakl-testing
ctest_dir=`pwd`
export YAKL_CTEST_SRC=${test_home}/YAKL
export YAKL_CTEST_BIN=${test_home}/scratch
mkdir -p $YAKL_CTEST_BIN
rm -rf ${YAKL_CTEST_BIN}/*
cd $test_home
[ ! -d "${YAKL_CTEST_SRC}" ] && git clone git@github.com:mrnorman/YAKL.git
cd ${YAKL_CTEST_SRC}
git fetch origin
git checkout mrnorman/crusher-tests
git reset --hard origin/mrnorman/crusher-tests
cd ${ctest_dir}
ctest -j 8 -S ctest_script.cmake

