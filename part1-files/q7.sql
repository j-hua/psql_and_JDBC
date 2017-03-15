-- High coverage

SET SEARCH_PATH TO markus;
DROP TABLE IF EXISTS q7;

-- You must not change this table definition.
CREATE TABLE q7 (
	ta varchar(100)
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS taToAssignment CASCADE;
DROP VIEW IF EXISTS taToStudents CASCADE;
DROP VIEW IF EXISTS allMatches CASCADE;
DROP VIEW IF EXISTS taStudentNotMatch CASCADE;
DROP VIEW IF EXISTS allTAallAssignments CASCADE;



CREATE VIEW taToAssignment AS SELECT DISTINCT username as ta, AssignmentGroup.assignment_id
FROM Grader JOIN AssignmentGroup ON Grader.group_id=AssignmentGroup.group_id;

CREATE VIEW allTAallAssignments AS SELECT Grader.username as ta, Assignment.assignment_id
FROM Grader, Assignment;

CREATE VIEW notGraded AS (SELECT * FROM allTAallAssignments) EXCEPT (SELECT * FROM taToAssignment);

CREATE VIEW taToStudents AS SELECT DISTINCT grader.username as ta, membership.username as student_id
FROM Grader,AssignmentGroup, Membership
Where grader.group_id=AssignmentGroup.group_id and AssignmentGroup.group_id = Membership.group_id;

CREATE VIEW allMatches AS SELECT DISTINCT grader.username as ta, MarkusUser.username as student_id
FROM Grader, MarkusUser
Where Markususer.username = 'student';

CREATE VIEW taStudentNotMatch AS (SELECT * FROM allMatches) EXCEPT (SELECT * FROM taToStudents);

CREATE VIEW final AS (SELECT username as ta FROM Grader) EXCEPT (SELECT ta FROM taStudentNotMatch);
CREATE VIEW final2 AS (SELECT * FROM final) EXCEPT (SELECT ta FROM notGraded);

INSERT INTO q7 SELECT * FROM final2;