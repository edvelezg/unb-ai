agent Instructor_01 memberof Instructor {
	location: OffCampus;
	
	initial_beliefs:
		(current.myOfficeLoc = Instructor1_Office);
		(current.leaveCampusTime = 8);
		(current.teachingTime = 2);
	
	activities:
		communicate callCampusPolice() { //TODO: What does this code do?
			max_duration: 30; 
			with: CampusPolice;
			about:
				send(current.teaching); // teaching is an attribute... that is true or false
			when: end;
		}
		 
	workframes:
				workframe wf_teach { // the instructor can be teaching
					repeat: false;
					detectables:
						detectable noticeQuestionStdnt01 { // if a student asks a question
							when(whenever)
							detect((Student_01.haveQuestion = true), dc:100) // check the belief of a student.
							//TODO: couldn't one generalize this for all the students
							then impasse;
						}
						detectable noticeProjectorMissing { //TODO: This detectable should go only Instructor 1 I think... can I override the frame for this
							when(whenever)
							detect((Classroom_ITC315.projector = false), dc:100) // check the belief of a student.
							//TODO: couldn't one generalize this for all the students
							then continue;
						}
					when(
						(current.teaching = false) and
						(UniversityClock.time = current.teachingTime))
					do {
						conclude((current.teaching = true), bc:100, fc:100);
						teach();
					}
				}
				
				workframe wf_callCampusPolice 
				{
					repeat: false;
					when(
						(current.teaching = true) and
						(Classroom_ITC315.projector = false)
						)
					do 
					{
						callCampusPolice();
					}
				}				
}
