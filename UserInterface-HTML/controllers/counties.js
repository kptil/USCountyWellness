const counties = require('../db_apis/counties.js');

async function get(req, res, next) {

    try {
        const context = {};
        context.FIPS= req.params.FIPS;
        const rows = await counties.find(context);

        if (req.params.FIPS) {
            if(rows.length === 1) {
                res.status(200).json(rows[0]);
            } else {
                res.status(404).end();
            }
        } else {
            res.status(200).json(rows);
        }

    } catch (err) {
        next(err);
    }
}
module.exports.get = get;