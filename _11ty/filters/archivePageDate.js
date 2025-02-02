const moduleName = require('../helpers/moduleName');
const { DateTime } = require('luxon');

const body = (dateObj) => {
  return DateTime.fromJSDate(dateObj, { zone: 'utc' }).toFormat('yyyy/LLL/d');
};

module.exports = {
  name: moduleName(__filename),
  body,
};
