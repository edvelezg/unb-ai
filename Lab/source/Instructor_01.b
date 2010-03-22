agent Instructor_01 memberof Instructor {
	location: OffCampus;
	
	initial_beliefs:
		(current.myOfficeLoc = Instructor1_Office);
		(current.leaveCampusTime = 8);
		(current.teachingTime = 2);
	
	activities:
		communicate callCampusPolice() {
			max_duration: 30; 
			with: CampusPolice;
			about:
				send(current.seenProjector = false);
			when: end;
		}
		 
	workframes:
		workframe wf_callCampusPolice 
		{
			repeat: false;
			when(
				(Classroom_ITC315.projector = false)
				)
			do 
			{
				conclude((current.seenProjector = false), bc:100, fc:100);
				callCampusPolice();
			}
		}				
}
