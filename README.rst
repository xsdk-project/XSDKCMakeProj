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
That way we can test the behavior of our mock xDSK CMake project which is
contained in the directory::

  example_driver/
