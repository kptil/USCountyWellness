const query2 = require('../db_apis/query2.js');

async function get(req, res, next) {

    try {
        const context = {};

        const rows = await query2.find(context);
        res.status(200).json(rows);

    } catch (err) {
        next(err);
    }
}
module.exports.get = get;