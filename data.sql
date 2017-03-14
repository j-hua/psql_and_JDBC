-- If there is already any data in these tables, empty it out.

TRUNCATE TABLE Result CASCADE;
TRUNCATE TABLE Grade CASCADE;
TRUNCATE TABLE RubricItem CASCADE;
TRUNCATE TABLE Grader CASCADE;
TRUNCATE TABLE Submissions CASCADE;
TRUNCATE TABLE Membership CASCADE;
TRUNCATE TABLE AssignmentGroup CASCADE;
TRUNCATE TABLE Required CASCADE;
TRUNCATE TABLE Assignment CASCADE;
TRUNCATE TABLE MarkusUser CASCADE;


-- Now insert data from scratch.

INSERT INTO MarkusUser VALUES ('i1', 'iln1', 'ifn1', 'instructor');

INSERT INTO MarkusUser VALUES ('s1', 'sln1', 'sfn1', 'student');
INSERT INTO MarkusUser VALUES ('s2', 'sln2', 'sfn2', 'student');

INSERT INTO MarkusUser VALUES ('s3', 'sln3', 'sfn3', 'student');
INSERT INTO MarkusUser VALUES ('s4', 'sln4', 'sfn4', 'student');

INSERT INTO MarkusUser VALUES ('s5', 'sln5', 'sfn5', 'student');
INSERT INTO MarkusUser VALUES ('s6', 'sln6', 'sfn6', 'student');

INSERT INTO MarkusUser VALUES ('s7', 'sln7', 'sfn7', 'student');
INSERT INTO MarkusUser VALUES ('s8', 'sln8', 'sfn8', 'student');

INSERT INTO MarkusUser VALUES ('t1', 'tln1', 'tfn1', 'TA');
INSERT INTO MarkusUser VALUES ('t2', 'tln2', 'tfn2', 'TA');

INSERT INTO Assignment VALUES (1000, 'a1', '2017-02-08 20:00', 1, 2);
INSERT INTO Assignment VALUES (2000, 'a2', '2017-03-08 20:00', 1, 2);
INSERT INTO Assignment VALUES (3000, 'a3', '2017-04-08 20:00', 1, 1);

INSERT INTO Required VALUES (1000, 'A1.pdf');
INSERT INTO Required VALUES (2000, 'A2.pdf');
INSERT INTO Required VALUES (3000, 'A3.pdf');

INSERT INTO AssignmentGroup VALUES (2000, 1000, 'repo_url');
INSERT INTO AssignmentGroup VALUES (3000, 1000, 'repo_url3');
INSERT INTO AssignmentGroup VALUES (5000, 1000, 'repo_url5');
INSERT INTO AssignmentGroup VALUES (7000, 1000, 'repo_url7');
INSERT INTO AssignmentGroup VALUES (2001, 2000, 'repo_url');
INSERT INTO AssignmentGroup VALUES (3001, 2000, 'repo_url3');
INSERT INTO AssignmentGroup VALUES (5001, 2000, 'repo_url5');
INSERT INTO AssignmentGroup VALUES (7001, 2000, 'repo_url7');

INSERT INTO AssignmentGroup VALUES (8001, 3000, 'repo_url');
INSERT INTO AssignmentGroup VALUES (8002, 3000, 'repo_url');
INSERT INTO AssignmentGroup VALUES (8003, 3000, 'repo_url');
INSERT INTO AssignmentGroup VALUES (8004, 3000, 'repo_url');
INSERT INTO AssignmentGroup VALUES (8005, 3000, 'repo_url');
INSERT INTO AssignmentGroup VALUES (8006, 3000, 'repo_url');
INSERT INTO AssignmentGroup VALUES (8007, 3000, 'repo_url');
INSERT INTO AssignmentGroup VALUES (8008, 3000, 'repo_url');


