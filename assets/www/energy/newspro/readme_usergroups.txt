######################################################
###
###			UserGroups Addon for Newspro
###
###			by plushpuffin@hotmail.com
###
###			http://plushpuffin.virtualave.net
###

UserGroups is an entirely different kind of addon.
"Different how?" you may ask. Well, it's different in that
it doesn't do anything. That is, not by itself.

When another addon works with UserGroups...well...
that's when cool things start to happen.

######################################################

UserGroups manages properties of both users and groups.
What properties? ALL properties. Anything you care to
think of. Category access permissions, ICQ numbers,
web page URLs...you name it.

What UserGroups does is provide a nice and easy way for
some other addons to set properties per user or per group.
That's it! The other addon is responsible for making sure
that the property makes sense, and for actually doing
useful things with that property.

######################################################

First thing's first. Definitions!

User: any user of newspro, from Standard through Advanced
and all the way up to webmaster.

Group: a collection of users.

User Property: a specific property of a user. For example,
ICQ #, birth date, etc.

Group Property: a specific property of a group.
(eg: users it contains, description of the group...)

######################################################

Ok...the first thing we have to realize is that a
property can apply both to a user and a group.

For example, a "category restriction" addon could
make sure that certain users can't post to the
category called "Breaking News". This addon could
make it easy to maintain the user permissions for
categories by making this a property of both users
and groups.

When both users and groups have the same kind of property,
that property is called an INHERITED property. That is,
if a user belongs to a group, all the inherited properties
of that group also apply to the user. You can see the
advantages of this, right?

######################################################

Different kinds of properties...

Some properties are singular. For example, you can only
have one favorite color. Other properties are multiple;
you can have permission to post to many categories, not
just one.

A singular inherited property is one which can be
overruled if it is also set for the user. So, if a group
has a "favorite color" property "green" and one of the
users has a "favorite color" property "red", then the
red wins out.

A multiple inherited property is the exact opposite.
Going back to the "categories permisssions" example...
If a group has "permitted categories" of "A, B, C"
and the user has "permitted categories" of "C, D"...
then the user actually has "A, B, C, D"

What happens if two groups contain the same user?
Well, this is very straightforward. UserGroups just
goes through the groups alphabetically until it has
found the properties it needs.

######################################################

How do you know which properties are singular and
which are multiple? The author of the addon should
specifically indicate this for you. If s/he didn't,
then s/he deserves a good hard spanking.

######################################################
######################################################
############ VERY IMPORTANT ##########################


All properties applying to the current user are
declared as variables when newspro starts.

The format of a property's variable name is:
$UGV_PROPERTYNAME for the currently logged in user
$UGP_PROPERTYNAME for the username specified in $newsname

##
(To use the property $UGP_ICQ you need the Dossier addon)
##

So...you're going through your Build News routine, and
you put $UGP_ICQ in DoNewsHTML. Now, freeze frame!

FROZEN! Look, you just happen to be working on the
news item that "Joe" submitted. Consequently, the word
"Joe" is in the variable $newsname.

Now, access the variable $UGP_ICQ. Go ahead!
Wow! Look at that! The variable $UGP_ICQ changes
to reflect the name of the user in the variable
$newsname!!!!

But wait...what if you have a field called "uservar1"
and you want it to display the ICQ # based on the user
name in "uservar1", not "newsname" ???

Easy! Log in as a webmaster and go to the UserGroups page.
Click on the button "Edit Various UserGroups Settings"
Now, for UGPField, choose the variable you
want to use for determining the values of the UGP_PROPERTYNAME
values. Pretty darn cool, eh?

######################################################
######################################################
######################################################

The interface and options of UserGroups are very simple.
If you know newspro, you should be able to figure this
stuff out for yourself.

Nevertheless, if you believe I may have missed a few
vital details, please email me: plushpuffin@hotmail.com

######################################################

FIN

######################################################