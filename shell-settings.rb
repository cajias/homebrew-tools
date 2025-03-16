class ShellSettings < Formula
  desc "Personal zsh shell settings with Sheldon plugin manager"
  homepage "https://github.com/cajias/zi"
  url "https://github.com/cajias/zi/archive/refs/tags/v20250310.d5a17f0.tar.gz"
  sha256 "f6b53a0e57e54501cd9ded081fe56c392f7b8d83d93b2b005ee875a72d6afd71" # Will be automatically updated by GitHub Actions
  version "20250310.d5a17f0" # Date-based versioning for automatic updates

  depends_on "sheldon"

  def install
    # Install the init script
    prefix.install "init.zsh"
    
    # Create a directory for the binaries if they exist in the source
    if Dir.exist?("bin") && !Dir["bin/*"].empty?
      bin_dir = prefix/"bin"
      bin_dir.mkpath
      bin_files = Dir["bin/*"]
      bin_files.each do |file|
        bin_file = File.basename(file)
        cp file, bin_dir/bin_file
        chmod 0755, bin_dir/bin_file
      end
    end
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
  end

  test do
    system "zsh", "-c", "source #{prefix}/init.zsh && echo $PATH"
  end
end