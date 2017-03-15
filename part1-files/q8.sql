-- Never solo by choice

SET SEARCH_PATH TO markus;
DROP TABLE IF EXISTS q8;

-- You must not change this table definition.
CREATE TABLE q8 (
	username varchar(25),
	group_average real,
	solo_average real
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS intermediate_step CASCADE;
drop view if exists soloassignment CASCADE;
drop view if exists groupAssig CASCADE;
drop view if exists studentNeverSolo CASCADE;
drop view if exists studentSubmitEvery CASCADE;
drop view if exists usernameGroupAvg CASCADE;
drop view if exists usernameSoloAvg CASCADE;
-- Define views for your intermediate steps here.

--find assignments that does allow group
CREATE view groupAssig as 
select assignment.assignment_id, assignmentgroup.group_id
from assignmentgroup, assignment
where assignmentgroup.assignment_id = assignment.assignment_id and group_max > '1';

CREATE view soloAssig as 
select assignment.assignment_id, assignmentgroup.group_id
from assignmentgroup, assignment
where assignmentgroup.assignment_id = assignment.assignment_id and group_max = '1';

--find students who worked solo in group assignments
CREATE view soloGroup as
select groupAssig.group_id, count(username)
from groupAssig,membership
where groupAssig.group_id = membership.group_id
group by groupAssig.group_id
having count(username) = 1; 

--find qualified students 
CREATE view studentNeverSolo as 
select distinct membership.username as student
from groupAssig, membership
where groupAssig.group_id = membership.group_id 
	and membership.username not in 
	(select membership.username from soloGroup, membership where soloGroup.group_id = membership.group_id);

--find students who submitted at least one file for every assignment
CREATE view studentSubmitEvery as
select username
from groupAssig join submissions
on groupAssig.group_id = submissions.group_id
group by submissions.username
having count(distinct assignment_id) = (select count(distinct assignment_id) from groupAssig);

DROP VIEW IF EXISTS weightedMarks CASCADE;
DROP VIEW IF EXISTS totalMark CASCADE;

CREATE VIEW weightedMarks AS SELECT assignment_id, group_id, grade.rubric_id, grade*weight as weightedGrade, out_of*weight as weightedOutOf
FROM RubricItem JOIN grade ON rubricitem.rubric_id = grade.rubric_id;

CREATE VIEW totalMark AS
SELECT assignment_id, group_id, 100*SUM(weightedGrade)/SUM(weightedOutOf) as percentage
FROM weightedMarks
Group by group_id, assignment_id;	

CREATE view usernameGroupAvg as 
select studentSubmitEvery.username, avg(percentage) as group_average
from totalMark, groupAssig, membership, studentSubmitEvery
where totalMark.group_id = groupAssig.group_id 
	and totalMark.group_id = membership.group_id
	and studentSubmitEvery.username = membership.username
group by studentSubmitEvery.username;

CREATE view usernameSoloAvg as 
select studentSubmitEvery.username, avg(percentage) as solo_average
from studentSubmitEvery,totalMark,soloAssig, membership
where totalMark.group_id = soloAssig.group_id
	and totalMark.group_id = membership.group_id
	and studentSubmitEvery.username = membership.username
group by studentSubmitEvery.username;

-- Final answer.
INSERT INTO q8 (select usernameSoloAvg.username, usernameGroupAvg.group_average,usernameSoloAvg.solo_average
from usernameSoloAvg join usernameGroupAvg on usernameGroupAvg.username = usernameSoloAvg.username);
	-- put a final query here so that its results will go into the table.