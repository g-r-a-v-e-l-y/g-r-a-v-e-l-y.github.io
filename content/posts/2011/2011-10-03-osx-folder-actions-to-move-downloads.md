---
title: torrent applescript folder action
tags: posts
date: 2011-10-03 00:37:00.00 -8
permalink: "/torrent-applescript-folder-action.html"
---
Aaaag, it's so annoying having to add the _~GNU/Linux ISO~_ torrent file I
just downloaded to my home server's torrent daemon's auto-start directory. So,
I hacked up [this Folder Action](/files/Move%20Torrents.scpt) to do it for me
automatically.

```applescript
on adding folder items to thisFolder after receiving added_items
	set DroboTorrents to "storage:New Media"
	repeat with addedFile in added_items
		tell application "Finder"
			if (the name extension of the addedFile is "torrent") then
				try
					tell application "Finder"
						move addedFile to DroboTorrents with replacing
						delete addedFile
					end tell
				on error
					display dialog "Unable to move " & (name of i) with icon caution with title "Welp,"
				end try
			end if
		end tell
	end repeat
end adding folder items to
```

## Updated for 2024
```applescript
on adding folder items to thisFolder after receiving added_items
    repeat with addedFile in added_items
        tell application "Finder"
            if (the name of the addedFile ends with "torrent") then
                set qbt to "/opt/homebrew/bin/qbt torrent add '" & POSIX path of addedFile & "' 2>&1 | grep 'successfully added torrent'"
                set fileName to name of (info for addedFile)
                try
                    set response to do shell script qbt
                    set hash to word 4 of response
                    try
                        tell application "Finder"
                            delete addedFile
                        end tell
                    on error errMsg
                        display notification "ERROR deleting " & addedFile & errMsg
                    end try
                on error errMsg
                    display notification "ERROR adding torrent: " & qbt & "error: " & errMsg
                end try
                try
                    set qbt to "/opt/homebrew/bin/qbt torrent list --hashes '" & hash & "' 2>&1 | grep Size"
                    set response to do shell script qbt
                on error errMsg
                    display notification "ERROR: listing torrents by hash: " & hash & " Command: " & qbt & "error: " & errMsg
                end try
                display notification response with title "Torrent Downloading" subtitle fileName
            end if
        end tell
    end repeat
end adding folder items to
```