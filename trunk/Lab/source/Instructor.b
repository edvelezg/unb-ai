group Instructor {

  attributes:
		public Room myOfficeLoc; // The instructor's room
		public int leaveCampusTime; // the instructor's time to leave the campus
		public int teachingTime; // time to teach
		public boolean waitingInClass;
		public boolean teaching;
		public boolean seenProjector;

  relations:
		// empty


  initial_beliefs:
		(current.waitingInClass = false);
		(current.teaching = false);


  initial_facts:
		// empty
		

  activities:

		composite_activity teach() { //instructor's activity to teach
			activities:
				primitive_activity teach()	{ // it "teaches" for 50 minutes
					random: false;
					max_duration: 3000; // 50 minutes
				}
				
				communicate answerQuestion(Student student) { //TODO: What does this code do?
					max_duration: 30; 
					with: student;
					about:
						send(current.teaching); // teaching is an attribute... that is true or false
					when: end;
				} 
								
				communicate callCampusPolice(Student student) {
					max_duration: 30; 
					with: student;
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
							then impasse;
						}
					when(
						(current.teaching = false) and
						(UniversityClock.time = current.teachingTime))
					do {
						conclude((current.teaching = true), bc:100, fc:100);
						teach();
					}
				}
				//TODO: How does it know  to jump to this workframe.
				workframe wf_answerQuestion {
					repeat: false;
					variables:
						forone(Student) studentToAnswer; // (Student) studentToAnswer...
					when(
						(current.teaching = true) and
						(studentToAnswer.haveQuestion = true))
					do {
						answerQuestion(studentToAnswer);
					}
				}
				
				workframe wf_callCampusPolice {
					repeat: false;
					variables:
						forone(Student) studentToAnswer; // (Student) studentToAnswer...
					when(
						(current.teaching = true) and
						(Classroom_ITC315.projector = false))
					do {
						callCampusPolice(studentToAnswer);
					}
				}
		}
		
		primitive_activity wait() {
			random: true;
			min_duration: 600; // 10 minutes
			max_duration: 1200; // 20 minutes
		}
		
		primitive_activity waitAfterClass() {
			random: true;
			min_duration: 300; // 5 minutes
			max_duration: 600; // 10 minutes
		}
		
		move goToHeadHall() {
			random: false;
			location: HeadHall;
		}
		
		move goToOffice(Room officeLoc) {
			random: false;
			location: officeLoc;
		}
		
		move goToClass() {
			random: false;
			location: Classroom_ITC315;
		}
		
		move leaveCampus() {
			random: false;
			location: OffCampus;
		}


	workframes:
	
		workframe wf_goToCampus {
			repeat: false;
			when((UniversityClock.time = 1))
			do {
				wait();
				goToHeadHall();	// takes 15 minutes
			}
		}
		
		workframe wf_goToOffice {
			repeat: true;
			variables:
				forone(Room) officeLoc;
			when(
				(officeLoc = current.myOfficeLoc) and
				(current.location != current.myOfficeLoc) and
				(UniversityClock.time < current.leaveCampusTime) and
				(current.waitingInClass = false))
			do {
				goToOffice(officeLoc);
			}
		}
		
		workframe wf_goToClass {
			repeat: false;
			when(
				(UniversityClock.time = current.teachingTime - 1) and
				(UniversityClock.tenMinUnits = 5))
			do {
				goToClass();
				conclude((current.waitingInClass = true), bc:100, fc:100);
			}
		}
		
		workframe wf_teachClass {
			repeat: false;
			variables:
				forone(Room) officeLoc;
			when(
				(officeLoc = current.myOfficeLoc) and
				(UniversityClock.time = current.teachingTime))
			do {
				teach();
				waitAfterClass();
				goToOffice(officeLoc);
				conclude((current.waitingInClass = false), bc:100, fc:100);
			}
		}
		
		workframe wf_leaveCampus {
			repeat: false;
			when((UniversityClock.time = current.leaveCampusTime))
			do {
				leaveCampus();
			}
		}
}
