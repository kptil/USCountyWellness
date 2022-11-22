const express = require('express');
const router = new express.Router();
const counties = require('../controllers/counties.js');
const mother = require('../controllers/mother.js');
const query2 = require('../controllers/query2.js');

router.route('/counties/').
    get(counties.get);

router.route('/mother/').
    get(mother.get);

router.route('/query2/').get(query2.get);

module.exports = router;