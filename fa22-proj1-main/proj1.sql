-- Before running drop any existing views
DROP VIEW IF EXISTS q0;
DROP VIEW IF EXISTS q1i;
DROP VIEW IF EXISTS q1ii;
DROP VIEW IF EXISTS q1iii;
DROP VIEW IF EXISTS q1iv;
DROP VIEW IF EXISTS q2i;
DROP VIEW IF EXISTS q2ii;
DROP VIEW IF EXISTS q2iii;
DROP VIEW IF EXISTS q3i;
DROP VIEW IF EXISTS q3ii;
DROP VIEW IF EXISTS q3iii;
DROP VIEW IF EXISTS q4i;
DROP VIEW IF EXISTS q4ii;
DROP VIEW IF EXISTS q4iii;
DROP VIEW IF EXISTS q4iv;
DROP VIEW IF EXISTS q4v;

-- Question 0
CREATE VIEW q0(era) AS
    SELECT MAX(era)
    FROM pitching
;

-- Question 1i
CREATE VIEW q1i(namefirst, namelast, birthyear) AS
    SELECT nameFirst, nameLast, birthyear
    FROM people
    WHERE weight > 300
;

-- Question 1ii
CREATE VIEW q1ii(namefirst, namelast, birthyear) AS
    SELECT nameFirst, nameLast, birthyear
    FROM people
    WHERE nameFirst LIKE '% %'
    ORDER BY nameFirst ASC , nameLast ASC
;

-- Question 1iii
CREATE VIEW q1iii(birthyear, avgheight, count) AS
    SELECT birthYear, AVG(height), COUNT(*)
    FROM people
    GROUP BY birthYear
    ORDER BY birthYear ASC
;

-- Question 1iv
CREATE VIEW q1iv(birthyear, avgheight, count) AS
    SELECT birthYear, AVG(height), COUNT(*)
    FROM people
    GROUP BY birthYear
    HAVING AVG(height) > 70
    ORDER BY birthYear ASC
;

-- Question 2i
CREATE VIEW q2i(namefirst, namelast, playerid, yearid) AS
    SELECT p.nameFirst, p.nameLast, p.playerID, h.yearid
    FROM people as p LEFT JOIN halloffame as h
    ON p.playerID = h.playerID
    WHERE h.inducted = 'Y'
    ORDER BY h.yearid DESC, p.playerID ASC
;

-- Question 2ii
CREATE VIEW q2ii(namefirst, namelast, playerid, schoolid, yearid) AS
    SELECT h.nameFirst, h.nameLast, h.playerID, c.schoolID, h.yearid
    FROM q2i as h LEFT JOIN collegeplaying as c LEFT JOIN schools as s
    ON h.playerID = c.playerID AND c.schoolID = s.schoolID
    WHERE s.schoolState = 'CA'
    ORDER BY h.yearid DESC, c.schoolID ASC, h.playerID ASC
;

-- Question 2iii
CREATE VIEW q2iii(playerid, namefirst, namelast, schoolid) AS
    -- FOR q2iii-alt: SELECT DISTINCT h.playerID, h.nameFirst, h.nameLast, c.schoolID
    SELECT h.playerID, h.nameFirst, h.nameLast, c.schoolID
    FROM q2i as h LEFT JOIN collegeplaying as c
    ON h.playerID = c.playerID
    ORDER BY h.playerID DESC, c.schoolID ASC
;

-- Question 3i
CREATE VIEW q3i(playerid, namefirst, namelast, yearid, slg) AS
    SELECT p.playerID, p.nameFirst, p.nameLast, b.yearID, CAST(b.H+b.H2B+2*b.H3B+3*b.HR AS FLOAT)/b.AB AS slg
    FROM people as p LEFT JOIN batting as b
    ON p.playerID = b.playerID
    WHERE b.AB > 50
    ORDER BY slg DESC, b.yearID, p.playerID
    LIMIT 10
;