INSERT INTO Membership VALUES ('s1', 2000);
INSERT INTO Membership VALUES ('s2', 2000);
INSERT INTO Membership VALUES ('s3', 3000);
INSERT INTO Membership VALUES ('s4', 3000);
INSERT INTO Membership VALUES ('s5', 5000);
INSERT INTO Membership VALUES ('s6', 5000);
INSERT INTO Membership VALUES ('s7', 7000);
INSERT INTO Membership VALUES ('s8', 7000);

INSERT INTO Membership VALUES ('s1', 2001);
INSERT INTO Membership VALUES ('s2', 2001);
INSERT INTO Membership VALUES ('s3', 3001);
INSERT INTO Membership VALUES ('s4', 3001);
INSERT INTO Membership VALUES ('s5', 5001);
INSERT INTO Membership VALUES ('s6', 5001);
INSERT INTO Membership VALUES ('s8', 5001);
INSERT INTO Membership VALUES ('s7', 7001);

INSERT INTO Membership VALUES ('s1', 8001);
INSERT INTO Membership VALUES ('s2', 8002);
INSERT INTO Membership VALUES ('s3', 8003);
INSERT INTO Membership VALUES ('s4', 8004);
INSERT INTO Membership VALUES ('s5', 8005);
INSERT INTO Membership VALUES ('s6', 8006);
INSERT INTO Membership VALUES ('s7', 8007);
INSERT INTO Membership VALUES ('s8', 8008);


INSERT INTO Submissions VALUES (2001, 'A1.pdf', 's1', 2000, '2017-02-08 19:59');
INSERT INTO Submissions VALUES (2003, 'A1.pdf', 's3', 3000, '2017-02-07 19:59');
INSERT INTO Submissions VALUES (2004, 'A1.pdf', 's4', 3000, '2017-02-07 20:59');
INSERT INTO Submissions VALUES (2005, 'A1.pdf', 's3', 3000, '2017-02-07 20:59');
INSERT INTO Submissions VALUES (2007, 'A1.pdf', 's7', 7000, '2017-02-08 19:59');

INSERT INTO Submissions VALUES (3001, 'A2.pdf', 's1', 2001, '2017-03-08 19:59');
INSERT INTO Submissions VALUES (3003, 'A2.pdf', 's3', 3001, '2017-03-07 19:59');
INSERT INTO Submissions VALUES (3005, 'A2.pdf', 's5', 5001, '2017-03-08 19:59');
INSERT INTO Submissions VALUES (3007, 'A2.pdf', 's7', 7001, '2017-03-08 19:59');

INSERT INTO Submissions VALUES (8001, 'A3.pdf', 's1', 2001, '2017-04-08 18:00');
INSERT INTO Submissions VALUES (8002, 'A3.pdf', 's2', 3001, '2017-04-07 19:59');
INSERT INTO Submissions VALUES (8003, 'A3.pdf', 's3', 5001, '2017-04-08 16:00');
INSERT INTO Submissions VALUES (8004, 'A3.pdf', 's4', 7001, '2017-04-07 19:59');
INSERT INTO Submissions VALUES (8005, 'A3.pdf', 's5', 2001, '2017-04-08 15:00');
INSERT INTO Submissions VALUES (8006, 'A3.pdf', 's6', 3001, '2017-04-07 19:59');
INSERT INTO Submissions VALUES (8007, 'A3.pdf', 's7', 5001, '2017-04-08 10:59');
INSERT INTO Submissions VALUES (8008, 'A3.pdf', 's8', 7001, '2017-04-07 19:59');

INSERT INTO Grader VALUES (2000, 't1');
INSERT INTO Grader VALUES (3000, 't1');
INSERT INTO Grader VALUES (5000, 't1');
INSERT INTO Grader VALUES (7000, 't2');
INSERT INTO Grader VALUES (2001, 't1');
INSERT INTO Grader VALUES (3001, 't1');
INSERT INTO Grader VALUES (5001, 't1');
INSERT INTO Grader VALUES (7001, 't2');

