class Glab < Formula
  desc "GitLab CLI with cookie-based authentication for IdP/SSO (Midway) support"
  homepage "https://github.com/cajias/glab"
  version "1.78.3-cajias.3"
  license "MIT"

  on_macos do
    on_intel do
      url "https://github.com/cajias/glab/releases/download/v1.78.3-cajias.3/glab_1.78.3-cajias.3_darwin_amd64.tar.gz"
      sha256 "54f23965bfd60a8251a62423c2951ce7ce5e6cee40fafdf98e43bca86396a2e7"
    end

    on_arm do
      url "https://github.com/cajias/glab/releases/download/v1.78.3-cajias.3/glab_1.78.3-cajias.3_darwin_arm64.tar.gz"
      sha256 "b27eea03923c131fd8ca43a5be423457d3c5db33b2cdf3969b5964a2a3a328db"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/cajias/glab/releases/download/v1.78.3-cajias.3/glab_1.78.3-cajias.3_linux_amd64.tar.gz"
      sha256 "5a110eeea8c47e2c25335a66ee1bda9615f2f96d0ab2276d03ae8b24f275e2ae"
    end

    on_arm do
      url "https://github.com/cajias/glab/releases/download/v1.78.3-cajias.3/glab_1.78.3-cajias.3_linux_arm64.tar.gz"
      sha256 "46ca35a830f157a7c7f9a8feac5481c677afde97f507e902318e0bbe6c0e421e"
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
