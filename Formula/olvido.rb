class Olvido < Formula
  desc "Command-line client for Olvido: platform API, offline script checks, MCP server"
  homepage "https://olvido.app"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Chapterists/olvido-releases/releases/download/v0.2.0/olvido-cli-aarch64-apple-darwin.tar.xz"
      sha256 "4e338050d2d92f2c7ec87644d155956a00d999880d377f43170209cf8963ba04"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Chapterists/olvido-releases/releases/download/v0.2.0/olvido-cli-x86_64-apple-darwin.tar.xz"
      sha256 "b1a5c70e6d7f2a3959cf610a5236ba06e3186c8866d8af1307166dd74484a56f"
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
