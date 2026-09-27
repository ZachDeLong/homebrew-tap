cask "nudge" do
  version "1.4.4"
  sha256 "72880a3fb3555dd8b573d2608a17c26626db5cd852e8d96d9eeecda7d2cf3e0c"

  url "https://github.com/ZachDeLong/nudge/releases/download/v#{version}/Nudge.app.zip"
  name "Nudge"
  desc "Answer Claude Code and Codex permission prompts from the menu bar"
  homepage "https://github.com/ZachDeLong/nudge"

  livecheck do
    url :url
    strategy :github_latest
  end

  # Nudge updates itself (nudge-update), so `brew upgrade` leaves it alone.
  auto_updates true
  depends_on formula: "jq"
  depends_on macos: :sonoma

  app "Nudge.app"
  binary "#{appdir}/Nudge.app/Contents/Resources/setup/nudge-setup.sh", target: "nudge-setup"
  binary "#{appdir}/Nudge.app/Contents/MacOS/nudge-claude"
  binary "#{appdir}/Nudge.app/Contents/MacOS/nudge-update"

  # Releases are self-signed, not notarized, so Gatekeeper would block the
  # quarantined download. (Nudge's hooks also assume /Applications.)
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "Nudge.app"], chdir: "/Applications"
  end

  uninstall quit: "com.zachdelong.Nudge"

  # Hooks can't be removed here: brew deletes the app, and the setup script
  # inside it, before zap runs. The caveat asks for `nudge-setup --remove`.
  zap trash: "~/.config/nudge"

  caveats <<~EOS
    Connect Nudge to Claude Code (and Codex, if you use it):
      nudge-setup

    Before uninstalling, take the hooks back out:
      nudge-setup --remove
  EOS
end
