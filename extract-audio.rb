class ExtractAudio < Formula
    desc "A script to extract audio from media files"
    homepage "https://github.com/cajias/v2a"
    url "https://github.com/cajias/v2a/archive/v1.0.0.tar.gz"
    sha256 "ee07fcc5cd2b203e9a7695aad2d4fbe8a10fac783d612011e22471b1d66ba5c3"
    version "1.0.0"
  
    depends_on "ffmpeg"
    depends_on "python"
  
    def install
      bin.install "extract_audio.py"
    end
  
    def post_install
      system "pip3", "install", "tqdm", "ffmpeg-python"
    end
  
    test do
      system "python3", "#{bin}/extract_audio.py", "--help"
    end
  end