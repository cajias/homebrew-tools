class Glab < Formula
  desc "GitLab CLI with cookie-based authentication for IdP/SSO (Midway) support"
  homepage "https://github.com/cajias/glab"
  version "1.82.0-cajias.1"
  license "MIT"

  on_macos do
    on_intel do
      url "https://github.com/cajias/glab/releases/download/v1.82.0-cajias.1/glab_1.82.0-cajias.1_darwin_amd64.tar.gz"
      sha256 "357a332934368db9b303644bddd9e37c5c9cae9b2f514e1816742cfeadd5f7dd"
    end

    on_arm do
      url "https://github.com/cajias/glab/releases/download/v1.82.0-cajias.1/glab_1.82.0-cajias.1_darwin_arm64.tar.gz"
      sha256 "796cfd207d22f34b1f70317b7b22b2f2008c50ee6cecaf62be1e7e535b12d499"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/cajias/glab/releases/download/v1.82.0-cajias.1/glab_1.82.0-cajias.1_linux_amd64.tar.gz"
      sha256 "f92dc6675c10baf0a0b44218f0c338bca369d624a4661f34c22e9c920f53a810"
    end

    on_arm do
      url "https://github.com/cajias/glab/releases/download/v1.82.0-cajias.1/glab_1.82.0-cajias.1_linux_arm64.tar.gz"
      sha256 "25de38fa9fc294b2252f6568ff49be7962f3a2a093d868f55575ec5ae6ae7f73"
    end
  end

  conflicts_with "glab", because: "this is a fork with additional features"

  def install
    bin.install "glab"
  end

  def caveats
    <<~EOS
      This is a fork of glab with cookie-based authentication for IdP/SSO support.

      Features added:
        - Cookie-based authentication (--cookie-file flag)
        - Support for #HttpOnly_ cookies in Netscape cookie files
        - Multi-domain cookie loading for SAML redirect flows

      Usage:
        # Configure with cookie file for IdP/SSO protected GitLab
        glab auth login --hostname code.aws.dev --token $GITLAB_PAT --cookie-file ~/.midway/cookie

        # Use normally
        GITLAB_HOST=code.aws.dev glab api projects

      For more information, see: https://github.com/cajias/glab
    EOS
  end

  test do
    assert_match "glab version #{version}", shell_output("#{bin}/glab version")
  end
end
