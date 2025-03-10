class V2a < Formula
  include Language::Python::Virtualenv

  desc "Video to Audio Converter"
  homepage "https://github.com/cajias/v2a"
  url "https://github.com/cajias/v2a/archive/v1.0.12.tar.gz"
  sha256 "f7052aa128ec9549585aaee186d4cf37ad31ddfdf884facc3eb1f6b1e1691e00"
  version "1.0.12"

  depends_on "ffmpeg"
  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"v2a", "--help"
  end
end
