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
group by year;

-- Query 2: For each year, how many states did not have any counties with unemployement rate less than x (15% default)?
-- BASELINE-METRICS
-- CHANGE: Aggregate unemployment for each state and include a line in chart for each state. So the query output 
-- would be state, year, unemployment as percent of state population.
-- This query could be in a chart where the user choses the x and y axes from a dropdown menu like we'd initially
-- thought, since it doesn't require much explanation. We could add just one other similar baseline query, or just
-- say 'here's a demo, we'll have more in the final version' during the presentation.

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

-- Query 3: How has the annual fetal death rate changed year by year for children of a given race in states where the 
-- average percent of people uninsured is greater than x (20%)? 
-- BIRTH METRICS
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

-- Query 4: For each year, how many births received excellent prenatal care in states with large minority populations. 
-- large default: > 50 percent of total pop
-- BIRTH METRICS
-- Question is good, just needs implemented

-- Query 5: For every year, how many mothers had every risk factor and still had successful pregnancies?
-- BIRTH METRICS
-- Question is good, just needs implemented