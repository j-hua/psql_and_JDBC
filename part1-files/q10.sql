-- A1 report

SET SEARCH_PATH TO markus;
DROP TABLE IF EXISTS q10;

-- You must not change this table definition.
CREATE TABLE q10 (
	group_id integer,
	mark real,
	compared_to_average real,
	status varchar(5)
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS intermediate_step CASCADE;

-- Define views for your intermediate steps here.
DROP VIEW IF EXISTS weightedMarks CASCADE;
DROP VIEW IF EXISTS totalMark CASCADE;
DROP VIEW IF EXISTS a1Group CASCADE;

CREATE VIEW weightedMarks AS 
SELECT assignment_id, group_id, grade.rubric_id, grade*weight as weightedGrade, out_of*weight as weightedOutOf
FROM RubricItem JOIN grade ON rubricitem.rubric_id = grade.rubric_id;

CREATE VIEW totalMark AS
SELECT assignment_id, group_id, 100*SUM(weightedGrade)/SUM(weightedOutOf) as percentage
FROM weightedMarks
Group by group_id, assignment_id;

--find all A1 groups 
CREATE view a1Group as
select group_id
from assignment, assignmentgroup
where assignment.description = 'A1' and assignment.assignment_id = assignmentgroup.assignment_id;

DROP VIEW IF EXISTS classAvg CASCADE;
CREATE view classAvg as 
select avg(percentage) as classAvg
from a1Group,totalMark,membership
where a1Group.group_id = membership.group_id and a1Group.group_id = totalMark.group_id;

DROP VIEW IF EXISTS groupMark CASCADE;
CREATE view groupMark as 
select a1Group.group_id, percentage as mark
from a1Group left join totalMark
on a1Group.group_id = totalMark.group_id;

-- Final answer.
INSERT INTO q10 (select groupMark.*, mark - classAvg as compared_to_average, 
	case
		when mark - classAvg = '0' then 'at'
		when mark - classAvg > '0' then 'above'
		when mark - classAvg < '0' then 'below'
	end as status
from groupMark,classAvg);
	-- put a final query here so that its results will go into the table.
