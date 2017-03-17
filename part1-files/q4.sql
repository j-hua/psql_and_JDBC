-- Grader report

SET SEARCH_PATH TO markus;
DROP TABLE IF EXISTS q4;

-- You must not change this table definition.
CREATE TABLE q4 (
	assignment_id integer,
	username varchar(25), 
	num_marked integer, 
	num_not_marked integer,
	min_mark real,
	max_mark real
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS intermediate_step CASCADE;
DROP VIEW IF EXISTS weightedMarks CASCADE;
DROP VIEW IF EXISTS totalMark CASCADE;
DROP VIEW IF EXISTS numGradedNotGraded CASCADE;
DROP VIEW IF EXISTS gradedMaxMin CASCADE;
-- Define views for your intermediate steps here.

CREATE VIEW weightedMarks AS SELECT assignment_id, group_id, grade.rubric_id, grade*weight as weightedGrade, out_of*weight as weightedOutOf
FROM RubricItem JOIN grade ON rubricitem.rubric_id = grade.rubric_id;

CREATE VIEW totalMark AS
SELECT assignment_id, group_id, 100*SUM(weightedGrade)/SUM(weightedOutOf) as percentage
FROM weightedMarks
Group by group_id, assignment_id;

--create view resultpercentage as
--select assignment_id, totalMark.group_id, totalMark.percentage, result.released
--from totalMark,result
--where totalMark.group_id = result.group_id
--order by assignment_id;

drop view if exists graderResult CASCADE;
create view graderResult as 
select grader.group_id, username, mark
from grader left join result 
on grader.group_id = result.group_id;

DROP VIEW IF EXISTS resultpercentage1 CASCADE;
create view resultpercentage1 as
select totalMark.assignment_id, totalMark.group_id, totalMark.percentage
from graderResult, totalMark
where mark is not null and graderResult.group_id = totalMark.group_id;

DROP VIEW IF EXISTS resultpercentage2 CASCADE;
create view resultpercentage2 as
select graderResult.group_id, assignment_id, percentage
from graderResult left join resultpercentage1
on graderResult.group_id = resultpercentage1.group_id;

DROP VIEW IF EXISTS resultpercentage CASCADE;
create view resultpercentage as
select  assignmentgroup.assignment_id,resultpercentage2.group_id, percentage
from resultpercentage2,assignmentgroup
where resultpercentage2.group_id = assignmentgroup.group_id;
--DROP VIEW IF EXISTS resultpercentage CASCADE;
--create view resultpercentage as
--select totalMark.assignment_id, totalMark.group_id, totalMark.percentage
--from assignmentgroup left join totalMark
--on result.group_id = totalMark.group_id; 

create view numGradedNotGraded as
select assignment_id, username, count(percentage) as num_marked, count(resultpercentage.group_id) - count(resultpercentage.percentage) as num_not_marked  
from grader,resultpercentage
where grader.group_id = resultpercentage.group_id
group by assignment_id, username;

create view gradedMaxMin as
select assignment_id, username, max(percentage) max_mark, min(percentage) as min_mark
from grader, resultpercentage
where grader.group_id = resultpercentage.group_id
group by assignment_id, username;

-- Final answer.
INSERT INTO q4 
(select numGradedNotGraded.assignment_id, numGradedNotGraded.username, num_marked, num_not_marked, min_mark, max_mark 
from numGradedNotGraded, gradedMaxMin
where numGradedNotGraded.assignment_id = gradedMaxMin.assignment_id and numGradedNotGraded.username = gradedMaxMin.username);
	-- put a final query here so that its results will go into the table.
