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
        # Create or touch the update file
        touch "$LAST_UPDATE_FILE"
        
        # Run brew update silently in the background, redirecting all output
        (brew update > /dev/null 2>&1 &)
      }
      
      # Check if update file exists
      if [ ! -f "$LAST_UPDATE_FILE" ]; then
        # First time - run update
        run_brew_update
      else
        # Check if it's been more than a week
        current_time=$(date +%s)
        last_update=$(stat -f %m "$LAST_UPDATE_FILE")
        time_diff=$((current_time - last_update))
        
        if [ $time_diff -gt $SECONDS_IN_WEEK ]; then
          run_brew_update
        fi
      fi
    EOS
    
    # Make the update script executable
    chmod 0755, bin/"brew-weekly-update"
    
    # Explicitly avoid bin directory from source
    FileUtils.rm_rf(buildpath/"bin") if Dir.exist?("bin")
  end

  def caveats
    <<~EOS
      To use these shell settings, add the following to your ~/.zshrc:

        # Source the shell settings
        source #{prefix}/init.zsh

      If you want to completely replace your .zshrc, you can do:
        
        echo 'source #{prefix}/init.zsh' > ~/.zshrc
        
      Note: You need to restart your shell or run 'source ~/.zshrc' for changes to take effect.
    EOS
  end

  def post_install
    # Create the sheldon config directory if it doesn't exist
    system "mkdir", "-p", "#{ENV["HOME"]}/.config/sheldon"
    
    # Configure sheldon if it's not already configured
    sheldon_config = "#{ENV["HOME"]}/.config/sheldon/plugins.toml"
    unless File.exist?(sheldon_config)
      # Create the base sheldon configuration with all needed plugins
      system "zsh", "-c", "cat \"#{prefix}/init.zsh\" | grep -A 40 'cat > \"\\$SHELDON_CONFIG_DIR/plugins.toml\"' | grep -v EOF | grep -v cat > \"#{sheldon_config}\""
    end
    
    # Create a hook file to call our brew-weekly-update script
    hook_file = "#{ENV["HOME"]}/.zshrc.d/brew-update-hook.zsh"
    system "mkdir", "-p", "#{ENV["HOME"]}/.zshrc.d"
    
    # Only create the hook if it doesn't exist
    unless File.exist?(hook_file)
      File.open(hook_file, "w") do |file|
        file.write <<~EOS
          # Run weekly brew update in the background (added by shell-settings)
          # This will only update once a week and runs silently in background
          command -v brew >/dev/null 2>&1 && {
            (brew-weekly-update &) >/dev/null 2>&1
          }
        EOS
      end
    end
  end

  test do
    system "zsh", "-c", "source #{prefix}/init.zsh && echo $PATH"
  end
end