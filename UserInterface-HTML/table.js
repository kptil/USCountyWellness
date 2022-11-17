const cred = require('./config/database.js')

const table = (tableName) => {
    return cred.connection.user +'.'+ tableName;
};

const _population = 'JWILLIAMS16.POPULATION';
const _mother = 'WEISSB.MOTHER';
const _hasRisk = 'WEISSB.MOTHERHASRISKFACTOR';
const _motherRisk = 'WEISSB.MOTHER RISK';


module.exports = {
    tables : {
        population : _population,
        mother : _mother,
        hasRisk : _hasRisk,
        motherRisk : _motherRisk
    }
}