# Fabric Homebrew formula template.
#
# This file is the source of truth for Formula/fabric.rb in the
# pdlc-os/homebrew-fabric tap. The `homebrew` job in
# .github/workflows/build-release.yml renders it with render.sh on every
# release and pushes the result to the tap — edit this template, never the
# rendered formula in the tap repo.
#
# Placeholders: 0.3.1 v0.3.1 1f59dd939699174a2d28032dddbadd0be6d1d48007a119a6734f88351c079808 ee98228fddc3d568d8f97b19f191c89eb825a940c175ce9ea908e7ab10b9591c
#               7cacf42a967f204e3e1ad16cbfcd13705e6b1c5c099358b93b20995a1530e98b 7cad6021ac3ad3e8289dd29d94d702c5d42d871fe0ff40e8b328bce040ad81c2
class Fabric < Formula
  desc "Container-based orchestration platform for concurrent LLM code agents"
  homepage "https://github.com/pdlc-os/fabric"
  version "0.3.1"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/pdlc-os/fabric"
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/pdlc-os/fabric/releases/download/v0.3.1/fabric-darwin-arm64.tar.gz"
      sha256 "1f59dd939699174a2d28032dddbadd0be6d1d48007a119a6734f88351c079808"
    end
    on_intel do
      url "https://github.com/pdlc-os/fabric/releases/download/v0.3.1/fabric-darwin-amd64.tar.gz"
      sha256 "ee98228fddc3d568d8f97b19f191c89eb825a940c175ce9ea908e7ab10b9591c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/pdlc-os/fabric/releases/download/v0.3.1/fabric-linux-arm64.tar.gz"
      sha256 "7cacf42a967f204e3e1ad16cbfcd13705e6b1c5c099358b93b20995a1530e98b"
    end
    on_intel do
      url "https://github.com/pdlc-os/fabric/releases/download/v0.3.1/fabric-linux-amd64.tar.gz"
      sha256 "7cad6021ac3ad3e8289dd29d94d702c5d42d871fe0ff40e8b328bce040ad81c2"
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
