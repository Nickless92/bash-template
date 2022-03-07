#!/bin/bash
# FIXME: To achieve higher portability for systems, where bash is installed
#        somewhere else, you might use:
#!/usr/bin/env bash
#
# FIXME template - this script does hopefully something valuable.
# FIXME Search for FIXME strings - a finished script should'nt include any FIXME!
# FIXME The file currently is named "template.sh" to force syntax highlighting
#       in sereral tools, e.g. for code reviews. As the extension .sh is
#       usually avoided in Unix programs, rename the script just to show it's
#       purpose.
#
# SPDX-FileCopyrightText: 2022 Herbert Thielen <thielen@hs-worms.de>
# SPDX-License-Identifier: EUPL-1.2 or GPL-3.0-or-later
# For multi licensing syntax, see https://reuse.software/faq/#multi-licensing.
# FIXME: adapt the copyright notice and check with 'reuse lint'.
#
# This file shall be used as template for new bash scripts.
# This template was discussed and polished in the course "script programming"
# in summer term 2012 and following. Areas which have to be adapted are marked
# by FIXME. Search FIXME in your editor, change it to your needs and remove the
# FIXME. At the end, your new script shouldn't have any FIXME!
# FIXME: Replace this paragraph by a short description of your script's purpose.

# Shell configuration
# FIXME
set -o nounset                      # bash: abort on undefined variables

# User changeable configuration
# FIXME

# Initial option values
opt_h=0                             # -h help
opt_V=0                             # -V version
opt_d=0                             # -d debug output
opt_n=0                             # -n no-run
opt_v=0                             # -v verbose
opt_v_val=0                         # (default) value for -v counter
opt_c=0                             # -c count
opt_c_val=10                        # (default) value for -c argument

# FIXME The string '$Revision$' is replaced automatically be some older
#       version control tools like RCS, Subversion and similar tools.  As shell
#       scripts may still be managed by RCS on servers, this still makes some
#       sense. See `co(1)` for details on the version string management.
# FIXME You might remove the variables 'Revision' and 'Dummy' and manage
#       VERSION manually as demonstrated here.
#Revision="Version"                  # string for nice VERSION value below
#Dummy=                              # hide '$' in output of VERSION below
#VERSION="$Revision$Dummy"           # Dummy unterdrueckt '$'-Ausgabe
VERSION="0.1"                       # FIXME remember to update!

