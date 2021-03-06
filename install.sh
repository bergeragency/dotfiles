#! /usr/bin/env zsh

# The directory this script lives in.
DOTFILES_DIR=$0:a:h

# Symlink a local file into the user's home directory, making a backup if the original
# is a regular file.
#
# Usage:
#     safe-symlink <source_file> <target_file>
#
safe-symlink() {
    SOURCE_FILE=${1:?Invalid source file}
    TARGET_FILE=${2:?Invalid target file}

    # If a real file exists, back it up with the current timestamp.
    if [[ -f ~/${TARGET_FILE} && ! -h ~/${TARGET_FILE} ]]; then
        mv ~/${TARGET_FILE} ~/"${TARGET_FILE}-backup-$(date +"%F_%T")"
    fi

    # Symlink our version into place.
    ln -sf "${DOTFILES_DIR}/${SOURCE_FILE}" ~/${TARGET_FILE}
}

# Replace ~/.zshrc with the version from this repository
safe-symlink oh-my-zsh/.zshrc .zshrc

# Enable the `subl` command within our path.
ln -s /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/local/bin/subl &> /dev/null

# Prevent login messages by adding an empty .hushlogin file to the user's home directory.
touch ~/.hushlogin

# Load the .gitconfig file from the dotfiles.
safe-symlink git/.gitconfig .gitconfig

# RubyGems configuration
safe-symlink ruby/.gemrc .gemrc

# Custom sudo configuration
sudo cp -n "${DOTFILES_DIR}/etc/sudoers.d/vagrant_hostsupdater" /etc/sudoers.d/vagrant_hostsupdater \
    || echo 'Unable to copy to /etc/sudoers.d/vagrant_hostsupdater'

echo "Dotfiles have been installed successfully!"
