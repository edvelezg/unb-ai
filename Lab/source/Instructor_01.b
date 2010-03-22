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
		
		composite_activity teach() { //instructor's activity to teach
			activities:
				primitive_activity teach()	{ // he/she "teaches" for 50 minutes
					random: false;
					max_duration: 3000; // 50 minutes
				}
			
			workframes:
				workframe wf_teach { // the instructor can be teaching
					repeat: false;
					variables:
						forone(Instructor) instructor;					
					detectables:
						detectable noticeQuestionStdnt01 { // if a student asks a question
							when(whenever)
							//TODO: couldn't one generalize this for all the students
							detect((Student_01.haveQuestion = true), dc:100) // check the belief of a student.
							then impasse;
						}
						detectable noticeProjectorMissing { //TODO: This detectable should go only Instructor 1 I think... can I override the frame for this
							when(whenever)
							detect((Classroom_ITC315.projector = false), dc:100) // check if the projector is missing.
							//TODO: couldn't one generalize this for all the students
							then continue;
						}

					when(
						(current.teaching = false) and
						(UniversityClock.time = current.teachingTime) and
						(instructor = Instructor_01) // only applies to the first instructor
						)
					do {
						conclude((current.teaching = true), bc:100, fc:100);
						teach();
					}
				}
								
				workframe wf_answerQuestion { // or he can be answering a question
					repeat: false;
					variables:
						forone(Student) studentToAnswer; // referring to one agent of the student group
					when(
						(current.teaching = true) and
						(studentToAnswer.haveQuestion = true))
					do {
						answerQuestion(studentToAnswer);
					}
				}
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
						(Classroom_ITC315.projector = false)
						)
					do 
					{
						conclude((current.seenProjector = false), bc:100, fc:100);
						callCampusPolice();
					}
				}				
}
