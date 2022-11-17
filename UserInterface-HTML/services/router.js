const express = require('express');
const router = new express.Router();
const counties = require('../controllers/counties.js');
const mother = require('../controllers/mother.js');

router.route('/counties/').
    get(counties.get);

router.route('/mother/').
    get(mother.get);

module.exports = router;