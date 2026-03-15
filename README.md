'''
#############################################
## AUTHOR: CecilTheNerd 
## Version: 2026-03-12
## BUY ME A COFFEE: https://ko-fi.com/CecilTheNerd
## REFERRAL CODE: https://www.robertsspaceindustries.com/enlist?referral=STAR-KSVL-CVC2
############################################
'''

------------------------------
🚀 Star Citizen - Star Copy - User Guide - What is this?

    Star Citizen is a massive game (120GB+). When Cloud Imperium Games (CIG) releases a new testing version (like PTU or EPTU), you normally have to download the whole game again.
    starCopy.ps1 is a PowerShell tool that lets you "borrow" the files you already have in your LIVE folder to update your PTU folder. This turns a 2-hour download into a 15-minute copy—or an instant rename.
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

    * Do you want me to add a "Version Number" or your name to the top of the script so they know who made it?
    * Should I include a "Restore Defaults" button that clears all symlinks?
