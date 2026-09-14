class Kalmux < Formula
  desc "Ten Claude Code agents in tmux, one place to watch them all"
  homepage "https://github.com/kalera-labs/kalmux"
  url "https://github.com/kalera-labs/kalmux/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "5248f5cc92495eea26935842aafd5876ec4ad61526d214158215394d1011fff3"
  license "MIT"
  version "0.4.1"
  head "https://github.com/kalera-labs/kalmux.git", branch: "main"

  depends_on "jq"
  depends_on "python@3.13"
  depends_on "tmux"
  depends_on :macos

  # Kalmux is pure standard library with no runtime dependencies, so there is nothing to resolve: the
  # tree goes into libexec and a wrapper runs it with Homebrew's unversioned python3 first on PATH.
  def install
    libexec.install Dir["*"]
    (bin/"kalmux").write_env_script opt_libexec/"bin/kalmux",
                                    PATH: "#{Formula["python@3.13"].opt_libexec}/bin:$PATH"
  end

  def caveats
    <<~EOS
      One more step wires Kalmux into iTerm2, tmux and Claude Code:
        kalmux setup
      It is idempotent and reversible, and "kalmux doctor" explains anything it could not do.
    EOS
  end

  test do
    assert_match "kalmux #{version}", shell_output("#{bin}/kalmux --version")
    assert_match "claude.resume", shell_output("#{bin}/kalmux config")
  end
end
