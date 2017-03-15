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

CREATE VIEW graderToAssignment AS SELECT Grader.username, Grader.group_id, AssignmentGroup.assignment_id
FROM Grader Join AssignmentGroup on Grader.group_id = AssignmentGroup.group_id;

CREATE VIEW groupCounts AS SELECT username, assignment_id, count(group_id) as group
FROM graderToStudent
Group By username, assignment_id;

CREATE VIEW maxMin AS SELECT assignment_id, MAX(group) as max, MIN(group) as min
FROM groupCounts
Group By assignment_id
Having max>min+10;


CREATE VIEW suchAssignments AS SELECT DISTINCT assignment_id
FROM maxMin;


-- Final answer.
INSERT INTO q5 SELECT assignment_id, username, num_assigned 
FROM suchAssignments JOIN graderToAssignment ON suchAssignments.assignment_id=graderToAssignment.assignment_id;
