class V2a < Formula
  desc "Video to Audio Converter"
  homepage "https://github.com/cajias/v2a"
  url "https://github.com/cajias/v2a/archive/v1.0.10.tar.gz"
  sha256 "32081afdfbe13f8bc85071a38bf61ce39bf1957c946d3b0dc644c95593a35f5c"
  version "1.0.10"

  depends_on "ffmpeg"
  depends_on "python@3.9"

  def install
    virtualenv_create(libexec, "python3.9")
    virtualenv_install_with_resources
  end

  test do
    system bin/"v2a", "--help"
  end
end
