import java.sql.*;

// Remember that part of your mark is for doing as much in SQL (not Java) 
// as you can. At most you can justify using an array, or the more flexible
// ArrayList. Don't go crazy with it, though. You need it rarely if at all.
import java.util.ArrayList;

public class Assignment2 {

    // A connection to the database
    Connection connection;

    Assignment2() throws SQLException {
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    /**
     * Connects to the database and sets the search path.
     * 
     * Establishes a connection to be used for this session, assigning it to the
     * instance variable 'connection'. In addition, sets the search path to
     * markus.
     * 
     * @param URL
     *            the url for the database
     * @param username
     *            the username to be used to connect to the database
     * @param password
     *            the password to be used to connect to the database
     * @return true if connecting is successful, false otherwise
     */
    public boolean connectDB(String URL, String username, String password) {
        // Replace this return statement with an implementation of this method!
	boolean retVal = false;
			
	try{
		connection = DriverManager.getConnection(URL,username,password);
		retVal = true;	
	}catch(SQLException se){
		System.err.println("SQL Exception." +
                        "<Message>: " + se.getMessage());		
	}
	
        return retVal;
    }

    /**
     * Closes the database connection.
     * 
     * @return true if the closing was successful, false otherwise
     */
    public boolean disconnectDB() {
        // Replace this return statement with an implementation of this method!
        boolean retVal = false;
    			
    	try{
    		if(connection!= null){
    			connection.close();
    			retVal = true;		
    		}
    	}catch(SQLException se){
    		System.err.println("SQL Exception." +
                            "<Message>: " + se.getMessage());		
    	}
    	
            return retVal;
    }

    /**
     * Assigns a grader for a group for an assignment.
     * 
     * Returns false if the groupID does not exist in the AssignmentGroup table,
     * if some grader has already been assigned to the group, or if grader is
     * not either a TA or instructor.
     * 
     * @param groupID
     *            id of the group
     * @param grader
     *            username of the grader
     * @return true if the operation was successful, false otherwise
     */
    public boolean assignGrader(int groupID, String grader) {
        // Replace this return statement with an implementation of this method!
     
		boolean retVal = false;
	

		String queryString;
		PreparedStatement pStatement;
		ResultSet rs;
		try{

			queryString = "select * from markus.assignmentgroup where group_id = \'" + groupID + "\'"+ ';';
			System.out.println("Query: " + queryString);
			pStatement = connection.prepareStatement(queryString);
			rs = pStatement.executeQuery();

			if(!rs.next()){
				//no data
				//Returns false if the groupID does not exist in the AssignmentGroup table
				retVal = false;
				System.out.println("group id does not exist in assignmentgroup table");
			}else{

				int g = rs.getInt("group_id");
				queryString = "select * from markus.grader where group_id = \'" + groupID + "\'"+ ';';
				System.out.println("Query: " + queryString);
				pStatement = connection.prepareStatement(queryString);
				rs = pStatement.executeQuery();

				if(rs.next()){
					//Returns false if someone has already been assigned to the group
					retVal = false;
					System.out.println("someone has already been assigned to the group");
				}else{

					queryString = " insert into markus.grader values(" + groupID + ",\'" + grader + "\');";
					System.out.println("Query: " + queryString);
					pStatement = connection.prepareStatement(queryString);
					pStatement.executeUpdate();
					retVal = true;
				}

			}
		}catch(Exception se){
				System.err.println("SQL Exception." +
							"<Message>: " + se.getMessage());
		}

		return retVal;
    }

    /**
     * Adds a member to a group for an assignment.
     * 
     * Records the fact that a new member is part of a group for an assignment.
     * Does nothing (but returns true) if the member is already declared to be
     * in the group.
     * 
     * Does nothing and returns false if any of these conditions hold: - the
     * group is already at capacity, - newMember is not a valid username or is
     * not a student, - there is no assignment with this assignment ID, or - the
     * group ID has not been declared for the assignment.
     * 
     * @param assignmentID
     *            id of the assignment
     * @param groupID
     *            id of the group to receive a new member
     * @param newMember
     *            username of the new member to be added to the group
     * @return true if the operation was successful, false otherwise
     */
    public boolean recordMember(int assignmentID, int groupID, String newMember) {
   		boolean retVal = false;
		String queryString;
		PreparedStatement pStatement;
		ResultSet rs;

		try{
			queryString = "select * " +
					"from (select assignment.assignment_id, group_id " +
						"from markus.assignment full join markus.assignmentgroup " +
						"on assignment.assignment_id = assignmentgroup.assignment_id) as assigAndGroup" +
					" where assignment_id = " + assignmentID  + " and group_id = " + groupID + ";";
			System.out.println("Query: " + queryString);
			pStatement = connection.prepareStatement(queryString);
			rs = pStatement.executeQuery();

			//check
			//there is no assignment with this assignmentID
			//the groupID has not been declared for the assignment
			if(rs.next()){
				//check
				//newMember is not a valid user
				queryString = "select * " +
						"from (select markususer.*, group_id from markus.markususer " +
							"left join markus.membership " +
							"on markus.markususer.username = markus.membership.username) as usermembership " +
						"where username = '" +
						newMember +
						"' and type = 'student';";
				System.out.println("Query: " + queryString);
				pStatement = connection.prepareStatement(queryString);
				rs = pStatement.executeQuery();
				
				if(rs.next()){
					do{
						int g = rs.getInt("group_id");
						if(g == groupID){
							System.out.println("student is already assigned to the group");
							return true;
						}
					}while(rs.next());
					//the group is at capacity
					queryString = "select count " +
							"from (select count(*), group_id " +
								"from markus.membership group by group_id) as groupcount " +
							"where group_id = " +
							groupID +
							" ;";
					System.out.println("Query: " + queryString);
					pStatement = connection.prepareStatement(queryString);
					rs = pStatement.executeQuery();
					rs.next();
					int numMember = rs.getInt("count");

					queryString = "select group_max from markus.assignment " +
							"where assignment_id = " +
							assignmentID +
							";";
					System.out.println("Query: " + queryString);
					pStatement = connection.prepareStatement(queryString);
					rs = pStatement.executeQuery();
					rs.next();
					int max = rs.getInt("group_max");

					if(max > numMember){
						queryString = "insert into markus.membership values ('" +
								newMember +
								"'," +
								groupID +
								");";
						System.out.println("Query: " + queryString);
						pStatement = connection.prepareStatement(queryString);
						pStatement.executeUpdate();
						retVal = true;
					}else{
						System.out.println("Group at capacity");
					}
				}else{
					System.out.println("Invalid user");				
				}
			}else{
				System.out.println("there is no assignment with this assignmentID or the groupID has not been declared for the assignment");	
			}

		}catch (Exception se){
			System.err.println("SQL Exception." +
					"<Message>: " + se.getMessage());
		}



		//if none of the above holds, record the member

		// Replace this return statement with an implementation of this method!
        return retVal;
    }

    /**
     * Creates student groups for an assignment.
     * 
     * Finds all students who are defined in the Users table and puts each of
     * them into a group for the assignment. Suppose there are n. Each group
     * will be of the maximum size allowed for the assignment (call that k),
     * except for possibly one group of smaller size if n is not divisible by k.
     * Note that k may be as low as 1.
     * 
     * The choice of which students to put together is based on their grades on
     * another assignment, as recorded in table Results. Starting from the
     * highest grade on that other assignment, the top k students go into one
     * group, then the next k students go into the next, and so on. The last n %
     * k students form a smaller group.
     * 
     * In the extreme case that there are no students, does nothing and returns
     * true.
     * 
     * Students with no grade recorded for the other assignment come at the
     * bottom of the list, after students who received zero. When there is a tie
     * for grade (or non-grade) on the other assignment, takes students in order
     * by username, using alphabetical order from A to Z.
     * 
     * When a group is created, its group ID is generated automatically because
     * the group_id attribute of table AssignmentGroup is of type SERIAL. The
     * value of attribute repo is repoPrefix + "/group_" + group_id
     * 
     * Does nothing and returns false if there is no assignment with ID
     * assignmentToGroup or no assignment with ID otherAssignment, or if any
     * group has already been defined for this assignment.
     * 
     * @param assignmentToGroup
     *            the assignment ID of the assignment for which groups are to be
     *            created
     * @param otherAssignment
     *            the assignment ID of the other assignment on which the
     *            grouping is to be based
     * @param repoPrefix
     *            the prefix of the URL for the group's repository
     * @return true if successful and false otherwise
     */
    public boolean createGroups(int assignmentToGroup, int otherAssignment,
            String repoPrefix) {
    	try{

		}catch (Exception se){
				System.err.println("SQL Exception." +
						"<Message>: " + se.getMessage());
		}
        // Replace this return statement with an implementation of this method!
        return false;
    }

    public static void main(String[] args) {
        // You can put testing code in here. It will not affect our autotester.
	try{
		Assignment2 a2 = new Assignment2();
		if(a2.connectDB("jdbc:postgresql://localhost:5432/csc343h-huayufei","huayufei","")){
			System.out.println("connected");
		}

		if (a2.assignGrader(5000,"t1")) 
			System.out.println("TRUE");
		else 
			System.out.println("FALSE");

		if(a2.recordMember(4000,2001,"s8"))
			System.out.println("TURE");
		else
			System.out.println("FALSE");

	}catch(SQLException se){
		System.err.println("SQL Exception." +
                        "<Message>: " + se.getMessage());		
	}	
	
        //System.out.println("Boo!");
    }
}
