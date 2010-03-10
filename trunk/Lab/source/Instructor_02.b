agent Instructor_02 memberof Instructor {
	location: OffCampus;
	
	initial_beliefs:
		(current.myOfficeLoc = Instructor2_Office);
		(current.leaveCampusTime = 8);
		(current.teachingTime = 5);

}