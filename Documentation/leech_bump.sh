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
    einfo "Usage: ${0} mode version|message"
    einfo "Supported modes are:"
    einfo " - bump"
    einfo " - commit"
    einfo " - repoman"
    einfo " - delete"
    einfo " - changelog"
    exit 1
fi

case "${1}" in
    bump|commit|repoman|delete|eapi|changelog) ;;
    *)
        eerror "Unknown mode ${1}"
        exit 1
        ;;
esac

mode=${1}
version=${2}

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
        einfo "Bumping ${atom} to ${version}"

        if [[ -e ${PN}-${version}.ebuild ]]; then
            ewarn "${atom} seems to be already bumped to ${version}, skipping work"
            cd - > /dev/null
            eoutdent
            continue
        fi

        ebegin "Copying ${PN}-9999.ebuild to ${PN}-${version}.ebuild"
        cp ${PN}-{9999,${version}}.ebuild
        eend $?
    
        ebegin "Setting keywords on ${PN}-${version}.ebuild"
        ekeyword ~amd64 ~x86 ${PN}-${version}.ebuild
        eend $?
    
        ebegin "Running repoman manifest on ${atom}"
        repoman manifest
        eend $?
    
        ebegin "Running cvs add ${PN}-${version}.ebuild"
        cvs add ${PN}-${version}.ebuild
        eend $?

        ebegin "Generating ChangeLog for ${atom}"
        changelog_helper --changelog "${4}" "Bump ${atom} to ${version}, thanks to 0xd34df00d"
        eend $?
        
        ;;
    commit)
        einfo "Commiting ${atom} with message \"${version}\""

        ebegin "Running repoman commit -m \"${version}\""
        repoman commit -m "${version}"
        eend $?

        ;;
    repoman)
        einfo "Running repoman in ${atom}"
        repoman fix

        ;;
    delete)
        einfo "Deleting ${PN}-${version}"
        
        rm ${PN}-${version}.ebuild
        cvs rm ${PN}-${version}.ebuild
        changelog_helper "${3}" "${4}" "Removed old ${PN}-${version}"

        ;;
    eapi)
        einfo "Changing EAPI to 4 in ${atom}-${version}"

        sed -i 's:EAPI="2":EAPI="4":' ${PN}-${version}.ebuild
        changelog_helper "${3}" "${4}" "Bumped to EAPI=\"4\""

        ;;
    changelog)
        einfo "Running echangelog in ${atom}"
        echangelog ${version}
    esac


    cd - > /dev/null
    eoutdent
done
