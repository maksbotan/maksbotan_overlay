#!/bin/bash

. /etc/init.d/functions.sh

#First argument is changelog arg, second is message arg, third is default message
changelog_helper() {
    if [[ "x${1}" == "x--changelog" ]]; then
        local message
        if [[ ${2} ]]; then
            message="${2}"
        else
            message="${3}"
        fi
        einfo "Running echangelog"
        echangelog ${message}
    fi
}

if [[ ${#} -lt 2 && ${1} != "repoman" ]]; then
    eerror "Not enough arguments"
    einfo "Usage: ${0} mode arguments"
    einfo "Supported modes are:"
    einfo " - bump"
    einfo " - commit"
    einfo " - repoman"
    einfo " - delete"
    einfo " - changelog"
    einfo " - keyword"
    einfo "Supported arguments are:"
    einfo " -m --message        Commit message"
    einfo " -c --changelog      Update ChangeLog"
    einfo " -N --no-changelog   Do not update ChangeLog"
    einfo " -v --version        Target version for bump"
    einfo " -f --bump-from      Source version for bump"
    einfo " -k --keyword        Keywords to set"
    exit 1
fi

case "${1}" in
    bump|commit|repoman|delete|changelog|keyword) ;;
    *)
        eerror "Unknown mode ${1}"
        exit 1
        ;;
esac

mode="${1}"
shift

while (($#)); do
    case "$1" in
        -m|--message)
            message="${2}"
            shift
            ;;
        -c|--changelog)
            run_changelog="1"
            shift
            ;;
        -N|--no-changelog)
            run_changelog="0"
            shift
            ;;
       -v|--version)
            version="${2}"
            shift
            ;;
        -f|--bump-from)
            bump_from="${2}"
            shift
            ;;
        -k|--keyword)
            keyword="${2}"
            shift
            ;;
        -*)
            eerror "Unknown option $1"
            ;;
        *)
            break
            ;;
    esac
    shift
done

case $mode in
    bump)
        if [[ -z "${version}" ]]; then
            eerror "Please specify target bump version"
            exit
        fi

        if [[ -z "${bump_from}" ]]; then
            bump_from=9999
        fi
        if [[ ${run_changelog} != "0" ]]; then
            run_changelog="1"
        fi
        if [[ -z "${message}" ]]; then
            message_stub=1
        fi
        ;;
    commit)
        if [[ -z "${message}" ]]; then
            eerror "Please specify commit message"
            exit
        fi
        ;;
    delete)
        if [[ -z "${version}" ]]; then
            eerror "Please specify version to remove"
            exit
        fi
        if [[ ${run_changelog} != "0" ]]; then
           run_changelog="1"
        fi
        ;;
    changelog)
        if [[ -z ${message} ]]; then
            eerror "Please specify ChangeLog message"
            exit
        fi
        ;;
    keyword)
        if [[ -z ${keyword} || -z ${version} ]]; then
            eerror "You must specify --keyword and --version arguments"
            exit
        fi
        ;;
esac

#checking whether we are in portage tree or overlay
if [[ ! -e ./profiles/repo_name ]]; then
    eerror "$(pwd) is not valid Gentoo Repository"
    eerror "Please cd to valid Gentoo repository before running $0"
    exit 1
fi

einfo "Scanning tree for LeechCraft packages"
echo

for atom in */*; do
    CATEGORY=${atom%/*}
    PN=${atom#*/}
    if [[ $CATEGORY == "eclass" ]]; then
        continue
    fi
    if [[ ${PN} != leechcraft-* ]]; then
        continue
    fi
    einfo "Going to ${atom}"
    eindent
    cd ${atom}

    case ${mode} in
    bump)
        if [[ "${message_stub}" == "1" ]]; then
            message="Bump ${atom} to ${version}, thanks to 0xd34df00d"

        fi

        einfo "Bumping ${atom} to ${version}"

        if [[ -e ${PN}-${version}.ebuild ]]; then
            ewarn "${atom} seems to be already bumped to ${version}, skipping work"
            cd - > /dev/null
            eoutdent
            continue
        fi

        if ! [[ -e "${PN}-${bump_from}.ebuild" ]]; then
            ewarn "${atom} lacks ${bump_from} version, skipping bump"
            cd - > /dev/null
            eoutdent
            continue
        fi

        ebegin "Copying ${PN}-${bump_from}.ebuild to ${PN}-${version}.ebuild"
        cp ${PN}-{${bump_from},${version}}.ebuild
        eend $?
    
        ebegin "Setting keywords on ${PN}-${version}.ebuild"
        ekeyword ~all ${PN}-${version}.ebuild > /dev/null
        eend $?
    
        ebegin "Running repoman manifest on ${atom}"
        repoman manifest > /dev/null
        eend $?
    
        ebegin "Running cvs add ${PN}-${version}.ebuild"
        cvs add ${PN}-${version}.ebuild > /dev/null
        eend $?

        if [[ ${run_changelog} == "1" ]]; then
            ebegin "Generating ChangeLog for ${atom}"
            echangelog ${message} > /dev/null
            eend $?
        fi

        ;;
    commit)
        einfo "Commiting ${atom} with message \"${message}\""

        ebegin "Running repoman commit -m \"${message}\""
        if [[ ${run_changelog} == "0" ]]; then
            changelog_arg="--echangelog=n"
        else
            changelog_arg=""
        fi
        repoman commit ${changelog_arg} -m "${message}"

        ;;
    repoman)
        einfo "Running repoman in ${atom}"
        repoman fix

        ;;
    delete)
        if [[ -z "${message}" ]]; then
            message="Removed old ${PN}-${version}"
        fi

        ebegin "Deleting ${PN}-${version}"
        rm ${PN}-${version}.ebuild
        cvs rm ${PN}-${version}.ebuild > /dev/null
        eend $?

        if [[ ${run_changelog} == "1" ]]; then
            ebegin "Generating changelog in ${atom}"
            echangelog ${message} > /dev/null
            eend $?
        fi

        ebegin "Running repoman manifest on ${atom}"
        repoman manifest > /dev/null
        eend $?

        ;;
    changelog)
        ebegin "Running echangelog in ${atom}"
        echangelog ${message} > /dev/null
        eend $?

        ebegin "Running repoman manifest on ${atom}"
        repoman manifest > /dev/null
        eend $?

        ;;
    keyword)
        if [[ ! -e ${PN}-${version}.ebuild ]]; then
            ewarn "${PN} doesn't have ${version} version, skipping"
            eoutdent
            cd - > /dev/null
            continue
        fi

        ebegin "Running ekeyword in ${atom}"
        ekeyword ${keyword} ${PN}-${version}.ebuild > /dev/null
        eend $?

        ebegin "Running repoman manifest on ${atom}"
        repoman manifest > /dev/null
        eend $?

        ;;
    esac


    cd - > /dev/null
    eoutdent
done
