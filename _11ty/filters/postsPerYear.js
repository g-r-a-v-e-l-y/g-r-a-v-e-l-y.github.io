const { DateTime } = require('luxon');
const moduleName = require('../helpers/moduleName');

const body = (posts) => {
    let years = [];
    for(let j = 1999; j <= (new Date()).getFullYear(); j++) {
        let year = j;
            let count = posts.filter(function(post) {
                if(!post.data.tags) {
                    return true;
                }
                if(post.data.deprecated ||post.data.tags.includes("draft")) {
                    return false;
                }
                return true;
            }).filter(function(post) {
                return post.data.page.date.getFullYear() === parseInt(year, 10);
            }).length;
            years.push(count);
        }
        return years.join(",");
};

module.exports = {
  name: moduleName(__filename),
  body,
};
