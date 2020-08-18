#!/bin/bash

function pushdd { 
  pushd $1 > /dev/null
}
function popdd {
  popd > /dev/null
}

baseurl="https://raw.githubusercontent.com/JuliaStrings/utf8proc/master"

pushdd libutf8proc
  rm utf8proc*
  wget "$baseurl/utf8proc.h"
  wget "$baseurl/utf8proc.c"
  wget "$baseurl/utf8proc_data.c"
popdd

cp libutf8proc/utf8proc.h tests/

pushdd tests
  wget "$baseurl/test/tests.c"
  wget "$baseurl/test/tests.h"

  for testcase in case charwidth custom iterate misc printproperty valid
  do
    rm -rf $testcase
    mkdir $testcase
    pushdd $testcase
      cp ../testcase_buildfile buildfile
      cp ../tests.c tests.c
      cp ../tests.h tests.h
      wget "$baseurl/test/${testcase}.c" -O driver.c
    popdd
  done

  rm tests.c tests.h
popdd

echo "ATTENTION! Needs manual removal of wcwidth references in tests/charwidth/driver.c before pushing /!\\"
