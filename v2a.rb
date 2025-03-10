class V2a < Formula
  desc "Video to Audio Converter"
  homepage "https://github.com/cajias/v2a"
  url "https://github.com/cajias/v2a/archive/v1.0.9.tar.gz"
  sha256 "c7f0baa46100cb87930606f4cd610b6acde8552d7f09137cb1c4e687963cb463"
  version "1.0.9"

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
