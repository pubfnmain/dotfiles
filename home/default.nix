# home-manager config shared by every host, OS-specific bits live in sibling files
{ pkgs, ... }: {
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    claude-code
    just
    nodejs
    postgresql
  ];

  programs.ghostty = {
    enable = true;
    settings = {
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

  programs.chromium = {
    enable = true;
    # ungoogled-chromium can't install from the Web Store, so pin the crx; bump version, url and hash together
    extensions = [
      {
        id = "nngceckbapebfimnlniiiahkandclblb"; # bitwarden
        version = "2026.10.2";
        crxPath = pkgs.fetchurl {
          name = "bitwarden-2026.10.2.crx";
          url = "https://clients2.googleusercontent.com/crx/blobs/ARGaeZKrZCDk7UJWQXzUQ8_0pOOy6h1s3wvynvj3vqcHsuSvjGAmX2lV7s6ji5YP7A7DtxD42g7KMQK_5GXm_vg2NDXXdpmUbI8KoV-GsJ1nYSJ_koU3RksuUv-S7IUYLaPkAMZSmuXJX4rmXGST-41wO8smk2xEA2h2yA/NNGCECKBAPEBFIMNLNIIIAHKANDCLBLB_2026_10_2_0.crx";
          hash = "sha256-HJlRefdYYxBMim44nhBQVoqCwNLAfWrPa2JwPSSUMMk=";
        };
      }
    ];
  };

  programs.fish = {
    enable = true;
    shellAliases.cd = "z";
    # -P edits PATH directly, fish_user_paths always precedes PATH so -a alone wouldn't append
    shellInit = ''
      fish_add_path -P "$HOME/.cargo/bin"
      fish_add_path -Pa "$HOME/.pi/agent/bin" "$HOME/.local/bin"
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

    # buffer list tabline, replaces mini.tabline
    # no '' in Lua below: it would end the Nix string
    extraConfigLua = ''
      function _G.BufTabline()
        local parts = {}
        local cur = vim.api.nvim_get_current_buf()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.bo[buf].buflisted then
            local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
            if name == "" then name = "[No Name]" end
            if vim.bo[buf].modified then name = name .. " +" end
            local hl = buf == cur and "%#TabLineSel#" or "%#TabLine#"
            -- %N@fn@ makes label clickable, passes buf as minwid; %% escapes % in names
            table.insert(parts, hl .. "%" .. buf .. "@v:lua.BufTablineClick@ " .. name:gsub("%%", "%%%%") .. " %T")
          end
        end
        return table.concat(parts) .. "%#TabLineFill#"
      end

      function _G.BufTablineClick(buf)
        vim.api.nvim_set_current_buf(buf)
      end

      vim.o.showtabline = 2
      vim.o.tabline = "%!v:lua.BufTabline()"
    '';
  };
}
