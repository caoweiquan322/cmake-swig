| Linux | macOS | Windows |
|-------|-------|---------|
| [![Status][cpp_linux_svg]][cpp_linux_link] | [![Status][cpp_osx_svg]][cpp_osx_link] | [![Status][cpp_win_svg]][cpp_win_link] |


[cpp_linux_svg]: https://github.com/Mizux/cmake-swig/workflows/C++%20Linux%20CI/badge.svg
[cpp_linux_link]: https://github.com/Mizux/cmake-swig/actions?query=workflow%3A"C%2B%2B+Linux+CI"
[cpp_osx_svg]: https://github.com/Mizux/cmake-swig/workflows/C++%20MacOS%20CI/badge.svg
[cpp_osx_link]: https://github.com/Mizux/cmake-swig/actions?query=workflow%3A"C%2B%2B+MacOS+CI"
[cpp_win_svg]: https://github.com/Mizux/cmake-swig/workflows/C++%20Windows%20CI/badge.svg
[cpp_win_link]: https://github.com/Mizux/cmake-swig/actions?query=workflow%3A"C%2B%2B+Windows+CI"


# C++ Status
* [x] GNU/Linux
* [x] MacOS
* [x] Windows

# Introduction
This is a complete example of how to create a Modern [CMake](https://cmake.org/) C++ Project.
This project should run on GNU/Linux, MacOS and Windows.

# Dependencies
To complexify a little, the CMake project is composed of three libraries (`Foo`, `Bar` and `FooBar`)
and one executable `FooBarApp` with the following dependencies:  
```sh
CMakeSwig::Foo:
CMakeSwig::Bar:
CMakeSwig::FooBar: PUBLIC CMakeSwig::Foo PRIVATE CMakeSwig::Bar
CMakeSwig::FooBarApp: PRIVATE CMakeSwig::FooBar
```

# Codemap
The project layout is as follow:

* [CMakeLists.txt](CMakeLists.txt) Top-level for [CMake](https://cmake.org/cmake/help/latest/) based build.
* [cmake](cmake) Subsidiary CMake files.

* [Foo](Foo) Root directory for `Foo` library.
  * [CMakeLists.txt](Foo/CMakeLists.txt) for `Foo`.
  * [include](Foo/include) public folder.
    * [foo](Foo/include/foo)
      * [Foo.hpp](Foo/include/foo/Foo.hpp)
  * [python](Foo/python)
    * [CMakeLists.txt](Foo/python/CMakeLists.txt) for `Foo` Python.
    * [foo.i](Foo/python/foo.i) SWIG Python wrapper.
  * [dotnet](Foo/dotnet)
    * [CMakeLists.txt](Foo/dotnet/CMakeLists.txt) for `Foo` .Net.
    * [foo.i](Foo/dotnet/foo.i) SWIG .Net wrapper.
  * [java](Foo/java)
    * [CMakeLists.txt](Foo/java/CMakeLists.txt) for `Foo` Java.
    * [java/foo.i](Foo/java/foo.i) SWIG Java wrapper.
  * [src](Foo/src) private folder.
    * [src/Foo.cpp](Foo/src/Foo.cpp)
* [Bar](Bar) Root directory for `Bar` library.
  * [CMakeLists.txt](Bar/CMakeLists.txt) for `Bar`.
  * [include](Bar/include) public folder.
    * [bar](Bar/include/bar)
      * [Bar.hpp](Bar/include/bar/Bar.hpp)
  * [python](Bar/python)
    * [CMakeLists.txt](Bar/python/CMakeLists.txt) for `Bar` Python.
    * [bar.i](Bar/python/bar.i) SWIG Python wrapper.
  * [dotnet](Bar/dotnet)
    * [CMakeLists.txt](Bar/dotnet/CMakeLists.txt) for `Bar` .Net.
    * [bar.i](Bar/dotnet/bar.i) SWIG .Net wrapper.
  * [java](Bar/java)
    * [CMakeLists.txt](Bar/java/CMakeLists.txt) for `Bar` Java.
    * [java/bar.i](Bar/java/bar.i) SWIG Java wrapper.
  * [src](Bar/src) private folder.
    * [src/Bar.cpp](Bar/src/Bar.cpp)
* [FooBar](FooBar) Root directory for `FooBar` library.
  * [CMakeLists.txt](FooBar/CMakeLists.txt) for `FooBar`.
  * [include](FooBar/include) public folder.
    * [foobar](FooBar/include/foobar)
      * [FooBar.hpp](FooBar/include/foobar/FooBar.hpp)
  * [python](FooBar/python)
    * [CMakeLists.txt](FooBar/python/CMakeLists.txt) for `FooBar` Python.
    * [foobar.i](FooBar/python/foobar.i) SWIG Python wrapper.
  * [dotnet](FooBar/dotnet)
    * [CMakeLists.txt](FooBar/dotnet/CMakeLists.txt) for `FooBar` .Net.
    * [foobar.i](FooBar/dotnet/foobar.i) SWIG .Net wrapper.
  * [java](FooBar/java)
    * [CMakeLists.txt](FooBar/java/CMakeLists.txt) for `FooBar` Java.
    * [java/foobar.i](FooBar/java/foobar.i) SWIG Java wrapper.
  * [src](FooBar/src) private folder.
    * [src/FooBar.cpp](FooBar/src/FooBar.cpp)
* [FooBarApp](FooBarApp) Root directory for `FooBarApp` executable.
  * [CMakeLists.txt](FooBarApp/CMakeLists.txt) for `FooBarApp`.
  * [src](FooBarApp/src) private folder.
    * [src/main.cpp](FooBarApp/src/main.cpp)

# C++ Project Build
To build the C++ project, as usual:
```shell
cmake -S. -Bbuild
cmake --build build --target all -v
```

## Managing RPATH
Since we want to use the [CMAKE_BINARY_DIR](https://cmake.org/cmake/help/latest/variable/CMAKE_BINARY_DIR.html) to generate the wrapper package (e.g. python wheel package) as well as be able to test from the build directory.
We need to enable:
```cmake
set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
```
And have a finely tailored rpath for each library.

For `Foo` and `Bar` which depend on nothing:
```cmake
set(CMAKE_INSTALL_RPATH "$ORIGIN")
```

For `FooBar` which depend on `Foo` and `Bar`:
```cmake
set(CMAKE_INSTALL_RPATH "$ORIGIN:$ORIGIN/../Foo:$ORIGIN/../Bar")
```

For `FooBarApp` which depend on `FooBar`:
```cmake
set(CMAKE_INSTALL_RPATH "$ORIGIN/../lib:$ORIGIN/../FooBar")
```

# SWIG Wrapper Generation
Using [swig](https://github.com/swig/swig) to generate wrapper it's easy thanks to the modern
[UseSWIG](https://cmake.org/cmake/help/latest/module/UseSWIG.html) module (**CMake >= 3.14**).  

note: SWIG automatically put its target(s) in `all`, thus `make` will also call
swig and generate `_module.so`.

## Wrapper documentation

<nav for="language">
<a href="#python">Python 3</a> |
<a href="#dotnet">.Net</a> |
<a href="#java">Java</a>
</nav>

## [Python 3](#python)
See [python.md](doc/python.md).

## [Dotnet](#dotnet)
See [dotnet.md](doc/dotnet.md).

## [Java](#java)
See [java.md](doc/java.md).

# Contributing

The [CONTRIBUTING.md](./CONTRIBUTING.md) file contains instructions on how to
file the Contributor License Agreement before sending any pull requests (PRs).
Of course, if you're new to the project, it's usually best to discuss any
proposals and reach consensus before sending your first PR.

# License

Apache 2. See the LICENSE file for details.

# Disclaimer

This is not an official Google product, it is just code that happens to be
owned by Google.

