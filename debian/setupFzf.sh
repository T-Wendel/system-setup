#!/bin/bash
echo '#!/bin/bash
selection=$(find . \( -type f -o -type d \) -print 2>/dev/null | fzf --height 50% --border --preview '\''if [ -d {} ]; then ls {}; else batcat --color=always {}; fi'\'')
if [ -n "$selection" ]; then
	  nvim "$selection"
fi' > ~/scripts/fzf.sh
chmod +x ~/scripts/fzf.sh

source ~/.bashrc
