-- Query 1: For each year, find average number of cigarettes smoked by mothers in counties where income is less than y
-- and less than xx% of the population has a Bachelors degree or higher.

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

-- Query 5: For every year, how many mothers had every risk factor and still had successful pregnancies?
