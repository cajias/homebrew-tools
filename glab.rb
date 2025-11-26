class Glab < Formula
  desc "GitLab CLI with cookie-based authentication for IdP/SSO (Midway) support"
  homepage "https://github.com/cajias/glab"
  version "1.78.3-cajias.1"
  license "MIT"

  on_macos do
    on_intel do
      url "https://github.com/cajias/glab/releases/download/v1.78.3-cajias.1/glab_1.78.3-cajias.1_darwin_amd64.tar.gz"
      sha256 "73bb9e72aff9f80ebb2d54dbeec6f08281cd2689127f60305dfe616baad4a677"
    end

    on_arm do
      url "https://github.com/cajias/glab/releases/download/v1.78.3-cajias.1/glab_1.78.3-cajias.1_darwin_arm64.tar.gz"
      sha256 "01090c38e8fd004b5c6140b8f813574dc1bbfa3b4247bf88579e8585a55d9cc9"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/cajias/glab/releases/download/v1.78.3-cajias.1/glab_1.78.3-cajias.1_linux_amd64.tar.gz"
      sha256 "6b92faa92753b7b296f84324ab8d97039f1855b983ec5c705cac8f6fa465d418"
    end

    on_arm do
      url "https://github.com/cajias/glab/releases/download/v1.78.3-cajias.1/glab_1.78.3-cajias.1_linux_arm64.tar.gz"
      sha256 "51a0dc340858df5763fb7b8e5cdcf24586d42760d2ccaeb5a2e7974bac8f2d04"
    end
  end

  conflicts_with "glab", because: "this is a fork with additional features"

  def install
    bin.install "bin/glab"
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
