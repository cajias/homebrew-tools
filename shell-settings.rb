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
      # Sheldon-based ZSH Configuration
      # To use: source #{prefix}/share/shell-settings/init-sheldon.zsh

      # Initialize Sheldon plugin manager
      eval "$(sheldon source)"

      # Common shell settings
      export EDITOR="vim"
      export VISUAL="$EDITOR"

      # History configuration
      HISTSIZE=10000
      SAVEHIST=10000
      HISTFILE=~/.zsh_history
      setopt SHARE_HISTORY
      setopt HIST_IGNORE_DUPS
      setopt HIST_IGNORE_SPACE
    EOS

    # Create example Sheldon plugins.toml
    (share/"shell-settings"/"plugins.toml").write <<~EOS
      # Sheldon plugins configuration
      # Copy to ~/.config/sheldon/plugins.toml to use

      shell = "zsh"

      [plugins.zsh-defer]
      github = "romkatv/zsh-defer"

      [plugins.zsh-syntax-highlighting]
      github = "zsh-users/zsh-syntax-highlighting"

      [plugins.zsh-autosuggestions]
      github = "zsh-users/zsh-autosuggestions"

      [plugins.zsh-completions]
      github = "zsh-users/zsh-completions"

      [plugins.fzf-tab]
      github = "Aloxaf/fzf-tab"
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