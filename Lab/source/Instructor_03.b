agent Instructor_03 memberof Instructor {
	location: OffCampus;
	
	initial_beliefs:
		(current.myOfficeLoc = Instructor3_Office);
		(current.leaveCampusTime = 9);
		(current.teachingTime = 7);

	workframes:
		workframe wf_callCampusPoliceBack
		{
			repeat: false;
			variables:
				forone(Student) student;
			when(
				known(student.culpritLocation)
				)
			do 
			{
				conclude((current.culpritLocation = student.culpritLocation), bc:100, fc:100);
				informCampusPolice();
			}
		}		
}