INSERT INTO Grader VALUES (8001, 't1');
INSERT INTO Grader VALUES (8002, 't1');
INSERT INTO Grader VALUES (8003, 't1');
INSERT INTO Grader VALUES (8004, 't1');
INSERT INTO Grader VALUES (8005, 't1');
INSERT INTO Grader VALUES (8006, 't1');
INSERT INTO Grader VALUES (8007, 't1');
INSERT INTO Grader VALUES (8008, 't1');

INSERT INTO RubricItem VALUES (4000, 1000, 'style', 4, 0.25);
INSERT INTO RubricItem VALUES (4001, 1000, 'tester', 12, 0.75);
INSERT INTO RubricItem VALUES (5010, 2000, 'style', 3, 0.3);
INSERT INTO RubricItem VALUES (5011, 2000, 'tester', 5, 0.5);

INSERT INTO RubricItem VALUES (6000, 3000, 'style', 4, 0.25);
INSERT INTO RubricItem VALUES (6001, 3000, 'tester', 12, 0.75);

INSERT INTO Grade VALUES (2000, 4000, 3);
INSERT INTO Grade VALUES (2000, 4001, 9);
INSERT INTO Grade VALUES (2001, 5010, 3);
INSERT INTO Grade VALUES (2001, 5011, 5);
INSERT INTO Grade VALUES (3000, 4000, 3);
INSERT INTO Grade VALUES (3000, 4001, 8);
INSERT INTO Grade VALUES (3001, 5010, 2);
INSERT INTO Grade VALUES (3001, 5011, 4);
INSERT INTO Grade VALUES (5000, 4000, 2);
INSERT INTO Grade VALUES (5000, 4001, 8);
INSERT INTO Grade VALUES (5001, 5010, 1);
INSERT INTO Grade VALUES (5001, 5011, 4);
INSERT INTO Grade VALUES (7000, 4000, 4);
INSERT INTO Grade VALUES (7000, 4001, 9);
INSERT INTO Grade VALUES (7001, 5010, 3);
INSERT INTO Grade VALUES (7001, 5011, 2);

INSERT INTO Grade VALUES (8001, 6000, 3);
INSERT INTO Grade VALUES (8001, 6001, 9);
INSERT INTO Grade VALUES (8002, 6000, 3);
INSERT INTO Grade VALUES (8002, 6001, 5);
INSERT INTO Grade VALUES (8003, 6000, 3);
INSERT INTO Grade VALUES (8003, 6001, 8);
INSERT INTO Grade VALUES (8004, 6000, 2);
INSERT INTO Grade VALUES (8004, 6001, 4);
INSERT INTO Grade VALUES (8005, 6000, 2);
INSERT INTO Grade VALUES (8005, 6001, 8);
INSERT INTO Grade VALUES (8006, 6000, 1);
INSERT INTO Grade VALUES (8006, 6001, 4);
INSERT INTO Grade VALUES (8007, 6000, 4);
INSERT INTO Grade VALUES (8007, 6001, 9);
INSERT INTO Grade VALUES (8008, 6000, 3);
INSERT INTO Grade VALUES (8008, 6001, 2);

INSERT INTO Result VALUES (2000, 12, true);
INSERT INTO Result VALUES (3000, 11, true);
INSERT INTO Result VALUES (5000, 9, true);
INSERT INTO Result VALUES (7000, 13, true);
INSERT INTO Result VALUES (2001, 8, true);
INSERT INTO Result VALUES (3001, 6, true);
INSERT INTO Result VALUES (5001, 5, true);
INSERT INTO Result VALUES (7001, 5, true);

INSERT INTO Result VALUES (8001, 12, true);
INSERT INTO Result VALUES (8002, 8, true);
INSERT INTO Result VALUES (8003, 11, true);
INSERT INTO Result VALUES (8004, 6, true);
INSERT INTO Result VALUES (8005, 10, true);
INSERT INTO Result VALUES (8006, 5, false);
INSERT INTO Result VALUES (8007, 13, true);
INSERT INTO Result VALUES (8008, 5, true);


