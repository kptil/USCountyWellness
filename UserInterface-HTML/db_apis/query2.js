const db = require('../services/database.js');
const tb = require('../table.js')

const baseQuery = `SELECT state_name, county_em_year, num / denom as rate
                    from (
                        select state_name, county_em_year, sum(labor_force) as denom, sum(unemployed) as num
                        from (
                            (select coid, state_name from ${tb.tables.countyTest} where state_name = 'Florida')
                            natural join ${tb.tables.countyHasEmploymentTest}
                        )
                    where state_name = 'Florida'
                    group by state_name, county_em_year
                    )
                    where (county_em_year >= 2000 and county_em_year <= 2005)`;

async function find(context) {
    let query = baseQuery;
    const binds = {};

    //console.log(query);
    const result = await db.simpleExecute(query, binds);
    //console.log(result);
    return result.rows;
}

module.exports.find = find;