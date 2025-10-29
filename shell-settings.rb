class ShellSettings < Formula
  desc "Personal zsh shell settings with Sheldon plugin manager"
  homepage "https://github.com/cajias/zi"
  url "https://github.com/cajias/zi/archive/refs/tags/v20250310.d5a17f0.tar.gz"
  sha256 "f6b53a0e57e54501cd9ded081fe56c392f7b8d83d93b2b005ee875a72d6afd71" # Will be automatically updated by GitHub Actions
  version "20250310.d5a17f0" # Date-based versioning for automatic updates

  depends_on "sheldon"
  
  # Skip trying to install binaries completely
  pour_bottle? do
    reason "Binary distribution doesn't include scripts"
    satisfy { false }
  end

  def install
    # Only install the init.zsh script which is the core of the shell settings
    prefix.install "init.zsh"
    
    # Create a share directory for any other files
    (share/"shell-settings").mkpath
    
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
    # Store weekly update info in caveats for users
    weekly_update_info = <<~EOS
      
      The brew-weekly-update command is now available, which:
      - Runs 'brew update' only once per week (tracks via ~/.brew_last_update)
      - Runs silently in the background
      
      To auto-run it when your shell starts, add to your .zshrc:
        
        # Run silent weekly brew update (once per week)
        brew-weekly-update &
    EOS
    
    <<~EOS
      To use these shell settings, add the following to your ~/.zshrc:

        # Source the shell settings
        source #{prefix}/init.zsh

      If you want to completely replace your .zshrc, you can do:
        
        echo 'source #{prefix}/init.zsh' > ~/.zshrc
        
      Note: You need to restart your shell or run 'source ~/.zshrc' for changes to take effect.
      #{weekly_update_info}
    EOS
  end

  def post_install
    # Create the sheldon config directory if it doesn't exist
    sheldon_config_dir = Pathname.new(ENV["HOME"])/".config"/"sheldon"
    sheldon_config_dir.mkpath

    # Note: Users should manually configure sheldon using the init.zsh script
    # The init.zsh script contains the sheldon configuration that will be
    # automatically applied when sourced in .zshrc
    ohai "Sheldon configuration will be auto-generated when you first source init.zsh"
  end

  test do
    system "zsh", "-c", "source #{prefix}/init.zsh && echo $PATH"
  end
end