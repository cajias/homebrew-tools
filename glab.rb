class Glab < Formula
  desc "GitLab CLI with cookie-based authentication for IdP/SSO (Midway) support"
  homepage "https://github.com/cajias/glab"
  version "1.78.3-cajias.4"
  license "MIT"

  on_macos do
    on_intel do
      url "https://github.com/cajias/glab/releases/download/v1.78.3-cajias.4/glab_1.78.3-cajias.4_darwin_amd64.tar.gz"
      sha256 "ff74704a9b69766e8ec59eb08bb52e4c2a6bf45e3aedb8ca461c8e94b79d1cf0"
    end

    on_arm do
      url "https://github.com/cajias/glab/releases/download/v1.78.3-cajias.4/glab_1.78.3-cajias.4_darwin_arm64.tar.gz"
      sha256 "26b68922b01c67bf9906faeb3edc39d952fadfc4e0f257fe7a38c37b726477d9"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/cajias/glab/releases/download/v1.78.3-cajias.4/glab_1.78.3-cajias.4_linux_amd64.tar.gz"
      sha256 "e444f483f46f3dc2f29541cd10eb331934f91c19022835c413fd99c45ad20f37"
    end

    on_arm do
      url "https://github.com/cajias/glab/releases/download/v1.78.3-cajias.4/glab_1.78.3-cajias.4_linux_arm64.tar.gz"
      sha256 "f7b0324a7358da8e5b166b9755d0b9e13e47df2fc0cdd7af713853303c08d515"
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
