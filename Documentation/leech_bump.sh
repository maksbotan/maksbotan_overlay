#!/bin/sh

. /etc/init.d/functions.sh

if [[ -z "$1" ]] || [[ -z $2 ]]; then
    eerror "Not enough arguments"
    einfo "Usage: $0 mode version|message"
    einfo "Supported methods are:"
    einfo " - bump"
    einfo " - commit"
    einfo " - repoman"
    exit 1
fi
if [[ "$1" != "bump" ]] && [[ $1 != "commit" ]] && [[ $1 != "repoman" ]]; then
    eerror "Unknown mode $1"
    exit 1
fi

mode=$1
version=$2

#checking whether we are in portage tree or overlay
if ! [[ -e ./profiles/repo_name ]]; then
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
    if ! [[ $atom =~ leechcraft-* ]]; then
        continue
    fi
    einfo "Going to $atom"
    eindent
    cd $atom

    if [[ $mode == "bump" ]]; then
        einfo "Bumping $atom to $version"

        if [[ -e $PN-$version.ebuild ]]; then
            ewarn "$atom seems to be already bumped to $version, skipping work"
            cd - > /dev/null
            eoutdent
            continue
        fi

        ebegin "Copying $PN-9999.ebuild to $PN-$version.ebuild"
        cp $PN-{9999,$version}.ebuild
        eend $?
    
        ebegin "Setting keywords on $PN-$version.ebuild"
        ekeyword ~amd64 ~x86 $PN-$version.ebuild
        eend $?
    
        ebegin "Running repoman manifest on $atom"
        repoman manifest
        eend $?
    
        ebegin "Running cvs add $PN-$version.ebuild"
        cvs add $PN-$version.ebuild
        eend $?

        ebegin "Generating ChangeLog for $atom"
        echangelog "Bump $atom to $version, thanks to 0xd34df00d"
        eend $?
    elif [[ $mode == "commit" ]]; then
        einfo "Commiting $atom with message \"$version\""
        
        ebegin "Running repoman commit -m \"$version\""
        repoman commit -m "$version"
        eend $?
    else
        einfo "Running repoman in $atom"
        repoman fix
    fi


    cd - > /dev/null
    eoutdent
done
