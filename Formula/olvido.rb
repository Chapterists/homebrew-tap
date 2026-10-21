class Olvido < Formula
  desc "Command-line client for Olvido: platform API, offline script checks, MCP server"
  homepage "https://olvido.app"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Chapterists/olvido-releases/releases/download/v0.7.0/olvido-cli-aarch64-apple-darwin.tar.xz"
      sha256 "82abc552d194eef754334dcff99b0da8100904c29ab16b8ebcf9059a3254f17c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Chapterists/olvido-releases/releases/download/v0.7.0/olvido-cli-x86_64-apple-darwin.tar.xz"
      sha256 "f75dc9c6a6b910dd9179269b99049bb08ea1a315ed322066a1e3c737728e986d"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "olvido"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "olvido"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end

  test do
    assert_match "olvido #{version}", shell_output("#{bin}/olvido --version")
  end
end
