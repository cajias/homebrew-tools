class ExtractAudio < Formula
    desc "A script to extract audio from media files"
    homepage "https://github.com/cajias/v2a"
    url "https://github.com/cajias/v2a/archive/v1.0.1.tar.gz"
    sha256 "f35e5219df0347fb380e1df866a00053c64ccd953fe3c83118d34732cef8fee2"
    version "1.0.1"
  
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