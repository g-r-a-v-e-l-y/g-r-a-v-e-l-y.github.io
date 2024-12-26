---
title: gs_linkedin
tags: posts
date: 2008-10-25 09:07:00.00 -8
---

## Dynamically present Linkedin.com profile hresume data on your Textpattern blog

### Summary

gs\_linkedin is [Textpattern](https://textpattern.com/) a port of [Brad Touesnard’s](http://brad.touesnard.com/) Wordpress plugin [LinkedIn hResume](http://wordpress.org/extend/plugins/linkedin-hresume/). It grabs the Microformated hResume block from your LinkedIn public profile page allowing you to add it to any page with a simple textpattern tag and apply your own styles.

Thanks to Mariano Absatz for help reporting bugs.

### Download

gs\_linkedin is released under the GPL. [Download it](/files/gs_linkedin.zip).

### Setup / Installation

Your LinkedIn profile must be configured to “Full View”. The default view is “Basic”. Once the Linkedin API is public this could change.

The hResume classes and ids are left in place and can be styled as you wish. Below is the css Brad Touesnard created for his plugin, as well as my modified version.

The plugin does not currently use any cache, fetch images, or require any non-standard php configurations.

### Usage

gs\_linkedin requires two attributes.

* **linkedin\_src** – the url of your public linkedin.com profile
* **name** – your full name

### Example

```xml
<txp:gs\_linkedin linkedin\_src="/images/http://www.linkedin.com/profile?viewProfile=&key=5919187" name="Grant Stavely" />
```

### CSS

I prefer a very basic style and hide much of the linkedin-specific content.

```css
#overview, div.profile-header, div.actions,
#summary h2, summary h3, #additional-information,
.info, .skills  {
    display: none;
}
#experience ul.vcalendar li.experience {
    position: relative;
}
abbr {
    text-decoration: none;
    border: none;
    color: #999;
    font-style: italic;
    font-size: .9em;
}
.organization-details {
    font-size: .9em;
    color: #999;
}
.org summary {
    font-size: 1.2em;
    font-style: italic;
}
```