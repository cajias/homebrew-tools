class ShellSettings < Formula
  desc "Personal zsh shell settings with dual plugin manager support (zi and Sheldon)"
  homepage "https://github.com/cajias/zi"
  url "https://github.com/cajias/zi/archive/refs/tags/v20250310.d5a17f0.tar.gz"
  sha256 "f6b53a0e57e54501cd9ded081fe56c392f7b8d83d93b2b005ee875a72d6afd71" # Will be automatically updated by GitHub Actions
  version "20250310.d5a17f0" # Date-based versioning for automatic updates

  # zi is the default, but Sheldon is available as an alternative
  depends_on "sheldon" => :optional
  
  # Skip trying to install binaries completely
  pour_bottle? do
    reason "Binary distribution doesn't include scripts"
    satisfy { false }
  end

  def install
    # Install the main init.zsh (zi-based by default)
    prefix.install "init.zsh"

    # Create a share directory for configuration examples
    (share/"shell-settings").mkpath

    # Create example Sheldon configuration
    (share/"shell-settings"/"init-sheldon.zsh").write <<~EOS
      # Sheldon-based ZSH Configuration - Optimized
      # To use: source #{share}/shell-settings/init-sheldon.zsh

      # ============================================================
      # Environment Variables
      # ============================================================
      export EDITOR="vim"
      export VISUAL="$EDITOR"

      # History configuration
      HISTSIZE=50000
      SAVEHIST=50000
      HISTFILE=~/.zsh_history
      setopt SHARE_HISTORY
      setopt HIST_IGNORE_DUPS
      setopt HIST_IGNORE_SPACE
      setopt HIST_FIND_NO_DUPS
      setopt HIST_REDUCE_BLANKS
      setopt INC_APPEND_HISTORY

      # ============================================================
      # Initialize Sheldon Plugin Manager
      # ============================================================
      if command -v sheldon &> /dev/null; then
        eval "$(sheldon source)"
      else
        echo "Warning: Sheldon not installed. Install with: brew install sheldon"
      fi

      # ============================================================
      # Modern CLI Tools (install via: brew install <tool>)
      # ============================================================

      # zoxide: Smart cd replacement
      if command -v zoxide &> /dev/null; then
        eval "$(zoxide init zsh)"
        alias cd='z'  # Replace cd with zoxide
      fi

      # eza: Modern ls replacement
      if command -v eza &> /dev/null; then
        alias ls='eza --icons --group-directories-first'
        alias ll='eza --icons --group-directories-first -l'
        alias la='eza --icons --group-directories-first -la'
        alias tree='eza --tree --icons'
      else
        alias ll='ls -lh'
        alias la='ls -lah'
      fi

      # bat: Better cat with syntax highlighting
      if command -v bat &> /dev/null; then
        alias cat='bat --style=auto'
        export MANPAGER="sh -c 'col -bx | bat -l man -p'"
      fi

      # fzf: Fuzzy finder integration
      if command -v fzf &> /dev/null; then
        [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
        export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
      fi

      # atuin: Better shell history (install: brew install atuin)
      if command -v atuin &> /dev/null; then
        eval "$(atuin init zsh)"
      fi

      # direnv: Auto-load .envrc files
      if command -v direnv &> /dev/null; then
        eval "$(direnv hook zsh)"
      fi

      # ============================================================
      # Useful Aliases
      # ============================================================
      alias ..='cd ..'
      alias ...='cd ../..'
      alias ....='cd ../../..'

      # Git shortcuts
      alias gs='git status'
      alias ga='git add'
      alias gc='git commit'
      alias gco='git checkout'
      alias gp='git push'
      alias gl='git pull'
      alias gd='git diff'
      alias glog='git log --oneline --graph --decorate'

      # ============================================================
      # Key Bindings for zsh-history-substring-search
      # ============================================================
      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down
      bindkey '^P' history-substring-search-up
      bindkey '^N' history-substring-search-down

      # ============================================================
      # Powerlevel10k Instant Prompt (if using p10k theme)
      # ============================================================
      if [[ -r "~/.cache/p10k-instant-prompt-$USER.zsh" ]]; then
        source "~/.cache/p10k-instant-prompt-$USER.zsh"
      fi

      # Load p10k config if it exists
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    EOS

    # Create example Sheldon plugins.toml - optimized configuration
    (share/"shell-settings"/"plugins.toml").write <<~EOS
      # Sheldon plugins configuration - Optimized for performance and usability
      # Copy to ~/.config/sheldon/plugins.toml to use

      shell = "zsh"

      # Performance: Load this first to defer other plugins
      [plugins.zsh-defer]
      github = "romkatv/zsh-defer"

      # Theme: Fast and beautiful prompt
      [plugins.powerlevel10k]
      github = "romkatv/powerlevel10k"

      # Syntax: Use fast-syntax-highlighting (faster than zsh-syntax-highlighting)
      [plugins.fast-syntax-highlighting]
      github = "zdharma-continuum/fast-syntax-highlighting"

      # Suggestions: Fish-like autosuggestions
      [plugins.zsh-autosuggestions]
      github = "zsh-users/zsh-autosuggestions"

      # Completions: Additional completion definitions
      [plugins.zsh-completions]
      github = "zsh-users/zsh-completions"

      # Fuzzy finder: Better tab completion with fzf
      [plugins.fzf-tab]
      github = "Aloxaf/fzf-tab"

      # History: Substring search with up/down arrows
      [plugins.zsh-history-substring-search]
      github = "zsh-users/zsh-history-substring-search"

      # Auto-pairing: Auto-close quotes and brackets
      [plugins.zsh-autopair]
      github = "hlissner/zsh-autopair"

      # Alias reminder: Suggests aliases when you type full commands
      [plugins.you-should-use]
      github = "MichaelAquilina/zsh-you-should-use"

      # Node.js: NVM lazy loading (uncomment if you use Node.js)
      # [plugins.zsh-nvm]
      # github = "lukechilds/zsh-nvm"

      # Vim mode: Vi keybindings in zsh (uncomment if you prefer vim bindings)
      # [plugins.zsh-vi-mode]
      # github = "jeffreytse/zsh-vi-mode"

      # Oh My Zsh libraries (uncomment if needed)
      # IMPORTANT: Only load specific lib files, NOT the entire lib directory
      # Loading the entire lib dir will include test files that run on shell init!
      # [plugins.ohmyzsh-completion]
      # github = "ohmyzsh/ohmyzsh"
      # use = ["lib/completion.zsh"]
      #
      # [plugins.ohmyzsh-directories]
      # github = "ohmyzsh/ohmyzsh"
      # use = ["lib/directories.zsh"]
      #
      # [plugins.ohmyzsh-history]
      # github = "ohmyzsh/ohmyzsh"
      # use = ["lib/history.zsh"]
      #
      # [plugins.ohmyzsh-key-bindings]
      # github = "ohmyzsh/ohmyzsh"
      # use = ["lib/key-bindings.zsh"]
      #
      # [plugins.ohmyzsh-git]
      # github = "ohmyzsh/ohmyzsh"
      # dir = "plugins/git"
    EOS

    # Create a bin directory for utility scripts
    bin.mkpath
    
    # Create a script to handle weekly brew updates quietly
    (bin/"brew-weekly-update").write <<~EOS
      #!/bin/zsh

      # File to track last update time
      LAST_UPDATE_FILE="$HOME/.brew_last_update"
      SECONDS_IN_WEEK=604800  # 7 days * 24 hours * 60 minutes * 60 seconds

      # Function to run brew update quietly in the background
      run_brew_update() {
        touch "$LAST_UPDATE_FILE" 2>/dev/null
        (brew update &) >/dev/null 2>&1
      }

      # Check if update file exists
      if [ ! -f "$LAST_UPDATE_FILE" ]; then
        # First time - run update
        run_brew_update
      else
        # Check if it's been more than a week (cross-platform)
        current_time=$(date +%s)
        if [[ "$OSTYPE" == "darwin"* ]]; then
          last_update=$(stat -f %m "$LAST_UPDATE_FILE" 2>/dev/null || echo "0")
        else
          last_update=$(stat -c %Y "$LAST_UPDATE_FILE" 2>/dev/null || echo "0")
        fi
        time_diff=$((current_time - last_update))

        if [ $time_diff -gt $SECONDS_IN_WEEK ]; then
          run_brew_update
        fi
      fi
    EOS
    
    # Make the update script executable
    chmod 0755, bin/"brew-weekly-update"

    # Explicitly avoid bin directory from source
    FileUtils.rm_rf(buildpath/"bin") if (buildpath/"bin").exist?
  end

  def caveats
    sheldon_installed = which("sheldon")

    <<~EOS
      Shell settings installed with dual plugin manager support!

      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

      📦 DEFAULT (zi/zinit):
        Add to your ~/.zshrc:
          source #{prefix}/init.zsh

      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

      🦀 ALTERNATIVE (Sheldon):#{sheldon_installed ? "" : " [Requires: brew install sheldon]"}
        1. Install Sheldon (if not already installed):
           brew install sheldon

        2. Copy the example Sheldon config:
           mkdir -p ~/.config/sheldon
           cp #{share}/shell-settings/plugins.toml ~/.config/sheldon/

        3. Add to your ~/.zshrc:
           source #{share}/shell-settings/init-sheldon.zsh

      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

      💡 SWITCHING BETWEEN CONFIGURATIONS:
        Edit your ~/.zshrc and change which init file you source:
          # For zi:      source #{prefix}/init.zsh
          # For Sheldon: source #{share}/shell-settings/init-sheldon.zsh

        Then reload: source ~/.zshrc

      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

      🔄 BONUS FEATURE:
        The brew-weekly-update command silently runs 'brew update'
        once per week. To enable, add to your ~/.zshrc:
          brew-weekly-update &

      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

      📂 Configuration files:
        - zi config:      #{prefix}/init.zsh
        - Sheldon config: #{share}/shell-settings/init-sheldon.zsh
        - Sheldon example: #{share}/shell-settings/plugins.toml
    EOS
  end

  def post_install
    # Only create Sheldon config directory if Sheldon is installed
    if which("sheldon")
      sheldon_config_dir = Pathname.new(ENV["HOME"])/".config"/"sheldon"
      sheldon_config_dir.mkpath unless sheldon_config_dir.exist?
      ohai "Sheldon detected! Example config available at: #{share}/shell-settings/plugins.toml"
    end

    ohai "Default configuration uses zi. See post-install message for Sheldon setup."
  end

  test do
    system "zsh", "-c", "source #{prefix}/init.zsh && echo $PATH"
  end
end