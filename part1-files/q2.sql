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

select * from taGradedAll;

create view taLessThan10 as
select taGradedAll.username,assignment_id, count(grader.group_id) as num_graded
from grader, taGradedAll, assignmentgroup
where grader.username = taGradedAll.username and grader.group_id = assignmentgroup.group_id
group by taGradedAll.username,assignment_id
having count(grader.group_id) < 2;

select * from taLessThan10;

create view taMoreThan10 as 
select *
from taGradedAll
where taGradedAll.username NOT IN (select username from taLessThan10);

DROP VIEW IF EXISTS weightedMarks CASCADE;
DROP VIEW IF EXISTS totalMark CASCADE;

CREATE VIEW weightedMarks AS SELECT assignment_id, group_id, grade.rubric_id, grade*weight as weightedGrade, out_of*weight as weightedOutOf
FROM RubricItem JOIN grade ON rubricitem.rubric_id = grade.rubric_id;

CREATE VIEW totalMark AS
SELECT assignment_id, group_id, 100*SUM(weightedGrade)/SUM(weightedOutOf) as percentage
FROM weightedMarks
Group by group_id, assignment_id;

drop view if exists studentMarks cascade;
create view studentMarks as 
select taMoreThan10.username, assignment_id, totalMark.group_id,percentage,
	membership.username as student
from taMoreThan10,grader,totalMark,membership
where taMoreThan10.username = grader.username and grader.group_id = totalMark.group_id 
	and totalMark.group_id = membership.group_id;

drop view if exists taAssigWithoutDuedate cascade;
create view taAssigWithoutDuedate as 
select username, assignment_id, avg(percentage)
from studentMarks
group by assignment_id, username;

drop view if exists taAssig cascade;
create view taAssig as 
select taAssigWithoutDuedate.*, due_date
from taAssigWithoutDuedate join assignment
on taAssigWithoutDuedate.assignment_id = assignment.assignment_id;


drop view if exists taNotConsis cascade;
-- ta that does not consistently grade increasingly
create view taNotConsis as 
select t1.username, t1.avg
from taAssig t1, taAssig t2
where t1.username = t2.username and t1.assignment_id < t2.assignment_id and t1.avg >= t2.avg;

drop view if exists finalList cascade;
create view finalList as 
select username, avg(avg) as average_mark_all_assignments, max(avg) - min(avg) as mark_change_first_last
from taAssig
where taAssig.username not in (select username from taNotConsis)
group by username;

-- Final answer.
INSERT INTO q2 (select markususer.firstname || ' ' || markususer.surname as ta_name,average_mark_all_assignments,mark_change_first_last
from finalList,markususer
where finalList.username = markususer.username);
	-- put a final query here so that its results will go into the table.
