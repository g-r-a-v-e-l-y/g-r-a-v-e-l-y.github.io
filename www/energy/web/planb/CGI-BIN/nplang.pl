# NewsPro Messages File
$nplangversion = 3.7;
#
# Language Name: ENGLISH
$LangName = "ENGLISH";
#
# By editing this file, you can change any of the messages 
# seen on NewsPro screens by basic - Standard or High - level
# users. The administrator-only screens are English-only, as
# if the administrator did not speak English, all documentation
# would have to be translated as well, which is simply too great a task.
#
# Translators: please leave the above message intact, and in English.
# Do change the language name to the name of your language in your language, however.
#
# Do NOT edit the internal message names, only the messages themselves.
# Example:
# 'DoNotEditMe' => 'TranslateOrEditMe'
#
# If you use the tilde (~) within a message, you must escape it, i.e. \~
# Characters which contain a tilde, such as ñ, are fine and don't need to be escaped.
#
# For the messages, the boundary of where you can edit is between q~ and the following ~,
# Do not edit outside that boundary.
#
# START DATE INFORMATION

@Week_Days = ('Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday');
@Months = ('January','February','March','April','May','June','July','August','September','October','November','December');

# If times in your language use a 12 hour (AM/PM) clock, set the following to 1.
# Otherwise, set it to 0.
$nplang_12Hour = 1;

# Set the following to the standard date format in your language. Users will be able to choose
# any date format that they want, but the format below is the default.
# See Change Settings for information on how date formats should be written.
# Edit between q~ and ~;

$nplang_DateFormat = q~ <Field: Weekday>, <Field: Month_Name> <Field: Day>, <Field: Year> ~;


