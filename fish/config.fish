
alias g="git"
alias c="cargo"
alias cl="clear"
alias start-tmux="TERM=tmux tmux -2"

# Base16 Shell
if status --is-interactive
    set BASE16_SHELL "$HOME/.config/base16-shell/"
    source "$BASE16_SHELL/profile_helper.fish"
end

function fish_prompt
	set_color --bold brblack
	echo -n "["(date "+%H:%M")"] "
	set_color --bold blue
	echo -n (hostname)
	if [ $PWD != $HOME ]
		set_color brblack
		echo -n ':'
		set_color --bold brcyan
		echo -n (basename $PWD)
	end
	set_color green
	printf '%s ' (__fish_git_prompt)
	set_color 60f0c5
	echo -n '$ '
	set_color normal
end

# adapted from https://github.com/jonhoo/configs/blob/master/shell/.config/fish/config.fish
function fish_greeting
	echo
	echo -e (uname -r | awk '{print " \\\\e[1mKernel: \\\\e[0;32m"$0"\\\\e[0m"}')
	echo -e (uptime -p | sed 's/^up //' | awk '{print " \\\\e[1mUptime: \\\\e[0;32m"$0"\\\\e[0m"}')
	echo -e (uname -n | awk '{print " \\\\e[1mHostname: \\\\e[0;32m"$0"\\\\e[0m"}')
	echo
end

set PATH $HOME/.cargo/bin $PATH

# opam configuration
source /home/tc/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true

