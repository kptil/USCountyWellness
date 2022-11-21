const cred = require('./config/database.js')

const table = (tableName) => {
    return cred.connection.user +'.'+ tableName;
};

const _population = 'JWILLIAMS16.POPULATION';
const _mother = 'WEISSB.MOTHER';
const _hasRisk = 'WEISSB.MOTHERHASRISKFACTOR';
const _motherRisk = 'WEISSB.MOTHER RISK';
// created test tables to avoid key constraints on actual tables when entering dummy data
const _county = 'KTILEY.COUNTYTEST';
const _countHasEmployment = 'KTILEY.COUNTYHASEMPLOYMENTTEST'

// TODO:
// Adjust query 2 to incorporate at least state
// Copy db_apis\counties.js to run query 2
// Get results to show up under graph on Query 2 page


module.exports = {
    tables : {
        population : _population,
        mother : _mother,
        hasRisk : _hasRisk,
        motherRisk : _motherRisk
    }
}