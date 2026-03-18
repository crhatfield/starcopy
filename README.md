
# AUTHOR: CecilTheNerd
# Version: 2026-03-12
# BUY ME A COFFEE: https://ko-fi.com/CecilTheNerd
# REFERRAL CODE: https://www.robertsspaceindustries.com/enlist?referral=STAR-KSVL-CVC2
# 
# DISCLAIMER: This tool is provided "as-is" without warranty of any kind, express or implied.
# The author is not responsible for any data loss, file corruption, game installation issues,
# or any other damages arising from the use or misuse of this tool. Use at your own risk.
# Always back up your game files before using any third-party tool.
#
# LICENSE: GNU General Public License v3.0 only (GPL-3.0-only)
# Copyright (C) 2026 CecilTheNerd
# See the LICENSE file for full terms. You may not distribute modified versions
# without releasing source under the same license.

------------------------------
🚀 Star Citizen - StarCopy

Great for day 1 PTU access or when PTU goes to LIVE, starCopy is a PowerShell utility for Star Citizen that eliminates redundant ~120 GB downloads by copying, mirroring, or swapping game branch folders (LIVE/PTU/EPTU). Features dirty copy (no deletes, only overwrites), clean mirror (removes files not present in source), instant folder swap (Super quick swap for when PTU goes to LIVE), and symlink management (Space saving but requires you to verify files when switching versions) via a simple menu-driven interface.

------------------------------
📖 What is this?

    StarCopy is a PowerShell-based utility for Star Citizen players that eliminates redundant multi-gigabyte downloads when switching between game branches (LIVE, PTU, EPTU, HOTFIX, TECH-PREVIEW).

    When Cloud Imperium Games releases a new test build, the RSI Launcher typically re-downloads the entire game (~120 GB). StarCopy shortcuts this by intelligently reusing files you already have on disk. It reads your game folder paths from a simple config file and presents a menu-driven interface with four operations:

    * Dirty Copy      — Adds or updates files from a source branch to a destination using Robocopy, without deleting anything. Safe for seeding a fresh PTU folder from LIVE. Preserves screenshots and USER settings.
    * Clean Mirror    — Performs a full Robocopy mirror, making the destination an exact replica of the source. Deletes files in the destination that no longer exist in the source. Useful for clearing a corrupted or out-of-sync branch.
    * Instant Swap    — Renames two game folders atomically (e.g., PTU <-> LIVE) without moving a single byte. Useful when a PTU patch goes live and you want the launcher to see the correct folder immediately.
    * Symlink Manager — Creates, updates, or removes Windows symbolic links so multiple branch folders can point to the same physical files on disk, saving significant SSD space.

    A real-time progress bar displays current file transfer percentage and filename during copy operations. Configuration is a plain text file — one folder path per line, with comment support.

------------------------------

🛠 1. First-Time Setup

    1. The Paths File: Open the file named starCopyConfig.txt in Notepad.
    2. Add Your Folders: Paste the full location of your Star Citizen folders. It should look like this:

    # add your full paths to LIVE and other folders here
    C:\Program Files\Roberts Space Industries\StarCitizen\LIVE
    C:\Program Files\Roberts Space Industries\StarCitizen\HOTFIX
    C:\Program Files\Roberts Space Industries\StarCitizen\PTU
    C:\Program Files\Roberts Space Industries\StarCitizen\EPTU
    C:\Program Files\Roberts Space Industries\StarCitizen\TECH-PREVIEW

    * (Note: You can add notes by starting a line with #. The script will ignore them.)

    3. Start the Tool: Double-click the file named  runStarCopy.bat.
    * If it asks for permission, click Yes. The tool needs "Administrator" rights to rename folders and create links.

------------------------------
🎮 2. Understanding Your Options

    Option 1: Dirty Copy (The "Safe" Way)

    * Use this when: You want to move files from LIVE to PTU to save download time.
    * How it works: It copies new files but never deletes anything. Your Screenshots and USER folders (controls/settings) stay exactly where they are.

    Option 2: Clean Mirror (The "Exact Match" Way)

    * Use this when: Your game is acting buggy and you want the destination folder to be a perfect twin of the source.
    * ⚠️ WARNING: This WILL DELETE any files in the destination that aren't in the source. If you have screenshots in the "To" folder, move them first!

    Option 3: Swap Folder Names (The "Instant" Way)

    * Use this when: A PTU patch just went "LIVE."
    * How it works: It swaps the names (PTU becomes LIVE, LIVE becomes PTU). It takes 1 second because no files are actually moved.
    * Requirement: You MUST close the RSI Launcher and the Game before doing this.

    Option 4: Symlink Manager (The "Expert" Way)

    * Use this when: You want two folders to share the same files to save SSD space.
    * How it works: It creates a "Ghost Folder." For example, you can tell the computer: "When the launcher looks at EPTU, actually show it the files inside the LIVE folder."
    * Benefit: This uses zero extra disk space.

------------------------------
💡 Pro-Tips for Citizens

    * The Blue Bar: When copying, a blue bar appears at the top. It shows you which file is currently moving (like the massive Data.p4k).
    * Verify Files: After using any option, open the RSI Launcher, go to Settings, and click Verify. This "checks out" the work the script did and downloads any tiny remaining updates.
    * Launcher Tray: If the script says "Access Denied," make sure the RSI Launcher isn't hiding in your System Tray (by the clock). Right-click it and choose Quit.

------------------------------
Need to change something?
    If you ever move your game to a new SSD, just update the starCopyConfig.txt file and the script will automatically recognize the new location next time you run it.
    See you in the 'Verse! 🚀✨
------------------------------
What's next?

    If you are giving this to a friend, make sure you've set $TestMode = $false in the script so they see the clean "User" version with the progress bar instead of the "scary" debug code!
    If you want to learn how the script works or customize it, open starCopy.ps1 in a code editor like Visual Studio Code. The code is heavily commented to help you understand each step.
    If you want to support my work, consider buying me a coffee at https://ko-fi.com/CecilTheNerd or using my referral code when signing up for Star Citizen: https://www.robertsspaceindustries.com/enlist?referral=STAR-KSVL-CVC2
    Happy gaming, and see you in the 'Verse! 🚀✨
    