class Glab < Formula
  desc "GitLab CLI with cookie-based authentication for IdP/SSO (Midway) support"
  homepage "https://github.com/cajias/glab"
  version "1.79.0-cajias.1"
  license "MIT"

  on_macos do
    on_intel do
      url "https://github.com/cajias/glab/releases/download/v1.79.0-cajias.1/glab_1.79.0-cajias.1_darwin_amd64.tar.gz"
      sha256 "943b0989dae2a0643b25b50353074b2ded408158c35e43d952cc64a50b1c0884"
    end

    on_arm do
      url "https://github.com/cajias/glab/releases/download/v1.79.0-cajias.1/glab_1.79.0-cajias.1_darwin_arm64.tar.gz"
      sha256 "4d136cb920c1a28fdcd0f09de83a6018e2cd50ba4a605a15c8b837b4bc6d75ae"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/cajias/glab/releases/download/v1.79.0-cajias.1/glab_1.79.0-cajias.1_linux_amd64.tar.gz"
      sha256 "3e23cb12f7605dfc5186f380b99b1f385c06896f4ea36570f06e33dda071c1ed"
    end

    on_arm do
      url "https://github.com/cajias/glab/releases/download/v1.79.0-cajias.1/glab_1.79.0-cajias.1_linux_arm64.tar.gz"
      sha256 "cd524e16ba6d8c4deff19e7ac3970cc43503e175e00b97a41133eba4cbbc19cd"
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
