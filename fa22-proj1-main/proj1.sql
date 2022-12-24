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
CREATE VIEW q3iii(namefirst, namelast, lslg)
AS
  SELECT 1, 1, 1 -- replace this line
;

-- Question 4i
CREATE VIEW q4i(yearid, min, max, avg)
AS
  SELECT 1, 1, 1, 1 -- replace this line
;

-- Question 4ii
CREATE VIEW q4ii(binid, low, high, count)
AS
  SELECT 1, 1, 1, 1 -- replace this line
;

-- Question 4iii
CREATE VIEW q4iii(yearid, mindiff, maxdiff, avgdiff)
AS
  SELECT 1, 1, 1, 1 -- replace this line
;

-- Question 4iv
CREATE VIEW q4iv(playerid, namefirst, namelast, salary, yearid)
AS
  SELECT 1, 1, 1, 1, 1 -- replace this line
;
-- Question 4v
CREATE VIEW q4v(team, diffAvg) AS
  SELECT 1, 1 -- replace this line
;

