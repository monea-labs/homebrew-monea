class MoneaCli < Formula
  desc "An unopinionated CLI for playing rollup legos."
  homepage "https://monealabs.xyz"
  version "0.1.0-alpha.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/monea-labs/monea-cli/releases/download/v0.1.0-alpha.6/monea-cli-aarch64-apple-darwin.tar.gz"
      sha256 "4c9a71c7376abaaabe91a948a6d29d0266abb57c9de8758613bb68ac6c09ee03"
    end
    if Hardware::CPU.intel?
      url "https://github.com/monea-labs/monea-cli/releases/download/v0.1.0-alpha.6/monea-cli-x86_64-apple-darwin.tar.gz"
      sha256 "53ed34ac16a262575dd5731875da3f0063c5e3243de0df389cb779c3520ae3d6"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/monea-labs/monea-cli/releases/download/v0.1.0-alpha.6/monea-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c6a8f7b4da16b8bfb9dcf6fd3257db445b19673c49b26ff2ffd8df593268ebc4"
    end
  end
  license "MIT"

  BINARY_ALIASES = {"aarch64-apple-darwin": {"monea-cli": ["monea"]}, "x86_64-apple-darwin": {"monea-cli": ["monea"]}, "x86_64-pc-windows-gnu": {"monea-cli.exe": ["monea.exe"]}, "x86_64-unknown-linux-gnu": {"monea-cli": ["monea"]}}

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
      bin.install "monea-cli"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "monea-cli"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "monea-cli"
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
