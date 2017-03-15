-- Distributions

SET SEARCH_PATH TO markus;
DROP TABLE IF EXISTS q1;

-- You must not change this table definition.
CREATE TABLE q1 (
	assignment_id integer,
	average_mark_percent real, 
	num_80_100 integer, 
	num_60_79 integer, 
	num_50_59 integer, 
	num_0_49 integer
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS weightedMarks CASCADE;
DROP VIEW IF EXISTS totalMark CASCADE;

CREATE VIEW weightedMarks AS SELECT assignment_id, group_id, grade.rubric_id, grade*weight as weightedGrade, out_of*weight as weightedOutOf 
FROM RubricItem JOIN grade ON rubricitem.rubric_id = grade.rubric_id;

CREATE VIEW totalMark AS 
SELECT assignment_id, group_id, SUM(weightedGrade)/SUM(weightedOutOf) as percentage 
FROM weightedMarks
Group by group_id, assignment_id;


INSERT INTO q1 SELECT assignment_id, SUM(case when percentage>=.80 then 1 else 0 end) above80,SUM(case when percentage>=0.60 and percentage<0.80 then 1 else 0 end) above60,SUM(case when percentage>=0.50 and percentage>60then 1 else 0 end) above50,SUM(case when percentage<50 then 1 else 0 end) failed, AVG(percentage) 
FROM totalmark 
Group BY assignment_id;
