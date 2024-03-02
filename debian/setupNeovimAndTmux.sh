
#!/bin/bash
# Cloning your configs. 
echo "Cloning your config repos... Don't forget to replace the placeholders, I ain't doing it for you."
cd ~/install
git clone https://github.com/T-Wendel/tmux-config tmux-config
git clone https://github.com/T-Wendel/nvim-config neovim-config

# Moving configs into place. It's like setting up furniture, but less sweaty.
echo "Moving configs into their new homes... Look at you, being all organized."
cp -r ~/install/neovim-config/* ~/.config/nvim/
cp -r ~/install/tmux-config/* ~/.config/tmux/

