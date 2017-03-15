-- Solo superior

SET SEARCH_PATH TO markus;
DROP TABLE IF EXISTS q3;

-- You must not change this table definition.
CREATE TABLE q3 (
	assignment_id integer,
	description varchar(100), 
	num_solo integer, 
	average_solo real,
	num_collaborators integer, 
	average_collaborators real, 
	average_students_per_submission real
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS weightedMarks CASCADE;
DROP VIEW IF EXISTS totalMarks CASCADE;
DROP VIEW IF EXISTS soloWorkers CASCADE;
DROP VIEW IF EXISTS soloAverages CASCADE;
DROP VIEW IF EXISTS groupSize CASCADE;
DROP VIEW IF EXISTS allAverages CASCADE;
DROP VIEW IF EXISTS groupWorkers CASCADE;
DROP VIEW IF EXISTS groupAverages CASCADE;
DROP VIEW IF EXISTS intermSoloAssignments CASCADE;
DROP VIEW IF EXISTS interm CASCADE;

CREATE VIEW weightedMarks AS SELECT assignment_id, group_id, grade.rubric_id, grade*weight as weightedGrade, out_of*weight as weightedOutOf 
FROM RubricItem JOIN grade ON rubricitem.rubric_id = grade.rubric_id;

CREATE VIEW totalMark AS 
SELECT assignment_id, group_id, SUM(weightedGrade)/SUM(weightedOutOf) as percentage 
FROM weightedMarks
Group by group_id, assignment_id;

CREATE VIEW soloWorkers AS SELECT group_id
FROM membership
Group by group_id
Having COUNT(group_id)=1;

CREATE VIEW soloAverages AS SELECT assignment_id,AVG(percentage) as avg_solo, COUNT(*) as num_solo
FROM totalmark JOIN soloWorkers on totalmark.group_id=soloworkers.group_id 
Group BY assignment_id;

CREATE VIEW groupSize AS SELECT assignment_id, membership.group_id, COUNT(*) as group_count
FROM assignmentGroup JOIN membership ON assignmentGroup.group_id = membership.group_id
Group by assignment_id, membership.group_id;

CREATE VIEW groupWorkers AS SELECT assignment_id, group_id, group_count
FROM groupSize
WHERE group_count>1;

CREATE VIEW allAverages AS SELECT assignment_id, AVG(group_count) as avg_size
FROM groupSize
Group By assignment_id; 

CREATE VIEW groupAverages AS SELECT totalMark.assignment_id, AVG(percentage) as avg_group, SUM(group_count) as group_size
FROM totalmark JOIN groupworkers on totalmark.group_id=groupworkers.group_id 
Group BY totalMark.assignment_id;


CREATE VIEW intermSoloAssignments AS SELECT Assignment.assignment_id, Assignment.description, soloAverages.num_solo, soloAverages.avg_solo
FROM soloAverages RIGHT OUTER JOIN Assignment on soloAverages.assignment_id = Assignment.assignment_id;

CREATE VIEW interm AS SELECT intermSoloAssignments.assignment_id, description, num_solo, avg_solo, avg_group ,group_size 
FROM intermSoloAssignments LEFT OUTER JOIN groupAverages ON intermSoloAssignments.assignment_id=groupAverages.assignment_id;

INSERT INTO q3 SELECT interm.assignment_id, interm.description, interm.num_solo, interm.avg_solo, interm.group_size, interm.avg_group, allAverages.avg_size
FROM allAverages JOIN interm on interm.assignment_id = allAverages.assignment_id;
