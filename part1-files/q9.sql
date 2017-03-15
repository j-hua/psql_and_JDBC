-- Inseparable

SET SEARCH_PATH TO markus;
DROP TABLE IF EXISTS q9;

-- You must not change this table definition.
CREATE TABLE q9 (
	student1 varchar(25),
	student2 varchar(25)
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS intermediate_step CASCADE;

-- Define views for your intermediate steps here.

CREATE VIEW groupAssignments AS SELECT assignment_id, COUNT(*) as total
FROM assignment
Where group_max>1
GROUP BY assignment_id;

CREATE VIEW groupsOnAssignment AS SELECT AssignmentGroup.assignment_id, AssignmentGroup.group_id, total
FROM groupAssignments JOIN AssignmentGroup ON groupAssignments.assignment_id=AssignmentGroup.assignment_id;

CREATE VIEW studentsOnAssignment AS SELECT groupsOnAssignment.assignment_id, groupsOnAssignment.group_id, total, membership.username as student1
FROM groupsOnAssignment JOIN membership ON groupsOnAssignment.group_id = membership.group_id;

CREATE VIEW pairsOnAssignment AS SELECT studentsOnAssignment.assignment_id, total, student1, membership.username as student2
FROM studentsOnAssignment JOIN membership ON studentsOnAssignment.group_id = membership.group_id
WHERE student1>student2;

CREATE VIEW countOfPairedAssignments AS SELECT student1, student2, count(assignment_id) as count, MAX(total) as total
FROM pairsOnAssignment
Group by student1, student2;



INSERT INTO q9 SELECT student1, student2 from countOfPairedAssignments
Where max = count;

	-- put a final query here so that its results will go into the table.
