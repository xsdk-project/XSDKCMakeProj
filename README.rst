===================================================
XSDKCMakeProj: Experiment with IDEAS XSDK settings
===================================================

This is a simple CMake project for demonstrating and testing the
implementation the xSDK specification for compatible CMake projects.

To configure and run the tests, just do::

  $ mkdir BUILD
  $ cd BUILD
  $ cmake \
     -D C_COMPILER_1=<fullPathC1> \
     -D C_COMPILER_2=<fullPathC2> ..
     -D CXX_COMPILER_1=<fullPathCxx1> \
     -D CXX_COMPILER_2=<fullPathCxx2> ..
     -D Fortran_COMPILER_1=<fullPathFortran1> \
     -D Fortran_COMPILER_2=<fullPathFortran2> ..
  $ ctest -j12

Here, a default C, C++, and Fortran compiler should also be found (by CMake
searching ``${PATH}``) which should be different than these two compilers
``<fullPathCxx1>`` and ``<fullPathCxx2>``.  These all have defaults set up to
look for standard GCC compilers installed in `/usr/bin/`.  But the default
compilers found by CMake should be in another directory.  See the file
CMakeLists.txt for details.

The XSDK defaults and behaviors are implemented in the reusable stand-alone
CMake module ``xsdk/XSDKDefaults.cmake``.  This directory can be snapshotted
into other projects that want to use this CMake module (see
[snapshot-dir.py](https://tribits.org/doc/TribitsDevelopersGuide.html#snapshot-dir-py-help)).

This particular GitHub CMake project `XSDKCmakeProj` tests the behavior of the
module ``XSDKDefaults.cmake`` by using a mock XSDK CMake project which is
contained in the directory::

  example_driver/

which contains a single ``CMakeLists.txt`` file.  See that file for where to
include the `XSDKDefaults.cmake` module.

For more details about `XSDKDefaults.cmake`, see the documentation at the top
the file `XSDKDefaults.cmake`.

NOTE: The outer test CMake project snapshots TriBITS core in order to use the
`TRIBITS_ADD_ADVANCED_TEST()`_ function in order to make it easier to write
stronger tests for ``XSDKDefaults.cmake``.  But this is **not** a TriBITS
project.

.. _TRIBITS_ADD_ADVANCED_TEST(): https://tribits.org/doc/TribitsDevelopersGuide.html#tribits-add-advanced-test 
