agent Instructor_01 memberof Instructor {
	location: OffCampus;
	
	initial_beliefs:
		(current.myOfficeLoc = Instructor1_Office);
		(current.leaveCampusTime = 8);
		(current.teachingTime = 2);
}
