agent Instructor_03 memberof Instructor {
	location: OffCampus;
	
	initial_beliefs:
		(current.myOfficeLoc = Instructor3_Office);
		(current.leaveCampusTime = 9);
		(current.teachingTime = 7);
}
