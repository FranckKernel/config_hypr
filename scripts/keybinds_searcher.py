#!/usr/bin/env python3
import subprocess
import tempfile
import os

MODIFIER_MAP = {1: "Shift", 4: "Control", 8: "Alt", 64: "Super"}

# You can add your comments here for any keybind combo
COMMENT_OVERRIDES = {
    # workspaces
    "Super + 1": "move to workspace 1 (1 on first monitor)",
    "Super + Shift + 1": "move current window to workspace 1 (1 on first monitor)",
    "Alt + 1": "move to workspace 11 (1 on second monitor)",
    "Alt + Shift + 1": "move current window to workspace 11 ( 1 on second monitor)",
    "Alt + Super + 1": "move to workspace 21 (1 on third monitor)",
    "Alt + Super + Shift + 1": "move current window to workspace 21 ( 1 on third monitor)",
    # Main
    "Super + Q": "Hyprland keybinds searcher help",
    "Super + D": "Application Launcher. Search",
    "Super + W": "Open Internet Browser (Firefox/Zen/LibreWolf)",
    "Super + Return": "Open a terminal emulator. A shell. Cmd. Command",
    "Super + semicolon": "Close focused window. ; Exit, Kill",
    # Other terminals
    "Super + P": "Powermenu, log off, shutdown, reboot",
    "Super + H": "Open a terminal emulator. A shell. Cmd. Command",
    "Super + Less": "Open a terminal (no tmux)",
    "Shift + Super + Less": "Open a different terminal (no tmux)",
    # Add more as needed
    "Super + F1": "Buggy keyboard test",
}


def modmask_to_modifiers(modmask):
    modmask = int(modmask)
    mods = []
    for bit, name in MODIFIER_MAP.items():
        if (modmask & bit) == bit:
            mods.append(name)
    return mods


def parse_hyprctl_binds(text):
    binds = []
    blocks = text.strip().split("\nbind\n")
    for block in blocks:
        lines = block.strip().splitlines()
        data = {}
        for line in lines:
            line = line.strip()
            if not line or ":" not in line:
                continue
            k, v = line.split(":", 1)
            data[k.strip()] = v.strip()

        if not data:
            continue

        mods = modmask_to_modifiers(data.get("modmask", "0"))
        key = data.get("key", "")
        dispatcher = data.get("dispatcher", "")
        arg = data.get("arg", "")

        binds.append([mods + [key], [dispatcher, arg]])
    return binds


def format_bind_line(bind):
    keys = bind[0]
    cmd, arg = bind[1]

    combo = " + ".join(keys)
    base = f"{combo} = {cmd}"
    if arg:
        base += f" {arg}"

    # Check for manual comment
    comment = COMMENT_OVERRIDES.get(combo)
    if comment:
        base += f"    # {comment}"

    return base.strip()


def main():
    try:
        output = subprocess.check_output(["hyprctl", "binds"], text=True)
    except subprocess.CalledProcessError as e:
        print(f"Failed to run hyprctl: {e}")
        return

    binds = parse_hyprctl_binds(output)

    with tempfile.NamedTemporaryFile(mode="w+", delete=False) as tmpfile:
        for bind in binds:
            line = format_bind_line(bind)
            tmpfile.write(line + "\n")

        tmpfile.flush()
        tmpname = tmpfile.name

    try:
        selected = subprocess.check_output(["fzf", "--ansi"], text=True, stdin=open(tmpname))
        print(f"Selected bind:\n{selected.strip()}")
    except subprocess.CalledProcessError:
        print("No selection made or fzf was interrupted.")

    os.unlink(tmpname)


if __name__ == "__main__":
    main()
