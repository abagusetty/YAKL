#!/bin/bash

../../cmakeclean.sh

unset GATOR_DISABLE

export CC=gcc
export CXX=g++
export FC=gfortran
unset CXXFLAGS
unset FFLAGS

cmake -DYAKL_ARCH="CUDA"                                                                               \
      -DYAKL_CUDA_FLAGS="-O3 -arch sm_35 --use_fast_math -ccbin g++ -DTHRUST_IGNORE_CUB_VERSION_CHECK" \
      -DYAKL_C_FLAGS="-O3"                                                                             \
      -DYAKL_F90_FLAGS="-O3"                                                                           \
      ../../..
