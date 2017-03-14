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
-- Define views for your intermediate steps here.
select *
from assignmentgroup, assignment
where assignmentgroup.assignment_id = assignment.assignment_id and group_max > '1';
-- Final answer.
INSERT INTO q8
	-- put a final query here so that its results will go into the table.