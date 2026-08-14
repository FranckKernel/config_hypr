#!/usr/bin/env python3

import json
import subprocess

import time


def hyprctl(*args: str) -> str:
    result = subprocess.run(
        ["hyprctl", *args],
        check=True,
        capture_output=True,
        text=True,
    )
    return result.stdout


def get_clients():
    clients = json.loads(hyprctl("clients", "-j"))

    return [
        {
            "address": client["address"],
            "workspace": client["workspace"]["id"],
        }
        for client in clients
    ]


def move_window(address: str, workspace: int):
    command = "hl.dispatch(" "hl.dsp.window.move({" f"workspace = {workspace}, " f'window = "address:{address}", ' "follow = false" "}))"

    hyprctl("eval", command)


def focus_workspace(workspace: int):
    # TODO: replace with the confirmed Lua workspace-focus primitive
    pass


def main():
    clients = get_clients()

    # Save current workspace of every window
    saved_workspaces = {client["address"]: client["workspace"] for client in clients}

    # Move everything to workspace 1
    for address in saved_workspaces:
        move_window(address, 1)

    # time.sleep(4)

    focus_workspace(1)

    # Make sure the current focused in workspace on the left and right screen are correctly assigned
    focus_workspace(14)  # Pick unused right screen workspace.
    focus_workspace(13)  # Focus back on the boot right screen workspace

    focus_workspace(24)  # Pick unused left screen workspace
    focus_workspace(21)  # Focus back on boot left screen workspace

    # time.sleep(4)

    # Restore windows to their original workspaces
    for address, workspace in saved_workspaces.items():
        move_window(address, workspace)


if __name__ == "__main__":
    main()
