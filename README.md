# Deatharte .dotfiles

## Versioning

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
	- [ ] Editor (nvim)
	- [ ] PDF Viewer (sioyek)
	- [ ] Screen Compositor (picom)
	- [ ] Status line (polybar)
	- [ ] DE (i3)
	- [ ] Music Player (mpd, ncmpcpp)
	- [ ] Scripts
- [ ] Source(d) files
	- [x] .zshrc (zsh login shell configuration)
	- [x] .alias, .env (custom aliases and global envs)
	- [x] .p10k.zsh (powerlevel10k configuration)
