const server = require('./services/server.js');     //Module where we initialize server, and listen for requests
const dbConfig = require('./config/database.js');
const db = require('./services/database.js');
const defaultPool = 4;
process.env.UV_THREADPOOL_SIZE = dbConfig.connection.poolMax + defaultPool;

async function start() {
    console.log('Start...');
    //First we will start the nodeoracledb module
    try {
        console.log('Initializing database module');
        db.start();
    } catch (err) {
        console.error(err);
        process.exit(1);
    }
    //Initialize the server and exit if the server module throws any errors
    try {
        console.log('initializing web module');
        await server.initialize();
    } catch (err) {
        console.error(err);
        process.exit(1);
    }
}

start();

async function killServer(e) {
    console.log('Terminating server...');
    try {
        await server.terminate();

    } catch (err) {
        console.error(e);

    }
}
process.on('SIGINT', () => {
    console.log('SIGINT');
    killServer();
});