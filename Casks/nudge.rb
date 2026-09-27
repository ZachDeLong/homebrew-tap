cask "nudge" do
  version "1.4.3"
  sha256 "fd888bb96186f9cbeec870c0180db0c190cc763573af38673b6b2b1d4167cc3f"

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
  depends_on macos: ">= :sonoma"
  depends_on formula: "jq"

  app "Nudge.app"
  binary "#{appdir}/Nudge.app/Contents/Resources/setup/nudge-setup.sh", target: "nudge-setup"
  binary "#{appdir}/Nudge.app/Contents/MacOS/nudge-claude"
  binary "#{appdir}/Nudge.app/Contents/MacOS/nudge-update"

  # Releases are self-signed, not notarized, so Gatekeeper would block the
  # quarantined download.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Nudge.app"]
  end

  uninstall quit: "com.zachdelong.Nudge"

  zap script: {
        executable:   "#{appdir}/Nudge.app/Contents/Resources/setup/nudge-setup.sh",
        args:         ["--remove"],
        must_succeed: false,
      },
      trash:  "~/.config/nudge"

  caveats <<~EOS
    Connect Nudge to Claude Code (and Codex, if you use it):
      nudge-setup

    Before uninstalling, take the hooks back out:
      nudge-setup --remove
  EOS
end
