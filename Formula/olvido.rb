class Olvido < Formula
  desc "Command-line client for Olvido: platform API, offline script checks, MCP server"
  homepage "https://olvido.app"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Chapterists/olvido-releases/releases/download/v0.1.0/olvido-cli-aarch64-apple-darwin.tar.xz"
      sha256 "592cef37ebca4a5b72c6504d5957f3c836f45a331651dd4cf332efcef3e5d0aa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Chapterists/olvido-releases/releases/download/v0.1.0/olvido-cli-x86_64-apple-darwin.tar.xz"
      sha256 "76f41b117793a614e9a0ad0d54e30f0150d7dfec97e5f5873a18415709a43880"
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