# START MESSAGES
%Messages = (

'NewsPro' => q~NewsPro~, # You may want to still call the script NewsPro, or you may want to translate the name.
'ContentType' => q~<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">~, # If your language needs a different character set, you may have to change this tag.
'MainPage_Welcome' => q~Welcome to NewsPro,~, # Will be used as: Welcome to NewsPro, (name)!
'MainPage_Choose' => q~Choose one of the options below to begin.~,
# The following should be present in every language file except for the English one. 
# Use this example as a guide; translate it, remove the # from the beginning of the line,
# and delete the empty one below.
# 'MainPage_LangWarning' => q~The basic functions of this script are available in (language name), but all administrative functions are available only in English.<br>~,
'MainPage_LangWarning' => q~ ~,
'Section_Submit' => q~Submit News~,
'Section_Build' => q~Build News~,
'MainPage_Descriptions_Submit' => q~Add a new news item to the database.~,
'MainPage_Descriptions_Build' => q~Use the information in the database to generate the HTML news and archive files.~,
'MainPage_Descriptions_Build_NoAuto' => q~You must build news after submitting news before it will appear on your page.~,
'Section_Modify' => q~Modify News~,
'MainPage_Descriptions_Modify' => q~Remove or edit previously submitted news items.~,
'MainPage_Modify_1' => q~You may only edit news items that you have previously posted.~,
'MainPage_Modify_2' => q~You may edit any news item, including those that others have posted.~,
'Section_UserInfo' => q~User Info~,
'MainPage_Descriptions_UserInfo' => q~Change your password or e-mail address.~,
'Section_LogOut' => q~Log Out~,
'MainPage_Descriptions_LogOut' => q~Logs you out of the system, so that you can no longer access this script until you enter your username and password.~,
'MainPage_YourVersion' => q~Your version:~,
'MainPage_CurrentVersion' => q~Current version:~,
'MainPage_Upgrade' => q~Click here to upgrade.~,
'MainPage_Addons' => q~Addons~,
'MainPage_Download' => q~Download~,
'MainPage_WebPage' => q~Visit the NewsPro web page.~,
'MainPage_SendEmail' => q~Send an e-mail with comments, questions, suggestions, etc.~,
# As help is not translated, the following should read "online help (English only)" when translated.
'HTMLFoot_Help' => q~online help~,
'Section_Main' => q~Main Page~,
'BackTo' => q~Back to~, #Used as a link, Back to (site name)
'Controls_Search' => q~Search our news archives:~,
'Controls_View' => q~View all news items~,
'Controls_Email' => q~Subscribe to our mailing list, and receive the latest news items by e-mail.~,
'Controls_EmailTextBox' => q~e-mail addr.~, # Used in a text box, to show where to enter your e-mail address.
'Controls_Subscribe' => q~Subscribe~,
'Controls_Unsubscribe' => q~Unsubscribe~,
'Submit_NewsText' => q~News Text~,
'Submit_GlossaryOn' => q~Glossary: On~,
'Off' => q~Off~,
'Submit' => q~Submit~,
'Reset' => q~Reset~,
'Save_NewsSaved' => q~News Saved~,
'Save_Message' => q~The news has been saved to the data file. Remember, you <b>still have to build news</b> before the changes
will be visible. Build News can be accessed from the bar below.~,
'Build_Title' => q~News Built~,
'Build_Message' => q~The news HTML has been built from the database. The latest news should now be visible on your page.~,
'Modify_Posted' => q~Posted on~, # Used as: Posted on (date)
'Modify_By' => q~by~, # Used as: Posted on (date) by (name)
'Modify_Keep' => q~Keep:~, # Used as a choice between keeping or removing a post.
'Modify_Remove' => q~Remove:~,
'Modify_NoPerm' => q~You do not have permission to modify this.~,
# The following six messages create one sentence: Save changes and finish modifying news or show next (number) items.
'Modify_Save' => q~Save changes~,
'And' => q~and~,
'Modify_Finish' => q~finish modifying news~,
'Modify_Or' => q~or~,
'Modify_Show' => q~show next~,
'Modify_Items' => q~items~,
'ModifySave_Title' => q~News Modified~,
'ModifySave_Message' => q~Your changes (if any) have been carried out. These changes have been made to the database, however the news must be built before they will appear on your page.~,
'Login_Is' => q~is logged in~,
'Login_OKMessage' => q~You have been logged in. A &quot;cookie&quot; has been saved to your computer which should allow you
				to access this system without logging in in the future. Your browser must accept cookies
				to use this system.~,
'Login_OKClick' => q~Click here to go to the main page.~,
'Login_NoTitle' => q~Username/Password Incorrect~,
'Login_NoMessage' => q~The information you entered is not valid. Please use your browser's
				back button and try again.~,
'Login_Title' => q~NewsPro Login (Authorized Users Only)~,
'Username' => q~Username~,
'Password' => q~Password~,
'Login_Login' => q~Log In~,
'UserInfo_Message' => q~You may change two options: your password and your e-mail address.~,
'Email' => q~Email~,
'UserInfoSave_Title' => q~User Info Changed~,
'UserInfoSave_Message' => q~Your information has been changed. If you changed your password, you may need to log in again.~,
'LogOut_Message' => q~You have been logged out.~,
'DisplayLink' => q~News managed by~,
'Viewnews_Error_1' => q~Invalid date information.~,
'Viewnews_Error_2' => q~No news items meet those criteria~,
'Viewnews_From' => q~News from~, # These two used as: News from (date) to (date)
'Viewnews_To' => q~to~,
'Viewnews_Error_3' => q~Invalid start/end news items.~,
'Viewnews_Items' => q~News Items~,
'Viewnews_Latest' => q~Latest News~,
'Viewnews_EmailAdd' => q~You have successfully been added to the mailing list.~,
'Viewnews_EmailFail' => q~does not appear to be a valid e-mail address.~,
'Viewnews_EmailUnsubSuccess' => q~has successfully been removed from the mailing list.~,
'Viewnews_EmailUnsubFail' => q~does not seem to be on the mailing list.~,
'Viewnews_EmailIncomplete' => q~Please fill in all necessary fields.~,
'Viewnews_Mailing' => q~Mailing List~,
'Viewnews_Success' => q~Success~,
'Viewnews_Failure' => q~Failure~,
'Viewnews_TMPLError' => q~Could not open viewnews.tmpl.~,
'Error' => q~Error~,
'Viewnews_NoResults' => q~This search returned no results.~,
'Viewnews_Results' => q~Search Results~,
'Viewnews_NoOpen' => q~Could not open file~, #Used as: could not open file (pathname)
'Category' => q~Category~,
'Preview' => q~Preview~
); # The end!

1;