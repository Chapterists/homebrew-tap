class Olvido < Formula
  desc "Command-line client for Olvido: platform API, offline script checks, MCP server"
  homepage "https://olvido.app"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Chapterists/olvido-releases/releases/download/v0.5.0/olvido-cli-aarch64-apple-darwin.tar.xz"
      sha256 "eadc68b10d6fced299b28442b020acb7cc5fd0b58f874720d525a8fe638c6a47"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Chapterists/olvido-releases/releases/download/v0.5.0/olvido-cli-x86_64-apple-darwin.tar.xz"
      sha256 "89bf5966186940fe575dd7874a5a039cb33d4f94a90d881b9be713df71ceab84"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin": {}
  }

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
end
