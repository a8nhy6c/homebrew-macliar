class Macliar < Formula
  desc "Menu bar app that randomizes your Mac's MAC address and Wi-Fi identity"
  homepage "https://github.com/a8nhy6c/macliar"
  url "https://github.com/a8nhy6c/macliar/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "72ade364e6607ea0ec7d6a7cf331dcdd66473164ad7c9ec0e65ec978642780af"
  license "MIT"
  head "https://github.com/a8nhy6c/macliar.git", branch: "main"

  depends_on :macos
  depends_on xcode: :build

  def install
    app_path = Utils.safe_popen_read("bash", "Scripts/build-app.sh", "release", buildpath).strip
    prefix.install app_path
  end

  def caveats
    <<~EOS
      macliar is a menu bar app, not a command-line tool. To launch it:
        open #{opt_prefix}/macliar.app

      To keep it in your Applications folder so it appears with your other apps:
        cp -R #{opt_prefix}/macliar.app /Applications/

      macliar makes no network connections and installs no background services.
      The first time you use "Stable for this network" it asks for Location
      permission, only so it can read the current Wi-Fi name locally.
    EOS
  end

  test do
    assert_predicate prefix/"macliar.app/Contents/MacOS/macliar", :exist?
  end
end

# This is the canonical Homebrew formula for macliar. It belongs in the separate tap repository
# a8nhy6c/homebrew-macliar as Formula/macliar.rb. A copy is kept here for reference and review.
#
# The formula builds macliar from source with the Swift toolchain, so the resulting binary is
# compiled on the user's own machine. A locally built binary is not quarantined, which is why macliar
# can be installed and run without an Apple Developer ID, signing, or notarization.
#
# Before a release: create the v0.1.0 tag, then set sha256 to the SHA-256 of the release tarball
# (RELEASING.md explains how to compute it).
