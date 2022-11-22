-- Query 1: For each year, find average number of cigarettes smoked by mothers in counties where income is less than y
-- and less than xx% of the population has a Bachelors degree or higher.
-- DONE - BIRTH METRICS. I think this query should be in a separate chart by itself with some explanatory text on
-- why it is relevant/interesting. When discussing with him, he didn't like it until he realized by 'mother' I
-- I meant an individual who is actually pregnant (which is fair).

-- Assuming Mother has attribute "Cigarettes_Smoked"

with ValidCounties(coID, year) as (
    select coID, year from (
        (select coID from County where avgHHLDIncome2000 < 20000)
        natural join
        (select County_ED_Year as year, coID, County_ED_Total from CountyHasEduLevel
        where Ed_Level = 'Bachelors+')
        join
        (select County_Pop_Year as year, coID, County_Total from CountyHasPop)
        using (year, coID)
    )
    where County_ED_Total / County_Total * 100 < 20
)
select year, avg(Cigarettes_Smoked) as avgCigarettes from
    (ValidCounties
    join
    (select bID, DOB_Y as year, mID, coID from Birth)
    using (coID, year))
    join
    (select mID, cigarettes_smoked from Mother)
    using (mID)
where (year >= 2000 and year <= 2005)
group by year;


-- Query 2: For each year, what was the unemployment rate for each state?
-- DONE - BASELINE-METRICS. This query could be in a chart where the user choses the x and y axes from a dropdown menu
-- like we'd initially thought, since it doesn't require much explanation. We could add just one other similar baseline
-- query, or just say 'here's a demo, we'll have more in the final version' during the presentation.

select state_name, county_em_year, num / denom as rate
from (
        select state_name, county_em_year, sum(labor_force) as denom, sum(unemployed) as num
        from (
                (select coid, state_name from county where state_name = 'Florida')
                natural join countyhasemployment
            )
        group by state_name, county_em_year
        where state_name = 'Florida'
    )
where (county_em_year >= 2000 and county_em_year <= 2005);

-- Query 3: How has the annual fetal death rate changed year by year for children of a given race?

select DOB_Y, fetalDeaths / totalBirths as fetalDeathRate
from (
    (select DOB_Y, count(bID) as totalBirths
    from (select bID, DOB_Y from Birth where bID in (select bID from Child))
         natural join
         (select mID from Mother where race = 'white')
    group by DOB_Y)
natural join
    (select DOB_Y, count(bID) as fetalDeaths
    from (select bID, DOB_Y from Birth where bID not in (select bID from Child))
         natural join
         (select mID from Mother where race = 'white')
    group by DOB_Y)
)
where (DOB_Y >= 2000 and DOB_Y <= 2005);


-- Query 4: For each year, how many births received adequate prenatal care in states where minorities made up
-- xx% of the population? Minority in this case is defined as not white.

with statepops(race_pop_year, state_name, pop) as (
    select county_pop_year, state_name, sum(county_total)
    from CountyHasPop natural join US_State
    group by county_pop_year, state_name
)
select DOB_Y, count(bID) as numBirths
from (
        select bID, DOB_Y from (Birth natural join (select coID, state_name from County))
        where state_name in (   select state_name
                                from statepops join StateHasPopByRace
                                using (state_name, race_pop_year)
                                where DOB_Y = race_pop_year and (race_count / pop > .5)
                            )
      )
      natural join Receives_Prenatal_Care
where (care_adequacy = 'adequate') and (DOB_Y >= 2000 and DOB_Y <= 2005)
group by DOB_Y;

-- Query 5: For every year, how many mothers had every risk factor and still had successful pregnancies in state?
-- BIRTH METRICS
-- Question is good, just needs implemented

with motherRiskState(year, mID, risk_factor) as (
    select DOB_Y, mID, risk_factor
    from (
            (select DOB_Y, mID
            from Mother natural join Birth natural join County
            where state_name = 'Florida')
            natural join
            MotherHasRiskFactor
         )
)
select year, count(mID) as numMothers
from (
    ( select * from motherRiskState )
    minus
    (
        select year, mID, risk_factor
        from (
                (select * from (select year, mID from motherRiskState),
                               (select risk_factor from MotherHasRiskFactor))
                minus
                (select * from motherRiskState)
             )
    )
    )
where year >= 2000 and year <= 2005
group by year;



-- !!!! OLD QUERIES - DO NOT USE !!!!! --
-- OLD Query 2: For each year, how many states did not have any counties with unemployement rate less than x (15% default)?
-- BASELINE-METRICS
-- CHANGE: Aggregate unemployment for each state and include a line in chart for each state. So the query output
-- would be state, year, unemployment as percent of state population.
with ValidCounties(coID, year) as (
    select coID, County_Pop_Year
    from CountyHasPop
    where not exists ( select * from CountyHasEmployment
                       where CountyHasPop.coID = CountyHasEmployment.coID and
                             County_EM_Year = County_Pop_Year and
                             unemployed / labor_force * 100 >= 15
                     )
)
select year, count(state_name) as numStates
from ValidCounties natural join ( select coID, state_name from County )
group by year;

-- OLD Query 3: How has the annual fetal death rate changed year by year for children of a given race in states
-- where percent uninsured greater than x?
-- CHANGE: Break into two separate queries, one for race and one for percent uninsured. If we can, we can have one
-- graph that display two lines, one for each query. User can toggle each one on and off and see the comparison.
-- or just two side by side charts with one explanatory section for both.

select DOB_Y, fetalDeaths / totalBirths as fetalDeathRate
from (
    (select DOB_Y, count(bID) as totalBirths
    from (select bID, DOB_Y from Birth where bID in (select bID from Child))
         natural join
         (select mID from Mother where race = 'white')
         natural join
         (select coID from County where state_name in ( select state_name
                                                        from US_State
                                                        where Percent_Uninsured > 20))
    group by DOB_Y)
natural join
    (select DOB_Y, count(bID) as fetalDeaths
    from (select bID, DOB_Y from Birth where bID not in (select bID from Child))
         natural join
         (select mID from Mother where race = 'white')
         natural join
         (select coID from County where state_name in ( select state_name
                                                        from US_State
                                                        where Percent_Uninsured > 20))
    group by DOB_Y)
);