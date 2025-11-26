class Glab < Formula
  desc "GitLab CLI with cookie-based authentication for IdP/SSO (Midway) support"
  homepage "https://github.com/cajias/glab"
  version "1.78.3-cajias.2"
  license "MIT"

  on_macos do
    on_intel do
      url "https://github.com/cajias/glab/releases/download/v1.78.3-cajias.2/glab_1.78.3-cajias.2_darwin_amd64.tar.gz"
      sha256 "b30da538ca21db2f16b4f9fd0d738f2c5603fc136f9fbd3c3dafbf85e60460f6"
    end

    on_arm do
      url "https://github.com/cajias/glab/releases/download/v1.78.3-cajias.2/glab_1.78.3-cajias.2_darwin_arm64.tar.gz"
      sha256 "594979d8929b7579410fabfd969a88837507ae2ea16a947e8e7f0090501b0fd0"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/cajias/glab/releases/download/v1.78.3-cajias.2/glab_1.78.3-cajias.2_linux_amd64.tar.gz"
      sha256 "c4accc7eed708fab301ce956bf05b17ac25c5f20ff831879fa38f7d0aff40ed0"
    end

    on_arm do
      url "https://github.com/cajias/glab/releases/download/v1.78.3-cajias.2/glab_1.78.3-cajias.2_linux_arm64.tar.gz"
      sha256 "72d6cd575129432bc2261dd4ecbadaf1c7c69d3ee20862cdb3fc21608f0504c0"
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
