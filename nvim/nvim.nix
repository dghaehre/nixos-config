{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    plugins = with pkgs.vimPlugins; [
	vim-javascript
	typescript-vim
	rust-vim
	vimwiki
	haskell-vim
	purescript-vim
	psc-ide-vim
	vim-vue
	elm-vim
	vim-fugitive
	fzf-vim
	vim-airline
	vim-airline-themes
	coc-nvim
	vim-tsx
	vim-elixir
	# vim-nnn Exists in unstable
	vim-commentary
	vim-surround
	vim-nix
	vim-startify
        vim-css-color
    ];
    extraPackages = with pkgs; [
      fzf
      nodejs
    ];

    extraConfig = (builtins.readFile ./.vimrc);

  };
}
