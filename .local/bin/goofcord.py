#!/usr/bin/env python3

import json
from datetime import datetime
from pathlib import Path

# Define paths
goofcord_path = Path("~/.config/goofcord/GoofCord/settings.json").expanduser()
discord_css_path = Path("~/.cache/matugen/discord.css").expanduser()

# Check if settings file exists
if goofcord_path.exists():
    # Read the CSS file
    discord_css = discord_css_path.read_text() if discord_css_path.exists() else ""

    # Load the JSON settings file
    with goofcord_path.open("r", encoding="utf-8") as f:
        settings = json.load(f)

    # Update settings
    settings["quickcss"] = discord_css
    settings["quickcss_time"] = datetime.now().isoformat()

    # Save the updated settings
    with goofcord_path.open("w", encoding="utf-8") as f:
        json.dump(settings, f, indent=4)
