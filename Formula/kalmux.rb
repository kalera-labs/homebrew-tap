class Kalmux < Formula
  desc "Ten Claude Code agents in tmux, one place to watch them all"
  homepage "https://github.com/kalera-labs/kalmux"
  url "https://github.com/kalera-labs/kalmux/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "6b0348c594568db023d57effbe8c09888693a30d49ea7af44afe5308a073446b"
  license "MIT"
  version "0.4.3"
  head "https://github.com/kalera-labs/kalmux.git", branch: "main"

  depends_on "jq"
  depends_on "python@3.13"
  depends_on "tmux"
  depends_on :macos

  # Kalmux is pure standard library with no runtime dependencies, so there is nothing to resolve: the
  # tree goes into libexec and a wrapper runs it with Homebrew's unversioned python3 first on PATH.
  # The wrapper is a Python script, not a shell one: Kalmux spawns its own UI server as
  # `python3 <the kalmux command> ui serve`, and it bakes that path into ~/.tmux.conf and the iTerm2
  # AutoLaunch script, so the path has to be both runnable by python and stable across upgrades.
  def install
    libexec.install Dir["*"]
    (bin/"kalmux").write <<~PYTHON
      #!#{Formula["python@3.13"].opt_libexec}/bin/python3
      import sys
      sys.path.insert(0, "#{opt_libexec}/src")
      from kalmux._entry import main
      sys.exit(main())
    PYTHON
    (bin/"kalmux").chmod 0755
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
