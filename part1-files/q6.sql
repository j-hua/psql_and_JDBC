-- Steady work

SET SEARCH_PATH TO markus;
DROP TABLE IF EXISTS q6;

-- You must not change this table definition.
CREATE TABLE q6 (
	group_id integer,
	first_file varchar(25),
	first_time timestamp,
	first_submitter varchar(25),
	last_file varchar(25),
	last_time timestamp, 
	last_submitter varchar(25),
	elapsed_time interval
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS intermediate_step CASCADE;
drop view if exists a1groups CASCADE;
-- Define views for your intermediate steps here.

create view a1groups as
select group_id
from assignment, assignmentgroup
where assignment.assignment_id = assignmentgroup.assignment_id and assignment.description = 'A1';

create view MaxAndMin as
select a1groups.group_id, max(submission_date) as last_time, min(submission_date) as first_time, max(submission_date) - min(submission_date) as elapsed_time  
from a1groups left join submissions
on a1groups.group_id = submissions.group_id
group by a1groups.group_id;

create view Max as 
select MaxAndMin.group_id, submissions.file_name as last_file, submissions.username as last_submitter
from MaxAndMin left join submissions
on MaxAndMin.group_id = submissions.group_id and MaxAndMin.last_time = submissions.submission_date;

create view Min as 
select MaxAndMin.group_id, submissions.file_name as first_file, submissions.username as first_submitter
from MaxAndMin left join submissions
on MaxAndMin.group_id = submissions.group_id and MaxAndMin.first_time = submissions.submission_date;

-- Final answer.
INSERT INTO q6 (select MaxAndMin.group_id, first_file,first_time,first_submitter,last_file, last_time, last_submitter, elapsed_time
from MaxAndMin,Max,Min
where MaxAndMin.group_id = Max.group_id and MaxAndMin.group_id = Min.group_id and MaxAndMin.group_id = Min.group_id);
	-- put a final query here so that its results will go into the table.
