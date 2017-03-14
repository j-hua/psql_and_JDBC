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
DROP VIEW IF EXISTS groupWorkers CASCADE;
DROP VIEW IF EXISTS groupAverages CASCADE;
DROP VIEW IF EXISTS iAsolo CASCADE;
DROP VIEW IF EXISTS finalAssignments CASCADE;

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

CREATE VIEW groupWorkers AS SELECT group_id, COUNT(*) as group_count
FROM membership
Group by group_id
Having COUNT(group_id)>1;


CREATE VIEW groupAverages AS SELECT assignment_id, AVG(percentage) as avg_group, SUM(group_count) as group_size, AVG(group_count) as size_avg
FROM totalmark JOIN groupworkers on totalmark.group_id=groupworkers.group_id 
Group BY assignment_id;

CREATE VIEW iAsolo AS SELECT Assignment.assignment_id, Assignment.description, soloAverages.num_solo, soloAverages.avg_solo
FROM soloAverages RIGHT OUTER JOIN Assignment on soloAverages.assignment_id = Assignment.assignment_id;

CREATE VIEW finalAssignments AS SELECT iAsolo.assignment_id, iAsolo.description, iAsolo.num_solo, iAsolo.avg_solo, group_size, avg_group, size_avg
FROM iAsolo JOIN groupAverages on groupAverages.assignment_id = iAsolo.assignment_id;


INSERT INTO q3
	-- put a final query here so that its results will go into the table.
