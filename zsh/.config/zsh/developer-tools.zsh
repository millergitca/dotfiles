# Modern command-line tools
alias ls='eza --icons=auto --group-directories-first'
alias ll='eza -lah --icons=auto --group-directories-first --git'
alias la='eza -a --icons=auto --group-directories-first'
alias lt='eza --tree --level=2 --icons=auto'
alias cat='bat --paging=never'
alias less='bat'
alias cls='clear'
alias ff='fastfetch'
alias ports='ss -tulpn'
alias py='python'
alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate --all'
alias update='yay -Syu'

# Safer filesystem shortcuts
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -pv'

# Developer directories
alias projects='cd "$HOME/Projects"'
alias university='cd "$HOME/University"'

# Tool integrations
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
command -v fzf >/dev/null 2>&1 && source <(fzf --zsh)

export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'
export MANPAGER='nvim +Man!'
export BAT_THEME='TwoDark'
