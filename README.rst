===================================================
XSDKCMakeProj: Experiment with IDEAS XSDK settings
===================================================

This is a simple CMake project for demonstrating and testing the
implementation the xSDK specification for compatible CMake projects.

To configure and run the tests, just do::

  $ mkdir BUILD
  $ cd BUILD
  $ cmake -DCXX_COMPILER_1=<fullPathCxx1> \
     -DCXX_COMPILER_2=<fullPathCxx2> ..
  $ ctest -j12

Here, a default C++ compiler should also be found (by CMake searching
``${PATH}``) which should be different than these two compilers
``<fullPathCxx1>`` and ``<fullPathCxx2>``.  The variables ``CXX_COMPILER_1``
and ``CXX_COMPILER_2`` have defaults ``/usr/bin/c++`` and ``/usr/bin/g++``,
respectively, so adjust these if one of these matches the default compiler in
``${PATH}``.

The XSDK defaults and behaviors are implemented in the stand-alone CMake
module ``XSDKDefaults.cmake``.

That way this CMake projects tests the behavior of the module
``XSDKDefaults.cmake`` is using a mock XSDK CMake project which is contained
in the directory::

  example_driver/

which contains a single ``CMakeLists.txt`` file.

NOTE: The outer test CMake project snapshots TriBITS core in order to use the
`TRIBITS_ADD_ADVANCED_TEST()`_ function in order to make it easier to write
stronger tests for ``XSDKDefaults.cmake``.  But this is **not** a TriBITS
project.

.. _TRIBITS_ADD_ADVANCED_TEST(): https://tribits.org/doc/TribitsDevelopersGuide.html#tribits-add-advanced-test 
