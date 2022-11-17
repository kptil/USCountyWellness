const counties = require('../db_apis/mother.js');

async function get(req, res, next) {

    try {
        const context = {};
        context.MID= req.params.MID;
        const rows = await counties.find(context);
        //console.log(context);
        if (req.params.MID) {
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