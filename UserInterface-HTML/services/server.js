const http = require('http');
const express = require('express');                 //Express, must be npm installed
const sConfig = require('../config/server.js');     //Contains information on port, default to 3000
const morgan = require('morgan');                   //Module for HTTP logging
const database = require('./database.js');
const router = require('./router.js');
const cors = require("cors");
let server;

function initialize () {     //Starts web server and tells us if it is successful by returning a Promise
    return new Promise((resolve, reject) => {
        const app = express();
        server = http.createServer(app);    //Creates new http server based on an express app
        app.use(morgan('combined')); //Enables http logging
        app.use(cors());
        app.use('/api', router);
        //app.get('/', async (req, res) => {  //Handles "get" request
        //    const result = await database.simpleExecute(`SELECT * FROM POPULATION WHERE STATE = 'FL'`);
        //    var area = '';
        //    let state = '';
//
        //    for (let i = 0; i < result.rows.length; i++) {
        //        area += result.rows[i].AREA_NAME +'\n\t';
        //        state += result.rows[i].STATE + '\n\t';
        //    }
//
//
        //    res.end('Test query on population data: \n' +
        //        '\tSELECT * FROM POPULATION \n' +
        //        '\tWHERE STATE = \'FL\'\n' +
        //        'The areas:\n\t' + area +
        //        '\nThe states (Should just be FL):\n\t' + state);
        //});

        server.listen(sConfig.port, err => {  //Listens for requests at the port
            if (err) {
                reject(err);
                return;
            }
            console.log('Listening on localhost:' + sConfig.port);
            resolve();
        });
    });
}
module.exports.initialize = initialize;

function terminate() {  //Stops new connections and assures the server closed
    return new Promise((resolve, reject) => {
        server.close((err) => {
            if(err) {
                reject(err);
                return;
            }
            resolve();
        })
    })
}
module.exports.terminate = terminate;
