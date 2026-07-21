class Cartograph < Formula
  desc "Build a nervous system for your codebase"
  homepage "https://github.com/onixhdz/cartograph"
  url "https://github.com/onixhdz/cartograph/releases/download/v0.2.1/cartograph-darwin-arm64"
  version "0.2.1"
  sha256 "b3a7c1b70c9bca1519c717acf2415d30d0509dbb2dc248e5d00d9dd398f83c9d"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/onixhdz/cartograph/releases/download/v0.2.1/cartograph-darwin-arm64"
      sha256 "b3a7c1b70c9bca1519c717acf2415d30d0509dbb2dc248e5d00d9dd398f83c9d"
    end

    if Hardware::CPU.intel?
      url "https://github.com/onixhdz/cartograph/releases/download/v0.2.1/cartograph-darwin-amd64"
      sha256 "a482036aab719c795fae261bdcb8750fe28d09f37409c26be6cf4facb1596d13"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/onixhdz/cartograph/releases/download/v0.2.1/cartograph-linux-amd64"
      sha256 "d0c253580a06577f2603c205fbf334e9f3f5ca25c521e1bba0a644286233b647"
    end

    if Hardware::CPU.arm?
      url "https://github.com/onixhdz/cartograph/releases/download/v0.2.1/cartograph-linux-arm64"
      sha256 "9f1d0f1284a5949fa1f392c398087a03f4be926f90beade5c316d641f580d84a"
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
