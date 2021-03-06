#!/bin/bash

source $MODULESHOME/init/bash
module purge
module load DefApps pgi cmake

./cmakeclean.sh

unset GATOR_DISABLE

export CC=mpicc
export CXX=mpic++
export CXXFLAGS="-O0 -g -DYAKL_DEBUG"
export FFLAGS="-O0 -g"

cmake ..

