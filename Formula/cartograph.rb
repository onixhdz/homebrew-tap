class Cartograph < Formula
  desc "Build a nervous system for your codebase"
  homepage "https://github.com/onixhdz/cartograph"
  url "https://github.com/onixhdz/cartograph/releases/download/v0.2.0/cartograph-darwin-arm64"
  version "0.2.0"
  sha256 "83f1d724fa6494c7704df1a0b537a0d141872217ba381e4d77a8e2fb0ee8db3e"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/onixhdz/cartograph/releases/download/v0.2.0/cartograph-darwin-arm64"
      sha256 "83f1d724fa6494c7704df1a0b537a0d141872217ba381e4d77a8e2fb0ee8db3e"
    end

    if Hardware::CPU.intel?
      url "https://github.com/onixhdz/cartograph/releases/download/v0.2.0/cartograph-darwin-amd64"
      sha256 "c32270f71f7cc97e177f099d9006f2df04d13f1e39dd4b690802427b5474f855"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/onixhdz/cartograph/releases/download/v0.2.0/cartograph-linux-amd64"
      sha256 "9bf648e30a255a418032e47eb54da0bd83ffbc3c453269cfc82fdb68bef88241"
    end

    if Hardware::CPU.arm?
      url "https://github.com/onixhdz/cartograph/releases/download/v0.2.0/cartograph-linux-arm64"
      sha256 "836d9ef1bb0a563a233da9cc136a7c5d0c4243de14a8a35f5e11ee5d0489e898"
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
