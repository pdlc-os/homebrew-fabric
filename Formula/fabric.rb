# Fabric Homebrew formula template.
#
# This file is the source of truth for Formula/fabric.rb in the
# pdlc-os/homebrew-fabric tap. The `homebrew` job in
# .github/workflows/build-release.yml renders it with render.sh on every
# release and pushes the result to the tap — edit this template, never the
# rendered formula in the tap repo.
#
# Placeholders: 0.2.0 v0.2.0 d4bfb24387926774fd97ac238f665823520ac55c0446a4abaf7ec9be2d184498 a36d8c52462c90d95cb8e1467dab5e84ed3c01850ffda1dade4a46ba3dd3981b
#               26ef4622234e09c2fbf777129e90f6e85a8a5dfa3893fc5f22803f2f514ea7ca 087a20d9db5d42b42a20a6236201b621ba5a5c5bee8409c386f6b48e9edc3d98
class Fabric < Formula
  desc "Container-based orchestration platform for concurrent LLM code agents"
  homepage "https://github.com/pdlc-os/fabric"
  version "0.2.0"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/pdlc-os/fabric"
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/pdlc-os/fabric/releases/download/v0.2.0/fabric-darwin-arm64.tar.gz"
      sha256 "d4bfb24387926774fd97ac238f665823520ac55c0446a4abaf7ec9be2d184498"
    end
    on_intel do
      url "https://github.com/pdlc-os/fabric/releases/download/v0.2.0/fabric-darwin-amd64.tar.gz"
      sha256 "a36d8c52462c90d95cb8e1467dab5e84ed3c01850ffda1dade4a46ba3dd3981b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/pdlc-os/fabric/releases/download/v0.2.0/fabric-linux-arm64.tar.gz"
      sha256 "26ef4622234e09c2fbf777129e90f6e85a8a5dfa3893fc5f22803f2f514ea7ca"
    end
    on_intel do
      url "https://github.com/pdlc-os/fabric/releases/download/v0.2.0/fabric-linux-amd64.tar.gz"
      sha256 "087a20d9db5d42b42a20a6236201b621ba5a5c5bee8409c386f6b48e9edc3d98"
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
