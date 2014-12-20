===================================================
XSDKCMakeProj: Experiment with IDEAS XSDK settings
===================================================

This is a simple CMake project for demonstrating how to to implement the xSDK
specification for compatible CMake projects.

To configure and run the tests, just do::

  $ mkdir BUILD
  $ cd BUILD
  $ cmake -DCXX_COMPILER_1=<fullPathCxx1> \
     -DCXX_COMPILER_2=<fullPathCxx2> ..
  $ ctest -j12

Here, a default C++ compiler should be found in the env var ``${PATH}`` which
different than these two compilers ``<fullPathCxx1>`` and ``<fullPathCxx2>``.
These have defaults ``/usr/bin/c++`` and ``/usr/bin/g++`` respectively.

The defaults and behaviors are implemented in the stand-alone CMake module
``XSDKDefaults.cmake``.

That way we test the behavior of the module ``XSDKDefaults.cmake`` is using a
mock XSDK CMake project which is contained in the directory::

  example_driver/

and contains a single ``CMakeLists.txt`` file.

NOTE: The outer test CMake project snapshots TriBITS core in order to use the
`TRIBITS_ADD_ADVANCED_TEST()`_ function in order to make it easier to write
stronger tests for ``XSDKDefaults.cmake``.  But this is **not** a TriBITS
project.

.. _TRIBITS_ADD_ADVANCED_TEST(): https://tribits.org/doc/TribitsDevelopersGuide.html#tribits-add-advanced-test 
