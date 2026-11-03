{
  description = "nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, nixvim }:
  let
    username = "pubfnmain";

    configuration = { pkgs, ... }: {
      environment.systemPackages = [ pkgs.vim ];
      environment.shells = [ pkgs.fish ];
      programs.fish.enable = true;

      # users.users.*.shell needs knownUsers, which nix-darwin says not to use for admin users
      system.activationScripts.postActivation.text = ''
        dscl . -create /Users/${username} UserShell /run/current-system/sw/bin/fish
      '';

      fonts.packages = [ pkgs.iosevka-bin ];

      nix.settings.experimental-features = "nix-command flakes";

      nixpkgs.config.allowUnfree = true;

      system.primaryUser = username;
      users.users.${username}.home = "/Users/${username}";

      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 6;
      nixpkgs.hostPlatform = "aarch64-darwin";
    };

    homeConfig = { pkgs, ... }: {
      home.stateVersion = "25.11";

      # enables BSD ls colors, its default LSCOLORS is ANSI so it follows the Ghostty theme
      home.sessionVariables.CLICOLOR = "1";

      home.packages = with pkgs; [
        claude-code
	nodejs
        postgresql
      ];

      programs.ghostty = {
        enable = true;
        # pkgs.ghostty is Linux-only
        package = pkgs.ghostty-bin;
        settings = {
          # nix owns the version, stop Sparkle updating the app
          auto-update = "off";
          cursor-style = "block";
          custom-shader = "shaders/cursor_warp.glsl";
          shell-integration-features = "no-cursor";
          theme = "Mellow";
          window-padding-x = 15;
          window-padding-y = 15;
          focus-follows-mouse = true;
          font-size = 15;
          shell-integration = "detect";
          font-family = "Iosevka Extended";
          # Iosevka cv47 picks the lowercase l variant, 8 = tailed-serifed
          font-feature = "cv47=8";
          font-shaping-break = "no-cursor";
        };
      };
      xdg.configFile."ghostty/shaders".source = pkgs.fetchFromGitHub {
        owner = "sahaj-b";
        repo = "ghostty-cursor-shaders";
        rev = "0a274beac8b93ee6ce6b94402b7313a0417b8e38";
        hash = "sha256-B7B6K7Ee4uJlW8zzLP3ILgddnbcIQyNimY+rVllzbR0=";
      };

      programs.fish = {
        enable = true;
        shellAliases.cd = "z";
        # -P edits PATH directly, fish_user_paths always precedes PATH so -a alone wouldn't append
        shellInit = ''
          fish_add_path -P "$HOME/.cargo/bin"
          fish_add_path -Pa "$HOME/.pi/agent/bin" "$HOME/.local/bin" "$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
        '';
      };
      programs.zellij.enable = true;
      programs.zoxide.enable = true;
      programs.go.enable = true;
      programs.git = {
        enable = true;
        settings = {
          user.name = "Dan. K.";
          user.email = "pubfnmain@gmail.com";
          init.defaultBranch = "main";
        };
      };
      programs.nixvim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;

        opts = {
          number = true;
          relativenumber = true;
          shiftwidth = 2;
        };

        # nixvim has no mellow module, load plugin directly to match Ghostty theme
        extraPlugins = [ pkgs.vimPlugins.mellow-nvim ];
        colorscheme = "mellow";
        plugins.lualine.enable = true;
        plugins.treesitter.enable = true;
        plugins.telescope.enable = true;
        plugins.mini-pick.enable = true;
        plugins.mini-tabline.enable = true;
        plugins.web-devicons.enable = true;
        plugins.lspconfig.enable = true;
        plugins.blink-cmp = {
          enable = true;
          settings = {
            keymap = {
              preset = "enter";
              "<Tab>" = [ "select_next" "snippet_forward" "fallback" ];
              "<S-Tab>" = [ "select_prev" "snippet_backward" "fallback" ];
            };
            completion = {
              menu.draw.columns = [
                { __unkeyed-1 = "label"; __unkeyed-2 = "label_description"; gap = 1; }
                [ "kind" ]
              ];
              documentation = { auto_show = true; auto_show_delay_ms = 200; };
            };
            signature.enabled = true;
            sources.default = [ "lsp" "path" "snippets" "buffer" ];
          };
        };

        lsp.servers = {
          ts_ls.enable = true;
          gopls.enable = true;
          rust_analyzer.enable = true;
        };
      };
    };
  in
  {
    darwinConfigurations."mac-1" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration

        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.sharedModules = [ nixvim.homeModules.nixvim ];
          home-manager.users.${username} = homeConfig;
        }
      ];
    };
  };
}