-- Question 3ii
CREATE VIEW q3ii(playerid, namefirst, namelast, lslg) AS
    SELECT p.playerID, p.nameFirst, p.nameLast, CAST(SUM(b.H+b.H2B+2*b.H3B+3*b.HR) AS FLOAT)/SUM(b.AB) AS lslg
    FROM people as p LEFT JOIN batting as b
    ON p.playerID = b.playerID
    GROUP BY p.playerID, p.nameFirst, p.nameLast
    HAVING SUM(b.AB) > 50
    ORDER BY lslg DESC, b.yearID, p.playerID
    LIMIT 10
;

-- Question 3iii
CREATE VIEW q3iii(namefirst, namelast, lslg) AS
    SELECT p.nameFirst, p.nameLast, CAST(SUM(b.H+b.H2B+2*b.H3B+3*b.HR) AS FLOAT)/SUM(b.AB) AS lslg
    FROM people as p LEFT JOIN batting as b
    ON p.playerID = b.playerID
    GROUP BY p.playerID, p.nameFirst, p.nameLast
    HAVING SUM(b.AB) > 50 AND lslg > (
        SELECT CAST(SUM(b.H+b.H2B+2*b.H3B+3*b.HR) AS FLOAT)/SUM(b.AB) AS alslg
        FROM people as p LEFT JOIN batting as b
        ON p.playerID = b.playerID
        GROUP BY p.playerID
        HAVING p.playerID = 'mayswi01'
        )
    ORDER BY lslg DESC, b.yearID, p.playerID
;

-- Question 4i
CREATE VIEW q4i(yearid, min, max, avg) AS
    SELECT yearID, MIN(salary), MAX(salary), SUM(salary)/COUNT(salary)
    FROM salaries
    GROUP BY yearID
    ORDER BY yearID
;

-- Question 4ii
CREATE VIEW q4ii(binid, low, high, count) AS
    SELECT b.binid, b.low, b.high, COUNT(*)
    FROM (SELECT b.binid                                                              AS binid,
                 (MAX(s.salary) - MIN(s.salary)) * b.binid / 10 + MIN(s.salary)       AS low,
                 (MAX(s.salary) - MIN(s.salary)) * (b.binid + 1) / 10 + MIN(s.salary) AS high
          FROM binids AS b,
               salaries AS s
          WHERE s.yearID = 2016
          GROUP BY b.binid) AS b LEFT JOIN salaries as s
    ON (b.low <= s.salary AND b.high > s.salary) OR (b.high = s.salary AND b.binid = 9)
    WHERE s.yearID = 2016
    GROUP BY b.binid
;

-- Question 4iii
CREATE VIEW q4iii(yearid, mindiff, maxdiff, avgdiff) AS
    SELECT s1.yearid, s1.min-s2.min, s1.max-s2.max, s1.avg-s2.avg
    FROM q4i as s1 LEFT JOIN q4i as s2
    ON s1.yearid = s2.yearid+1
    WHERE s1.yearid <> 1985
;

-- Question 4iv
CREATE VIEW q4iv(playerid, namefirst, namelast, salary, yearid) AS
    SELECT s1.playerid, p.nameFirst, p.nameLast, s1.salary, s1.yearID
    FROM salaries as s1
        LEFT JOIN people as p
            ON s1.playerID = p.playerID
        LEFT JOIN q4i as s2
            ON s1.yearID = s2.yearid
    WHERE (s1.yearID = 2000 OR s1.yearID = 2001) AND s1.salary = s2.max
    ORDER BY s1.yearID
;
-- Question 4v
CREATE VIEW q4v(team, diffAvg) AS
    SELECT a.teamID, MAX(s.salary) - MIN(s.salary)
    FROM allstarfull AS a LEFT JOIN salaries AS s
    ON a.playerID = s.playerID AND a.yearID = s.yearID
    WHERE a.yearID = 2016
    GROUP BY a.teamID
;