# Some more global variables
PROGNAME=${0##*/}                   # same as PROGNAME=$(basename "$0")
SIMULATE=                           # echo command for option '-s' (default: empty)
VECHO=:                             # echo command for option '-v' (default: no-op)
# FIXME - remove all parts with TMPFILE and MKTEMP if you don't need a TMPFILE
TMPFILE=                            # temporary file created by 'mktemp'
TMPTEMPLATE="${TMPDIR-/tmp}/$PROGNAME.XXXXXXXXXX"      # template for mktemp
MKTEMP="mktemp $TMPTEMPLATE"

# Exit Codes
EXIT_OK=0
EXIT_USAGE=64           # analogously to EX_USAGE in /usr/include/sysexits.h
EXIT_INTERNAL_ERROR=70  # EX_INTERNAL_ERROR in sysexits.h
EXIT_GENERAL_ERROR=80   # nothing similar in sysexits.h

# Output version and help.
# No parameters.
# Returns 0 on success.
usage()
{
    version
    cat <<-EOF

	FIXME
	Synopsis:
	 	$PROGNAME [-d] -h|-V
	 	$PROGNAME [-d] [-n] [-v [-v]] [-c count] arg [arg ...]
	
	$PROGNAME does whatever is described here. (FIXME)

	Options:
	 -d 	debug mode
	 -h 	print this help
	 -V 	print version number
	 -n 	"no-run", simulation only
	 -v 	be verbose; repeated '-v' raise verbosity
	 -c 	'count' loops or similar (default: $opt_c_val) (FIXME)

	Arguments:
	 	At least one file or directory, which ... FIXME

	Exit codes:
	 $EXIT_OK	success, no errors
	 $EXIT_USAGE	wrong options or wrong / missing arguments
	 $EXIT_INTERNAL_ERROR	internal logic error
	 $EXIT_GENERAL_ERROR	something general went wrong during execution
	EOF
    # FIXME: Remember the leading TABs in the using string which are removed due to '-EOF'!
}

# Print version information.
# No parameters.
# Returns 0 on success.
version()
{
    echo "$PROGNAME $VERSION"
}

# Print warning to stderr, but do not abort.
# $1: line number, $2.. text
warn()
{
    local line=$1
    shift
    echo >&2 "$PROGNAME@$line: Warning: $*"
}

# Print error to stderr, but do not abort.
# $1: line number, $2.. text
error()
{
    local line=$1
    shift
    echo >&2 "$PROGNAME@$line: ERROR: $*"
}

# Print error message and abort with error code.
# $1: error code, $2: line number, $3 ... error message
error_exit()
{
    local errcode=$1
    shift
    error "$@"
    exit $errcode
}

# Print error message, give usage hint (-h), and abort with $EXIT_USAGE.
# $1: line number, $2 ... error message
usage_error_exit()
{
    error "$@"
    echo >&2 "Use option -h for help."
    exit $EXIT_USAGE
}

# Print error message "internal error" and abort.
# $1: line number
internal_error_exit()
{
    error_exit $EXIT_INTERNAL_ERROR $1 \
        "Internal error - please notify author!"
}

# Check for valid decimal number (with or without sign, no octal value etc.)
# $1: string to check
# returns 0 for valid decimal numbers, 1 otherwise
is_decimal()
{
    [ $# -eq 1 ] || internal_error_exit $LINENO
    local num=$1

    # Regular expression: one or more zeros only, e.g. 0 00 000
    if [[ $num =~ ^00*$ ]]; then
        return 0
    fi

    # Regular expression: zero or one '-' (no positive sign), followed
    # by at least one digit '1' to '9' (no zero to forbid octal
    # numbers), followed by zero or more digits.
    if [[ $num =~ ^[-]?[1-9][0-9]*$ ]]; then
        # check for overflow; test e.g. with $(2**63-1) and $((2**63):
        #  is_decimal 9223372036854775807
        #  is_decimal -c 9223372036854775808
        if [[ $num != $((num)) ]]; then # string comparison!
            warn $LINENO "numeric overflow for $num"
            return 1
        fi
        return 0
    fi

    return 1
}

validate_options_or_exit()
{
    local opt opt_count=0

    while getopts :dhVnvc: opt  # FIXME
    do
        (( opt_count++ ))
        # FIXME modify case-branches according to parameters of 'getopts' above!
        case $opt in
            d) opt_d=1; PS4='-> $LINENO | '; set -x
               (( opt_count-- ))        # doesn't count for -h/-V check
               ;;
            h) opt_h=1; (( opt_count-- )) ;;
            V) opt_V=1; (( opt_count-- )) ;;
            n)
                # eval required due to output redirection which wouldn't be recognized otherwise 
                # (redirection is done before variable expansion)
                # Usage: e.g.
                # $SIMULATE rm -i *.bak
                SIMULATE="eval echo would >&2 "
                opt_n=1
                ;;
            v) opt_v=1; (( opt_v_val++ )); VECHO=echo ;;
            c) opt_c=1; opt_c_val=$OPTARG ;;
            :) usage_error_exit $LINENO "Missing argument for '-$OPTARG'" ;;
           \?) usage_error_exit $LINENO "Invalid option '$OPTARG'" ;;
            *) internal_error_exit $LINENO ;;
        esac
    done

    # Check for exclusive use of h/-V (just as an example or to make life harder).
    shift $(( $OPTIND - 1 ))
    if [ $((opt_h+opt_V)) -eq 1 -a $((opt_count+$#)) -gt 0 \
         -o $((opt_h+opt_V)) -eq 2 ]
    then
        usage_error_exit $LINENO "-h/-V have to be used exclusively"
    fi

    # FIXME adapt or remove, if not needed (maybe is_decimal() too!).
    # Check for valid opt_c_val
    if [ $opt_c -eq 1 ]; then
        # We want a positive deciaml value or zero.
        is_decimal "$opt_c_val" && [ $opt_c_val -ge 0 ] || \
            usage_error_exit $LINENO \
                "Option '-c $opt_c_val': Number has to be >= 0"
    fi
}

# FIXME - remove if you don't use a temporary file
create_tempfile_or_exit()
{
    # FIXME - but do not remove it if you need a temporary file
    #         for a meaningful simulation.
    if [ $opt_n -eq 1 ]; then
        $SIMULATE "$MKTEMP"
        return
    fi

    TMPFILE=$($MKTEMP) || \
        error_exit $EXIT_GENERAL_ERROR $LINENO \
            "couldn't create temporary file"
}

# cleanup is called at script's exit
cleanup()
{
    # FIXME - remove if you don't use a temporary file
    # remove TMPFILE only if created and no debug option
    if [ -f "$TMPFILE" ]; then
        if [ $opt_d -eq 0 ]; then
            $VECHO "rm -f -- \"$TMPFILE\""
            rm -f -- "$TMPFILE"
        else
            warn $LINENO \
                "Debug-Mode - '$TMPFILE' not removed automatically for debugging, do it yourself"
        fi
    fi
}

check_arguments_or_exit()
{
    # FIXME
    [ $# -ge 1 ] || usage_error_exit $LINENO "missing argument"

    # Loop on all arguments 
    for arg; do
        $VECHO "FIXME check for $arg"
    done
}

main()
{
    validate_options_or_exit "$@"
    shift $((OPTIND - 1))

    # -h / -V execution
    if [ $opt_h -eq 1 ]; then 
        usage || exit $EXIT_GENERAL_ERROR
        exit $EXIT_OK
    fi
    if [ $opt_V -eq 1 ]; then 
        version || exit $EXIT_GENERAL_ERROR
        exit $EXIT_OK
    fi

    check_arguments_or_exit "$@"

    # FIXME - remove if you don't use a temporary file
    # Create temporary file
    trap cleanup EXIT                   # ... and remove it at exit
    create_tempfile_or_exit

    # Loop on all arguments 
    for arg; do
        # FIXME
        $SIMULATE echo FIXME main for $arg
    done
}

main "$@"

# Editor auto configuration
# (maybe needs 'set modeline' in $HOME/.vimrc to be evaluated - but be aware of
# security risks)
# vim: sw=4 softtabstop=4 expandtab
