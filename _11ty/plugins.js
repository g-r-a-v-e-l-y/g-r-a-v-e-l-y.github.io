const { IS_PRODUCTION } = require('./constants');
const pluginRss = require('@11ty/eleventy-plugin-rss');
const { EleventyHtmlBasePlugin } = require('@11ty/eleventy');
const pluginEmoji = require('eleventy-plugin-emoji');
const eleventyNavigationPlugin = require('@11ty/eleventy-navigation');
const srcSet = require('./plugins/srcset');
const syntaxHighlight = require('@11ty/eleventy-plugin-syntaxhighlight');
const embeds = require("eleventy-plugin-embed-everything");

const productionPlugins = IS_PRODUCTION
  ? [
      {
        body: srcSet,
      },
    ]
  : [];

const plugins = [
  {
    body: EleventyHtmlBasePlugin,
  },
  {
    body: pluginRss,
  },
  {
    body: pluginEmoji,
  },
  {
    body: eleventyNavigationPlugin,
  },
  {
    body: syntaxHighlight,
  },
  {
    body: embeds,
  },
];

module.exports = [...plugins, ...productionPlugins];
