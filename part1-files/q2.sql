-- Getting soft

SET SEARCH_PATH TO markus;
DROP TABLE IF EXISTS q2;

-- You must not change this table definition.
CREATE TABLE q2 (
	ta_name varchar(100),
	average_mark_all_assignments real,
	mark_change_first_last real
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS intermediate_step CASCADE;
drop view if exists maintable cascade;
drop view if exists  num_ass cascade;
drop view if exists taGradedAll cascade;
drop view if exists taLessThan10 cascade;
-- Define views for your intermediate steps here.
create view maintable as
select r.group_id, mark, username, assignment_id
from result r,grader g,assignmentgroup a
where r.group_id = g.group_id and r.group_id = a.group_id and g.group_id = a.group_id;

create view num_ass as 
select count(assignment_id) as num_ass
from assignment;

create view taGradedAll as 
select username,count(distinct assignment_id)
from grader,assignmentgroup
where grader.group_id = assignmentgroup.group_id
group by username
having  count(distinct assignment_id) = ALL ( select * from num_ass);

create view taLessThan10 as
select taGradedAll.username,assignment_id, count(grader.group_id) as num_graded
from grader, taGradedAll, assignmentgroup
where grader.username = taGradedAll.username and grader.group_id = assignmentgroup.group_id
group by taGradedAll.username,assignment_id
having count(grader.group_id) < 3;

create view taMoreThan10 as 
select *
from taGradedAll
where taGradedAll.username NOT IN (select username from taLessThan10);

-- Final answer.
INSERT INTO q2 
	-- put a final query here so that its results will go into the table.
