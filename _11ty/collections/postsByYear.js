const postsByYear = (posts, startYear = 1999) => {
    let years = [];
        for(let j = startYear; j <= (new Date()).getFullYear(); j++) {
            let year = j;
            let count = posts.filter(function(post) {
            }).filter(function(post) {
                return post.data.page.date.getFullYear() === parseInt(year, 10);
            }).length;
            years.push(count);
        }
        return years.join(",");
};

module.exports = {
  postsByYear,
};