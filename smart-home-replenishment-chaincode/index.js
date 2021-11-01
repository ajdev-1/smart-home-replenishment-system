'use strict'

const productContract = require('./lib/productContract');
const userSettingsContract = require('./lib/userSettingsContract');
const enrollmentContract = require('./lib/enrollmentContract');

module.exports.productContract = productContract;
module.exports.userSettingsContract = userSettingsContract;
module.exports.enrollmentContract = enrollmentContract;
module.exports.contracts = [ productContract, userSettingsContract, enrollmentContract ];