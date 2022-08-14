# Deatharte .dotfiles

## Manual steps 
The following was written following this [https://www.atlassian.com/git/tutorials/dotfiles](guide).
```bash
	# Clone repo
	cd ~
	git clone --bare https://github.com/DrKGD/ArchDotFiles 

	# Alias for ease of use
	alias dotfiles='/usr/bin/git --git-dir=$HOME/.ArchDotFiles/ --work-tree=$HOME'

	# Checkout
	dotfiles checkout ArchDotFiles
```

**Warning**
> It won't checkout if there are existing files that conflicts with those of the repository!

## TODO(s)
- [ ] Application config(s)
	- [x] Editor (nvim)
	- [ ] Terminal (wezterm)
	- [ ] PDF Viewer (sioyek)
	- [x] Screen Compositor (picom)
	- [x] Status line (polybar)
	- [ ] Greater (ssdm)
	- [x] DE (i3)
		- [x] Keybindings
		- [x] Workspaces 
		- [x] Local-to-device configuration 
	- [x] Music Player (mpd, ncmpcpp)
	- [x] Scripts
- [ ] Source(d) files
	- [x] .zshrc (zsh login shell configuration)
	- [x] .alias, .env (custom aliases and global envs)
	- [x] .p10k.zsh (powerlevel10k configuration)
