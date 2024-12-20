# News Preview Addon 1.2

$EnableSaveNewsPreview = 0;
# Set the above to 1 to enable a link to the submitted item on the News Saved page.

sub PreviewStyle {
# The following should be the code for an HTML page, with <InsertPreview>
# where the news preview belongs.
# Server-side includes will NOT work here (on most servers).
my $newspreview = q~
<!-- Start preview code -->
<html><head><title>News Preview</title></head>
<body>
<InsertPreview>

<br><p> This news item has <b>not</b> been submitted. Use your browser's back button to return
to the Submit News page and edit or submit this item.</p>
</body></html>
<!-- End preview code -->
~;
return $newspreview;
}

push(@Addons_Loaded, 'News Preview');
push(@Addons_DisplaySubForm_Post, 'NPreview_DSF_Post');
unshift(@Addons_SaveNews, 'NPreview_SaveNews');
if ($EnableSaveNewsPreview) {
	push(@Addons_SaveNews_2, 'NPreview_SaveNews_2');
}
$Addons_List{'News Preview 1.2'} = ['npa_preview.pl', 'Allows you to preview the appearance of a news item before submission.', 'http://amphibian.gagames.com/addon.cgi?preview&1.2'];

sub NPreview_DSF_Post {
	print qq~
	<input type="submit" name="show_news_preview" value="Preview">
	~;
}

sub NPreview_SaveNews {
	if ($in{'show_news_preview'}) {
		require $ndisplaypl;
		my $preview = PreviewStyle();
		$newsdate = GetTheDate();
		&DoNewsHTML;
		$preview =~ s/<InsertPreview>/$newshtml/;
		print $preview;
		exit;
	}
}
sub NPreview_SaveNews_2 {
	print qq~<br><a href="viewnews.cgi?newsid$snid">View submitted item.</a>~;
}
1;