#!/bin/bash

source $MODULESHOME/init/bash
module load PrgEnv-amd craype-accel-amd-gfx908

export CTEST_BUILD_NAME=master-serial-gnu-opt

unset GATOR_DISABLE
unset OMP_NUM_THREADS
unset CXXFLAGS
unset FFLAGS
unset CFLAGS
unset FCLAGS
unset CUDAARCHS
unset CUDACXX
unset CUDAFLAGS
unset CUDAHOSTCXX
unset HIPCXX
unset HIPFLAGS

export CC=cc
export CXX=CC
export FC=ftn

test_home=/gpfs/alpine/stf006/scratch/imn/yakl_ctest/spock

export YAKL_CTEST_SRC=${test_home}/../YAKL
export YAKL_CTEST_BIN=${test_home}/scratch
export CTEST_YAKL_ARCH="HIP"
export CTEST_HIP_FLAGS="-O3"
export CTEST_C_FLAGS="-O3"
export CTEST_F90_FLAGS="-O3"
export CTEST_LD_FLAGS=""
export CTEST_GCOV=0
export CTEST_VALGRIND=0
export CTEST_MPI_COMMAND=""

ctest_dir=`pwd`
cd ${YAKL_CTEST_SRC}
git fetch origin
git checkout master
git reset --hard origin/master
git submodule update --init --recursive

rm -rf /gpfs/alpine/stf006/scratch/imn/yakl_ctest/spock/scratch/*

cd ${ctest_dir}

ctest -S ctest_script.cmake
