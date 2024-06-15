class ExtractAudio < Formula
    desc "A script to extract audio from media files"
    homepage "https://github.com/cajias/v2a"
    url "https://github.com/cajias/v2a/archive/v1.0.1.tar.gz"
    sha256 "fb743b8f73e25aeb3321df70c716b82b35fc4c6301c076328dc9655de455b33a"
    version "1.0.1"
  
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
    system "chmod", "+x", "#{bin}/extract_audio"
  end

    test do
      system "python3", "#{bin}/extract_audio.py", "--help"
    end
  end