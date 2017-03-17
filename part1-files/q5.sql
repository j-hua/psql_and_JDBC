-- Uneven workloads

SET SEARCH_PATH TO markus;
DROP TABLE IF EXISTS q5;

-- You must not change this table definition.
CREATE TABLE q5 (
	assignment_id integer,
	username varchar(25), 
	num_assigned integer
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS intermediate_step CASCADE;

DROP VIEW IF EXISTS graderToAssignment CASCADE;
CREATE VIEW graderToAssignment AS SELECT Grader.username, Grader.group_id, AssignmentGroup.assignment_id
FROM Grader Join AssignmentGroup on Grader.group_id = AssignmentGroup.group_id;

DROP VIEW IF EXISTS groupCounts CASCADE;
CREATE VIEW groupCounts AS SELECT username, assignment_id, count(group_id) as group
FROM graderToAssignment
Group By username, assignment_id;

DROP VIEW IF EXISTS maxMin CASCADE;
CREATE VIEW maxMin AS SELECT assignment_id, max(groupCounts.group), min(groupCounts.group)
FROM groupCounts
Group By assignment_id;

DROP VIEW IF EXISTS suchAssignments CASCADE;
CREATE VIEW suchAssignments AS SELECT DISTINCT assignment_id
FROM maxMin
where max > min + 10;


-- Final answer.
INSERT INTO q5 SELECT suchAssignments.assignment_id, username, groupCounts.group 
FROM suchAssignments JOIN groupCounts ON suchAssignments.assignment_id=groupCounts.assignment_id;
