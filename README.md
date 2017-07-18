Adinline
========

Adds images inline with the message in Adium.

This is a fork of Mr. Gecko's Adinline plugin for Adium. It improves a bit on Adinline in that it allows you to click on
displayed images to hide them (the image tags are actually removed from the DOM structure of the message window so they
get released from memory, too useful when you have lots of big gif files in your chats).

### INSTALLATION
1. Download the latest release, unzip, and double click plugin to install (to uninstall delete the Adium plugin from ~/Library/Application Support/Adium 2.0/Plugins)
2. **IMPORTANT:** To trust images in chatrooms run this command from your Terminal:
	`defaults write com.adiumX.adiumX MGMAIAllowStrangers -bool YES`
3. Restart Adium

### Unrelated, but fun...
**Hipchat Emoticons**

1. Download and Install : [http://www.adiumxtras.com/index.php?a=xtras&xtra_id=8130](http://www.adiumxtras.com/index.php?a=xtras&xtra_id=8130)
2. Enable : Adium -> Preferences -> Appearance -> Emoticons -> Select 'Hipchat'

