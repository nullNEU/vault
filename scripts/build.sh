#! /bin/bash

# function to detect the environment and return an appropriate file name
assign_file_name () {
    # check if it is a CI/CD environment like Github Actions
    if [ -v CI ]; then
        FILENAME="$1.iso"
    else
        IS_GIT=$(git rev-parse --is-inside-work-tree 2>&1)
        # check if it is a git repository like when in local development
        if [ $IS_GIT ]; then
            GIT_COMMIT=$(git rev-parse --short HEAD)
            DATE=$(date -u '+%Y%m%d')
            FILENAME="$1-$DATE.$GIT_COMMIT.iso"
        fi
    fi
    echo $FILENAME
}

# function to create builds for all linux operating systems in scope
build_linux_oses () {
    # array of URLs pointing to the base images of the operating system being handled
    # give official, downloadable URLs, preferably from the same source as provided in the README
    declare -a LINUXIMAGES=(
        "https://releases.ubuntu.com/22.04.5/ubuntu-22.04.5-live-server-amd64.iso"
    )

    # array of directory names as present in this project
    # this is used to copy and use the cloud-init config data
    declare -a LINUXOSDIRS=(
        "ubuntu-server-22-04-5"
    )

    # array of patched operating system names
    # preferably in the `vault-<base-operating-system>` format
    declare -a VAULTLINUXOSES=(
        "vault-ubuntu-minimal"
    )

    # get lengths of above mentioned arrays
    IMAGESLENGTH=${#LINUXIMAGES[@]}
    OSESLENGTH=${#LINUXOSDIRS[@]}
    VAULTSLENGTH=${#VAULTLINUXOSES[@]}

    # perform a check to confirm that all arrays have equal lengths
    # if not, exit with an appropriate message
    if [ $IMAGESLENGTH -ne $OSESLENGTH ] || [ $OSESLENGTH -ne $VAULTLINUXOSES ] || [ $IMAGESLENGTH -ne $VAULTLINUXOSES ]; then
        echo "IMAGESLENGTH, OSESLENGTH, VAULTLINUXOSES are not of equal lengths. Recheck array entries."
        exit 1
    fi

    # iterate through the list of operating systems and patch them with data from the cloud-init config files
    for (( i=0; i<${IMAGESLENGTH}; i++ ));
    do
        TARGETFILENAME=$(assign_file_name "${VAULTLINUXOSES[$i]}")
        echo "Creating patched OS: $TARGETFILENAME..."
        # download the base OS image
        curl -X GET -OL ${LINUXIMAGES[$i]}
        SOURCEISO=${LINUXIMAGES[$i]##*/}
        # extract the downloaded ISO image to the iso/ directory
        7z x -y $SOURCEISO -oiso

        # copy the cloud-init configuration files into the iso/nocloud directory
        mkdir -p iso/nocloud
        cp "${LINUXOSDIRS[$i]}/meta-data" iso/nocloud/
        cp "${LINUXOSDIRS[$i]}/user-data" iso/nocloud/

        ## TODO: think of how this can possibly be extended to
        ## other OSes. Do the boot kernel parameters change the
        ## same way? Will we need a if-else tree to do it?

        # modify boot related files
        sed -i -e 's/---/ autoinstall  ---/g' iso/boot/grub/grub.cfg
        sed -i -e 's/---/ autoinstall  ---/g' iso/boot/grub/loopback.cfg
        # modify kernel boot parameters to insert path to cloud-init config
        sed -i -e 's,---, ds=nocloud\\;s=/cdrom/nocloud/  ---,g'  iso/boot/grub/grub.cfg
        sed -i -e 's,---, ds=nocloud\\;s=/cdrom/nocloud/  ---,g' iso/boot/grub/loopback.cfg

        # create the final ISO image
        xorriso -as mkisofs -r \
            -V ${LINUXOSDIRS[$i]} \
            -o $TARGETFILENAME \
            -J \
            -c '/boot.catalog' \
            -b '/boot/grub/i386-pc/eltorito.img' \
            -no-emul-boot -boot-load-size 4 -boot-info-table --grub2-boot-info \
            -eltorito-alt-boot \
            -isohybrid-gpt-basdat -isohybrid-apm-hfsplus \
            iso/boot iso

        FILESIZE=$(stat -c %s $TARGETFILENAME 2>&1)
        # verify that the patched iso image file was created properly
        if [[ $FILESIZE > 0 ]]; then
            printf '%s (%d bytes) ... done!\n' $TARGETFILENAME $FILESIZE
        else
            printf 'Something went wrong while trying to build %s\n' $TARGETFILENAME
        fi

        # remove the iso/ directory
        sudo rm -rf iso
    done
}

build_linux_oses