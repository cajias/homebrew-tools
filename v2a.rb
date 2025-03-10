class V2a < Formula
  desc "Video to Audio Converter"
  homepage "https://github.com/cajias/v2a"
  url "https://github.com/cajias/v2a/archive/v1.0.11.tar.gz"
  sha256 "c67d4890bbd10ae44395711ec5471c0eb6e0ef6a5ea6f326b3f63c41dca989dd"
  version "1.0.11"

  depends_on "ffmpeg"
  depends_on "python@3.9"

  def install
    venv = virtualenv_create(libexec, "python3.9")
    venv.pip_install buildpath
    bin.install_symlink Dir["\#{libexec}/bin/*"]
  end

  test do
    system bin/"v2a", "--help"
  end
end
