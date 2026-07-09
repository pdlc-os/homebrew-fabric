# Fabric Homebrew formula template.
#
# This file is the source of truth for Formula/fabric.rb in the
# pdlc-os/homebrew-fabric tap. The `homebrew` job in
# .github/workflows/build-release.yml renders it with render.sh on every
# release and pushes the result to the tap — edit this template, never the
# rendered formula in the tap repo.
#
# Placeholders: 0.1.0 v0.1.0 06c2dc97996305c11f2d4b83e1231179613e654f774d1d0f9823dd00c6b995e3 0d557bcea63f2b69af7c2c33715983603104abdd45c3e2f6876a41bed0af4b8f
#               b74aaaa95c5269b3ccd94d7c3334e5a7ad4b28773adf5bba4020fa5161843fd3 7e5bbfdf7c9a376c3e9f1ca538fecd1f25a7ca68c3e82ab4ad18652b2d19dd37
class Fabric < Formula
  desc "Container-based orchestration platform for concurrent LLM code agents"
  homepage "https://github.com/pdlc-os/fabric"
  version "0.1.0"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/pdlc-os/fabric"
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/pdlc-os/fabric/releases/download/v0.1.0/fabric-darwin-arm64.tar.gz"
      sha256 "06c2dc97996305c11f2d4b83e1231179613e654f774d1d0f9823dd00c6b995e3"
    end
    on_intel do
      url "https://github.com/pdlc-os/fabric/releases/download/v0.1.0/fabric-darwin-amd64.tar.gz"
      sha256 "0d557bcea63f2b69af7c2c33715983603104abdd45c3e2f6876a41bed0af4b8f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/pdlc-os/fabric/releases/download/v0.1.0/fabric-linux-arm64.tar.gz"
      sha256 "b74aaaa95c5269b3ccd94d7c3334e5a7ad4b28773adf5bba4020fa5161843fd3"
    end
    on_intel do
      url "https://github.com/pdlc-os/fabric/releases/download/v0.1.0/fabric-linux-amd64.tar.gz"
      sha256 "7e5bbfdf7c9a376c3e9f1ca538fecd1f25a7ca68c3e82ab4ad18652b2d19dd37"
    end
  end

  head do
    url "https://github.com/pdlc-os/fabric.git", branch: "main"

    depends_on "go" => :build
    depends_on "node" => :build
  end

  def install
    if build.head?
      system "make", "all"
      bin.install "build/fabric"
    else
      bin.install "fabric"
    end

    # Releases before v0.1.1 cannot run `fabric completion` without a
    # configured project, so only generate completions when the binary
    # supports it.
    if quiet_system bin/"fabric", "completion", "bash"
      generate_completions_from_executable(bin/"fabric", "completion")
    end
  end

  def caveats
    <<~EOS
      Fabric needs a container runtime (Docker, Podman, or Apple Container)
      and git >= 2.47 to manage agents.

      To get started, run:
        fabric server start
      and follow the onboarding wizard in your browser.
    EOS
  end

  test do
    output = shell_output("#{bin}/fabric version")
    assert_match "fabric", output
    assert_match version.to_s, output unless build.head?
  end
end
