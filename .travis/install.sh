#!/usr/bin/env bash
set -x
set -e

function install-swig() {
  if [[ "$TRAVIS_OS_NAME" == "linux" ]]; then
    # apt-get only have swig 2.0.11
    # Need SWIG >= 3.0.8
    cd /tmp/
    wget https://github.com/swig/swig/archive/rel-4.0.1.tar.gz
    tar zxf rel-4.0.1.tar.gz
    cd swig-rel-4.0.1
    ./autogen.sh
    ./configure --prefix "${HOME}"/swig/ 1>/dev/null
    make >/dev/null
    make install >/dev/null
  elif [ "$TRAVIS_OS_NAME" == "osx" ]; then
    brew install swig
  fi
}

function install-python(){
  if [[ "$TRAVIS_OS_NAME" == "linux" ]]; then
    # work around https://github.com/travis-ci/travis-ci/issues/8363
    pyenv global 3.7
    python --version
    python -m pip --version
    python -m pip install virtualenv wheel six
  elif [ "$TRAVIS_OS_NAME" == "osx" ]; then
    python3 -m pip install virtualenv wheel six
  fi
}

function install-dotnet-sdk(){
  if [[ "$TRAVIS_OS_NAME" == "linux" ]]; then
    # see https://docs.microsoft.com/en-us/dotnet/core/install/linux-package-manager-ubuntu-1804
    sudo apt-get install -yq apt-transport-https
    wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
    sudo dpkg -i packages-microsoft-prod.deb
    sudo apt-get update -qq
    sudo apt-get install -yq dotnet-sdk-3.1
  elif [ "$TRAVIS_OS_NAME" == "osx" ]; then
    brew tap homebrew/cask-cask
    brew cask install dotnet-sdk
    dotnet --info
  fi
}

function install-java(){
  if [[ "$TRAVIS_OS_NAME" == "linux" ]]; then
    java -version
  elif [ "$TRAVIS_OS_NAME" == "osx" ]; then
    brew cask install java
    java -version
  fi
}

eval "${MATRIX_EVAL}"

if [[ "$TRAVIS_OS_NAME" == "linux" ]]; then
  /usr/bin/x86_64-linux-gnu-ld --version
elif [ "$TRAVIS_OS_NAME" == "osx" ]; then
  brew update
fi

if [[ "$LANGUAGE" != "cpp" ]]; then
  install-swig
fi

if [[ "$LANGUAGE" == "python" ]]; then
  install-python
elif [[ "$LANGUAGE" == "dotnet" ]]; then
  install-dotnet-sdk
elif [[ "$LANGUAGE" == "java" ]]; then
  install-java
fi
# vim: set tw=0 ts=2 sw=2 expandtab:
