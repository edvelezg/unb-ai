agent Instructor_03 memberof Instructor {
	location: OffCampus;
	
	initial_beliefs:
		(current.myOfficeLoc = Instructor3_Office);
		(current.leaveCampusTime = 9);
		(current.teachingTime = 7);
		
	activities:
		communicate informCampusPolice() {
			max_duration: 500; 
			with: CampusPolice;
			about:
				send(Student_07.culpritLocation);
			when: end;
		}

	workframes:
		workframe wf_callCampusPolice 
		{
			repeat: false;
			variables:
				forone(Student) student;
			when(
				known(student.culpritLocation)
				)
			do 
			{
				// conclude((current.seenProjector = false), bc:100, fc:100);
				informCampusPolice();
			}
		}		
}
