#!/bin/bash

# Forked from Zeste de Savoir:
# https://github.com/zestedesavoir/zds-site/blob/dev/scripts/install_texlive.sh

EXTRA_PACKAGES="xpatch minted fvextra ifplatform xstring framed capt-of menukeys multirow longtable tabu adjustbox collectbox relsize tikz ntheorem catoptions varwidth blindtext cm-super"

if [[ -f $HOME/.texlive/bin/x86_64-linux/tlmgr ]]; then
  echo "Using cached texlive install"
else
  # force cache upload after successful build
  touch $HOME/.cache_updated
  echo "Installing texlive to \$HOME/.texlive"
  rm -rf $HOME/.texlive
  TEXLIVE_PROFILE=${BASH_SOURCE[0]/%install_texlive.sh/texlive.profile}

  # Creating install dir
  mkdir -p $HOME/.texlive/
  cp $TEXLIVE_PROFILE $HOME/.texlive/
  cd $HOME/.texlive/

  # Replace correct paths in profile (needs absolute paths)
  sed -i 's@\$HOME@'"$HOME"'@' texlive.profile

  # Download and run installer
  wget -O install-tl.tar.gz http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
  tar xzf install-tl.tar.gz

  ./install-tl*/install-tl -profile texlive.profile

  # Install extra latex packages
  ./bin/x86_64-linux/tlmgr install $EXTRA_PACKAGES

  echo "Installation complete !"
fi

# Symlink the binaries to ~/bin
for i in $HOME/.texlive/bin/x86_64-linux/*; do
  ln -sf $i $HOME/bin/
done
