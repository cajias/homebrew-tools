class ExtractAudio < Formula
  desc "A script to extract audio from media files"
  homepage "https://github.com/cajias/v2a"
  url "https://github.com/cajias/v2a/archive/v1.0.2.tar.gz"
  sha256 "ac70e1310ada6bd3ca4b065905f71444e6aedf1b59fa06565412953ab855d769"
  version "1.0.2"

  depends_on "ffmpeg"
  depends_on "python"

  def install
    bin.install "extract_audio.py"
  end

  def post_install
    # Create a virtual environment in the Homebrew prefix
    venv_dir = "#{prefix}/venv"
    system "python3", "-m", "venv", venv_dir

    # Install required Python packages in the virtual environment
    system "#{venv_dir}/bin/pip", "install", "tqdm", "ffmpeg-python"

    # Create a wrapper script to use the virtual environment's Python interpreter
    (bin/"extract_audio").write <<~EOS
      #!/bin/bash
      source #{venv_dir}/bin/activate
      python3 #{bin}/extract_audio.py "$@"
    EOS

    # Make the wrapper script executable
    chmod "+x", bin/"extract_audio"
  end

  test do
    system "#{bin}/extract_audio", "--help"
  end
end