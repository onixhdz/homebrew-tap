class Cartograph < Formula
  desc "Build a nervous system for your codebase"
  homepage "https://github.com/realxen/cartograph"
  url "https://github.com/realxen/cartograph/releases/download/v0.1.8/cartograph-darwin-arm64"
  version "0.1.8"
  sha256 "445663c537812526b46334a3a68fc3568eaa03aea71895e4c50798d2195e55ec"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/realxen/cartograph/releases/download/v0.1.8/cartograph-darwin-arm64"
      sha256 "445663c537812526b46334a3a68fc3568eaa03aea71895e4c50798d2195e55ec"
    end

    if Hardware::CPU.intel?
      url "https://github.com/realxen/cartograph/releases/download/v0.1.8/cartograph-darwin-amd64"
      sha256 "95ab679e4804462a8c596f5c6ec93b0703883241a2b191ea17bbe8a7648ee471"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/realxen/cartograph/releases/download/v0.1.8/cartograph-linux-amd64"
      sha256 "fe3be685a0bf9d21eed9eb5711f2b2a692850e1cf040c55830459827d962316c"
    end

    if Hardware::CPU.arm?
      url "https://github.com/realxen/cartograph/releases/download/v0.1.8/cartograph-linux-arm64"
      sha256 "759ab94b55ad867ee4a93b3a26593dbbfdcf2be47bda4280b31c6e916025fada"
    end
  end

  def install
    binary_name =
      if OS.mac?
        Hardware::CPU.arm? ? "cartograph-darwin-arm64" : "cartograph-darwin-amd64"
      elsif OS.linux?
        Hardware::CPU.arm? ? "cartograph-linux-arm64" : "cartograph-linux-amd64"
      else
        odie "unsupported platform"
      end

    bin.install binary_name => "cartograph"
    (buildpath/"cartograph.bash").write <<~BASH
      complete -o default -o bashdefault -C #{opt_bin}/cartograph cartograph
    BASH
    bash_completion.install buildpath/"cartograph.bash" => "cartograph"
  end

  def post_install
    system bin/"cartograph", "skills", "install", "--upgrade"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cartograph -v")
    assert_match "complete -o default", shell_output("#{bin}/cartograph completion -c bash")
  end
end
