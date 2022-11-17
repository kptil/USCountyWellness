const db = require('../services/database.js');
const tb = require('../table.js')

const baseQuery = `SELECT * FROM ${tb.tables.mother}`;

async function find(context) {
    let query = baseQuery;

    const binds = {};
    //console.log(context);
    if (context.MID) {
        binds.MID = context.MID;
        query += ' WHERE MID = :MID'
    }
    //console.log(query);
    const result = await db.simpleExecute(baseQuery, binds);
    //console.log(result);
    return result.rows;
}

module.exports.find = find;