---
title: Outlook Zen Koans
tags: posts
date: 2008-11-24 09:29:00.00 -8
---
Outlook error messages must be [Zen Kōans](http://en.wikipedia.org/wiki/Koan). There simply isn’t a rational explanation for a mature product to be so full of useless, annoying alerts.

## The Evidence



### Meet the Cannot Family



>
> The function cannot be performed because the message has been changed.
>
>

>
> Changes to the meeting cannot be saved. The meeting has been updated by another person. Close and reopen the meeting, and then make your updates.
>
>

>
> The form required to view this message cannot be displayed. Contact your administrator.
>
>

The OK button only makes the messages worse.

If a dialog can only be dismissed with a single response, it should not exist, because it is no longer a dialog. Well, obviously you say, it is an alert!

>
> The item cannot be moved. It was either already moved or deleted, or access was denied.
>
>



And it’s twin.



>
> The item cannot be deleted. It was either moved or already deleted, or access was denied.
>
>



And the twins’s over-grown, uglier cousin



>
> Some items cannot be deleted. They were either moved or already deleted, or access was denied.
>
> - - -
>
>
>



Yikes, any developer that adds ASCII art (> >) to a graphical interface should have his or her commit privileges revoked.

How about a bulleted list?



>
> Cannot mark the items read or unread. The most likely reasons are:
>
>
> *   You don’t have permission to modify the items.
>
> *   These folders do not support marking items as read or unread.
>
> *   You did not select anything to mark.
>
> *   The server is unavailable.
>
>
>
>



>
> Cannot turn off the reminder. You may be reminded again.
>
>

Really? May I please?

### On Time

>
> Opening a lot of items could take some time. Are you sure you want to open these items?
>
>  

Some time?

Here is a dialog takes about 30 seconds to arrive, during which the entire interface is frozen.

>
> Cannot find file ‘\\\\network\\path\\that\\is\\not\\available’. Verify the path or Internet address is correct.
>
>

While this similar dialog, I think indicating that the browser isn’t ready, times out in a few seconds with the following useful error.

>
> General failure. The URL was: “http://theurl.tld/long/truncated/url/?ohpleasekillme…”. The system cannot find the file specified.
>
>

### On matters of temporary files



>
> The attachments of the message “” have been changed.
>
> Do you want to save changes to this message?
>
>   

What is the difference between No and Cancel?

>
> A program has the attachment open. Changes to the file will be lost unless you save your changes to another file by clicking the Microsoft Office Button in the other program, and then clicking Save As.
>
>

### Inhumane by any measure

>
> Unknown Error.
>
>

>
> A dialog box is open. Close it and try again.
>
>

Simply amazing.

The frequency a dialog is likely to present itself in QA is directly proportional to the quality of the alert text.

>
> **Share this Calendar with User, Joe
> <joe.user@grantstavely.com>?**
>
> Permissions: Reviewer (read-only)
>
>  

Really? Bold <bracketed> e-mail addresses? Lastname, Firstname?

Pick Yes.

>
> Your Calendar has been shared with User, Joe. <joe.user@grantstavely.com>. User, Joe has also granted you access to their calendar and it has been added to the Navigation Pane in your Calendar.
>
>

There are also a few nice messages hidden in the UI that obscure needless complexity

> Extra line breaks in this message were removed.

And it’s counterpart…

> This message has extra line breaks.

Ugh.

> This item canot be displayed in the Reading Pane. Open the item to read its contents.

### Informational Wordiness



> Your server administrator has limited the number of items you can open simultaneously. Try closing messages you have opened or removing attachments and images from unsent messages you are composing.
>
>

## Conclusion

So what else can strings find in outlook.exe?
```
> strings OUTLOOK.EXE | grep dialog
Always hide dialog
```
Indeed.

>
> The operation failed.
>
>