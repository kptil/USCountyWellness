const oracledb = require('oracledb');
const dbConfig = require('../config/database.js');
oracledb.initOracleClient({libDir: './instantclient_21_7'});

async function start() {
    const pool = await oracledb.createPool(dbConfig.connection);
}
module.exports.start = start;

async function close() {
    await oracledb.getPool().close();
}
module.exports.close = close;

function simpleExecute(statement, binds = [], opts = {}) {
    return new Promise(async (resolve, reject) => {
        let conn;

        opts.outFormat = oracledb.OBJECT;
        opts.autoCommit = true;

        try {
            conn = await oracledb.getConnection();
            console.log('Connecting...');
            const result = await conn.execute(statement, binds, opts);
            console.log('Resolved!');
            resolve(result);
        } catch (err) {
            reject(err);
        } finally {
            if (conn) { // conn assignment worked, need to close
                try {
                    await conn.close();
                } catch (err) {
                    console.log(err);
                }
            }
        }
    });
}

module.exports.simpleExecute = simpleExecute;