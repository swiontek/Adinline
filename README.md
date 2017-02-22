Adinline
========

Adds images inline with the message in Adium.

This is a fork of Mr. Gecko's Adinline plugin for Adium. It improves a bit on Adinline in that it allows you to click on
displayed images to hide them (the image tags are actually removed from the DOM structure of the message window so they
get released from memory, too – useful when you have lots of big gif files in your chats).

To trust images in chatrooms run this command from your Terminal:

`defaults write com.adiumX.adiumX MGMAIAllowStrangers -bool YES`
