# kill default zsh prompt
unset PROMPT
unset RPROMPT
unset PS1

# starship prompt
eval "$(starship init zsh)"


source /home/zorax/.config/broot/launcher/bash/br

export PATH=$PATH:/home/zorax/.spicetify
