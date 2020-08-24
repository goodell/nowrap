#!/bin/sh
#
# a simple test script for a few more exotic wrapping cases
#

# allow override from the environment
: ${NOWRAP:=../nowrap}
: ${DIFF:=diff -q}
: ${TIMEOUT:=timeout}
: ${TAB_STOP:=8}

#set -x

rm -f *.out BOGUS

do_test() {
    prefix="$1"
    shift

$TIMEOUT --foreground 2s $NOWRAP "$@" $prefix.in > $prefix.out
status=$?
if [[ $status -ne 0 ]] ; then
    echo "ERROR: $prefix failed (timed out)"
    err=1
    return
fi

if $DIFF $prefix.expected $prefix.out ; then
    :
else
    echo "ERROR: $prefix failed (expected != output)"
    err=1
fi
}

# test an expected script failure (not timeout, no output comparison)
# function args are just extra args to nowrap
exp_fail() {
    $TIMEOUT --foreground 1s $NOWRAP "$@" >/dev/null 2>&1
    status=$?
    if [[ $status -eq 124 ]] ; then
        echo "ERROR: expected '--wrap --columns=$i' to fail, it timed out instead"
        err=1
    elif [[ $status -eq 0 ]] ; then
        echo "ERROR: expected '--wrap --columns=$i' to fail, it succeeded"
        err=1
    fi
}

# ==== prerequisite checks
if which $TIMEOUT >/dev/null 2>&1 ; then
    :
else
    echo "ERROR: missing GNU timeout, please install coreutils (e.g., brew install coreutils)"
    echo "and/or set \$TIMEOUT"
    exit 1
fi

# ==== case 0: simple text, asking for narrower
do_test tc0 --columns=72

# ==== case 1: simple text but asking for wider wrap than most of the text
do_test tc1 --columns=140

# ==== case 2: simple text but don't specify columns
do_test tc2

# ==== case 3: colored text, don't specify columns
assumed_cols=238
if test `tput cols` != $assumed_cols ; then
    echo "columns are "`tput cols`" not $assumed_cols, skipping test 3"
else
    do_test tc3
fi

# ==== case 4: colored text, ask for narrower
do_test tc4 --columns=72

# ==== case 5: utf-8 text with wide characters
do_test tc5 --columns=72

# ==== case 6: tabs in columns
do_test tc6 --columns=72

# ==== case 7: UTF-8-demo.txt @ 40 columns
do_test tc7 --columns=40

# ==== wrap
do_test tcwrap --wrap --columns=10
do_test tcindent-plain --wrap --indent-string '> ' --columns=10
do_test tcindent-tab --wrap --indent-string '	' --columns=18
do_test tcindent-ansi --wrap --indent-string '[01;41m|[0m' --columns=10
do_test tcindent-unicode --wrap --indent-string '«日»' --columns=10

# ==== passing an overly-long indent-string (or overly short columns) should
# result in an error
if [[ $TAB_STOP -eq 8 ]] ; then
    exp_fail --wrap --indent-string '«日日日日日日日»' --columns=9
else
    echo "\$TAB_STOP is not 8, skipping --indent-string length case"
fi

# ==== ensure that wrapping at smaller than 8 is prohibited to avoid infinite
# looping/misrendering on tabs
for i in $( seq 0 $(($TAB_STOP - 1)) ) ; do
    exp_fail --wrap --columns=$i tcindent-tab.in
done

if test -z "$err" ; then
    echo "PASS"
    rm -f *.out BOGUS
else
    echo "FAIL"
    exit 1
fi

# make sure nowrap doesn't invoke 'tput' if '-c' is passed
(
    # TERM is the one that matters (breaks 'tput cols'), but COLUMNS and LINES
    # are to avoid any clever fallback that might get added to nowrap in the
    # future
    unset TERM
    unset COLUMMS
    unset LINES

    # send stderr to /dev/null because nohup always warns about redirecting its output
    nohup ${NOWRAP} --columns=72 tc0.in 2>/dev/null
    status=$?
    if [[ $status -ne 0 ]] ; then
        echo "ERROR: non-zero exit code ($status)"
    fi

    if $DIFF tc0.expected nohup.out ; then
        :
    else
        echo "ERROR: nohup run failed (expected != output)"
    fi

    rm -f nohup.out
)
