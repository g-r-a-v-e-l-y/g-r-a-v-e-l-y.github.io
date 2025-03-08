const {
    initialSetup,
    layoutAliases,
    collections,
    shortcodes,
    filters,
    plugins,
    constants,
    events,
} = require('./_11ty');
const minifyHTML = require('./_11ty/transforms/minifyHTML');
const minifyJS = require('./_11ty/transforms/minifyJS');
const minifyJSON = require('./_11ty/transforms/minifyJSON');
const minifyXML = require('./_11ty/transforms/minifyXML');
const _ = require("lodash");
const { DateTime } = require("luxon");





module.exports = function(eleventyConfig) {
    // --- Initial config

    initialSetup(eleventyConfig);

    // --- Layout aliases

    Object.entries(layoutAliases).forEach(([name, path]) => {
        eleventyConfig.addLayoutAlias(name, path);
    });

    // --- Collections

    Object.values(collections).forEach(({ name, body }) => {
        eleventyConfig.addCollection(name, body);
    });
    eleventyConfig.addCollection("postsByYear", (collection) => {
        return _.chain(collection.getAllSorted())
            .groupBy((post) => post.date.getFullYear())
            .toPairs()
            .reverse()
            .value();
    });


    // Year / Month collection
    eleventyConfig.addCollection('postsByYearMonth', (collection) => {
        return _.chain(collection.getAllSorted())
            .filter((item) => 'tags' in item.data && item.data.tags.includes('posts'))
            .groupBy((post) => {
                const year = post.date.getFullYear();
                const month = String(post.date.getMonth() + 1).padStart(2, '0');
                return `${year}/${month}`;
            })
            .toPairs()
            .reverse()
            .value();
    });

    // --- Transformations

    eleventyConfig.addTransform('minifyHTML', minifyHTML);
    eleventyConfig.addTransform('minifyJSON', minifyJSON);
    eleventyConfig.addTransform('minifyXML', minifyXML);
    eleventyConfig.addTransform('minifyJS', minifyJS);

    // --- Filters

    Object.values(filters).forEach(({ name, body }) => {
        eleventyConfig.addFilter(name, body);
    });

    // Helper filter to format month names
    eleventyConfig.addFilter('monthName', (monthNum) => {
        const date = new Date(2000, parseInt(monthNum) - 1, 1);
        return date.toLocaleString('en-US', { month: 'long' });
    });

    // Helper filters for parsing date parts
    eleventyConfig.addFilter('getYear', (dateStr) => dateStr.split('/')[0]);
    eleventyConfig.addFilter('getMonth', (dateStr) => dateStr.split('/')[1]);
    eleventyConfig.addFilter('getDay', (dateStr) => dateStr.split('/')[2]);
    eleventyConfig.addFilter('htmlDateString', (dateObj) => {
   return DateTime.fromJSDate(dateObj, {zone: 'utc'}).toFormat('yyyy-LL-dd');
});

    // --- Shortcodes

    Object.values(shortcodes).forEach(({ name, body }) => {
        eleventyConfig.addShortcode(name, body);
    });

    // --- Plugins

    Object.values(plugins).forEach(({ body, options }) => {
        eleventyConfig.addPlugin(body, options && options);
    });

    // --- After build events

    if (events.after.length > 0) {
        Object.values(events.after).forEach((afterBuildEvent) => {
            eleventyConfig.on('eleventy.after', afterBuildEvent);
        });
    }

    // --- Consolidating everything under content folder

    return {
        dir: {
            input: constants.CONTENT_FOLDER,
        },
        templateFormats: ['md', 'njk'],
        htmlTemplateEngine: 'njk',
        markdownTemplateEngine: 'njk',
    };
};