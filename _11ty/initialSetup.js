const markdownIt = require('markdown-it');
const markdownItAnchor = require('markdown-it-anchor');
const markdownItFootnote = require('markdown-it-footnote');
const { asidePlugin } = require('@humanwhocodes/markdown-it-markua-aside');
const slugify = require('slugify');
const {
  ASSETS_FOLDER,
  SCRIPTS_FOLDER,
  SLUGIFY_CONFIG,
} = require('./constants');

const MARKDOWN_IT_OPTIONS = {
  html: true,
  typographer: true,
  tabIndex: false,
  breaks: false,
  linkify: true,
};

const MARKDOWN_IT_ANCHOR_OPTIONS = {
  slugify: (s) => slugify(s, SLUGIFY_CONFIG),
  tabIndex: false,
  decamelize: false,
};

module.exports = function (eleventyConfig) {
  eleventyConfig.setLibrary(
    'md',
    markdownIt(MARKDOWN_IT_OPTIONS)
      .use(markdownItAnchor, MARKDOWN_IT_ANCHOR_OPTIONS)
      .use(markdownItFootnote)
      .use(asidePlugin),
  );

  eleventyConfig.setFrontMatterParsingOptions({
      excerpt: (file) => {

          // I use https://www.npmjs.com/package/remove-markdown here,
          // but you can bring your own de-markdownifier.
          let plaintext = removeMarkdown(file.content).trim();

          // End the description at a period (inclusive) or newline (not)
          // somewhere around the lenghtish mark.
          let lenghtish = 60;
          let dot = plaintext.indexOf(".", lenghtish) + 1;
          let newline = plaintext.indexOf("\n", lenghtish);

          // Avoid substringing to the empty string
          if (dot === -1) dot = plaintext.length;
          if (newline === -1) newline = plaintext.length;

          file.excerpt = plaintext.substring(0, Math.min(dot, newline));
      },
  });

  eleventyConfig.addPassthroughCopy({
    [ASSETS_FOLDER]: './',
    [SCRIPTS_FOLDER]: './js',
  });
};
