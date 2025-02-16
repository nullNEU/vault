# Contribution guide

## Prerequisites

To test the validity and functionality of the configuration files, you will need a [virtualization](https://www.ibm.com/think/topics/virtualization) software of your choice installed on your system.

### Recommended
- [VMWare](https://blogs.vmware.com/workstation/2024/05/vmware-workstation-pro-now-available-free-for-personal-use.html)
  - Review general instructions on how to [set up a new VM with VMWare](https://www.sysnettechsolutions.com/en/create-virtual-machine-vmware/)
- [Oracle VirtualBox](https://www.virtualbox.org/wiki/Downloads)
  - Review general instructions on how to [set up a new VM with VirtualBox](https://www.tomshardware.com/how-to/set-up-virtual-machines-with-virtualbox)

## See it running

### Ubuntu Server 22.04.5

- These are the minimum specifications of the VM you will be creating for testing the configuration files:
  - Storage: 30 GB
  - Memory: 4 GB
- Given below are some platform specific guidelines and tips while you create the VM on your system. 

  <details>

  <summary>VMWare</summary>

  While creating a new VM as outlined above, below are some of the specifics you need to keep in mind:
  - For the *ISO image* field, use the downloaded Ubuntu Server 22.04.5 ISO image from your system
  - Allocate other resources as specified above
  - Leave other settings on their default values

  > *Tested on VMWare Workstation Pro 17*

  </details>

  <details>

  <summary>VirtualBox</summary>

  While creating a new VM as outlined above, below are some of the specifics you need to keep in mind:
  - Giving a unique name to the VM is mandatory
  - For the *ISO image* field, use the downloaded Ubuntu Server 22.04.5 ISO image from your system
  - You can leave the *Unattended install* section as is
  - Allocate other resources as specified above  

  > *Tested on Oracle VirtualBox 7* 

  </details>

- Right before the VM boots up, you are required to modify a kernel boot parameter. Pressing `e` on the GRUB menu should take you to the screen that allows you to do the same. Change the `linux` parameter as follows:

  <details>

  <summary>VirtualBox</summary>

    Change `linux /casper/vmlinuz  ---` to `linux /casper/vmlinuz quiet autoinstall ds=nocloud\;s=https://raw.githubusercontent.com/nullNEU/vault/refs/heads/main/ubuntu-server-22-04-5/ ---`

  </details>

  <details>
  <summary>VirtualBox</summary>

  Change `linux /casper/vmlinuz autoinstall ds=nocloud\;s=/cdrom/ --- quiet splash noprompt noshell automatic-ubiquity debian-installer/locale=en_US keyboard-configuration/layoutcode=us languagechooser/language-name=English localechooser/supported-locales=en_US.UTF-8 countrychooser/shortlist=CT --` to `linux /casper/vmlinuz quiet autoinstall ds=nocloud\;s=https://raw.githubusercontent.com/nullNEU/vault/refs/heads/main/ubuntu-server-22-04-5/ --`
  </details>
- Press `F10` to continute booting with the added configuration. Your VM will take some time to apply the configuration according to the configuration files in the repository.
- As an intermediate step, you will be required to enter the [LUKS](https://itsfoss.com/luks/) passphrase which can be found [here](https://github.com/nullNEU/vault/blob/427c28141631d569ea7250d9a2bc05eef341bd8c/ubuntu-server-22-04-5/user-data#L34).
- Once the system has finished booting, you will be presented with a prompt simliar to the following: 
  ```bash
  vault-ubuntu-minimal login:
  ```
  Once you enter the login credentials for the system, you will be able to access the hardened OS.

## Taking up an issue
All issues about this project are tracked as [GitHub issues on this repository](https://github.com/nullNEU/vault/issues). Once you have a fair idea of what tasks have been completed, what are in progress, and what the project is about, you can go ahead and pick an issue to work on.

### Some helpful tips
- If you are a beginner, you might want to check issues marked with a [*good first issue*](https://github.com/nullNEU/vault/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22) tag.
- Once you decide on what you want to work on, let the maintainers of the project know that you are interested in working on it by commenting on the issue.

## Opening a PR
Once you are familiar with the project and can replicate aspects of it locally, you can make your contributions to it.
- Create a new fork of the repository by clicking on the *Fork* button
- Clone the forked repository to your local system
- Create a new branch on your local system
> [!IMPORTANT]
> Please ensure that you create a separate branch (from `main`) on your fork for each contribution and name it appropriately (not `main`) since it makes reviewing code easier.
  ```bash
  git checkout -b <your-branch-name> # creates a new branch and switches to it
  ```
- Make sure you figure out what issue you are working on!
- Once all your changes are done, commit them to your local branch
  ```bash
  git add . # adds all changed files to the commit
  git commit -m <your-commit-message> # creates a new commit with your commit message
  ```
> [!IMPORTANT]  
> Make sure to include a helpful commit message. 
> - A good commit message is clear, concise and conveys what the commit changes
> - Try writing commit messages in the imperative, i.e. *Add new page* and *Fix bug* instead of *Added new page* and *Fixes many bugs*
- Push it to your fork of the repository
  ```bash
  git push --set-upstream origin <your-branch-name>
  ```
- Go to the branch on your repository on GitHub. There should be an option that says *Open Pull Request*. 
  - This creates a new PR to the `main` branch of the original repository (by default).
  - Make any changes to the title/description as required
- Wait for someone to review your PR and merge it
  - If any changes are requested, please complete them as required.
  - Once the changes look good to the maintainers, they will be merged to the `main` branch!

## Reach out
If you are stuck at any point, feel free to reach out to us on our [Telegram channel](https://t.me/+S7uxWGwmLfY5NTk1).