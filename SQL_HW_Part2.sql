-- PART 2 -----------------------------------------------------------

-- Using your gwsis database, develop a stored procedure that will drop an individual student's enrollment
-- from a class. Be sure to refer to the existing stored procedures, enroll_student and 
-- terminate_all_class_enrollment in the gwsis database for reference. The procedure should be called 
-- terminate_student_enrollment and should accept the course code, section, student ID, and effective date of
-- the withdrawal as parameters.

USE gwsis;

START TRANSACTION;

CREATE PROCEDURE terminate_student_enrollment(
-- This procedure accepts four parameters
	CourseCode_in varchar(45),
	Section_in varchar(45),
	StudentID_in varchar(45),
	WithdrawalDate_in date
)
BEGIN

SELECT * FROM student s
INNER JOIN classparticipant cp
ON s.ID_Student = cp.ID_Student
INNER JOIN class c
ON cp.ID_Class = c.ID_Class;

-- IF A STUDENT_ID IS GIVEN:
DELETE FROM student
WHERE student.ID_Student = StudentID_in
	AND class.ID_Course = CourseCode_in
    AND class.Section = Section_in;
    
INSERT INTO ClassParticipant(EndDate)
VALUES (WithdrawalDate_in)
WHERE student.ID_Student = StudentID_in;

END;

ROLLBACK;

COMMIT;