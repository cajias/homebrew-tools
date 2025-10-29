class ExtractAudio < Formula
  include Language::Python::Virtualenv

  desc "A script to extract audio from media files"
  homepage "https://github.com/cajias/v2a"
  url "https://github.com/cajias/v2a/archive/v1.0.2.tar.gz"
  sha256 "ac70e1310ada6bd3ca4b065905f71444e6aedf1b59fa06565412953ab855d769"
  version "1.0.2"

  depends_on "ffmpeg"
  depends_on "python@3.13"

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/source/t/tqdm/tqdm-4.66.1.tar.gz"
    sha256 "d88e651f9db8d8551a62556d3cff9e3034274ca5d66e93197cf2490e2dcb69c6"
  end

  resource "ffmpeg-python" do
    url "https://files.pythonhosted.org/packages/source/f/ffmpeg-python/ffmpeg-python-0.2.0.tar.gz"
    sha256 "65225db34627c578ef0e11c8b1eb528bb35e024752f6f10b78c011f6f64c4127"
  end

  def install
    virtualenv_install_with_resources
    # Rename the installed script for consistency
    (bin/"extract_audio.py").rename(bin/"extract_audio") if (bin/"extract_audio.py").exist?
  end

  test do
    system bin/"extract_audio", "--help"
  end
end