group Instructor {

  attributes:
		public Room myOfficeLoc; // The instructor's room
		public int leaveCampusTime; // the instructor's time to leave the campus
		public int teachingTime; // time to teach
		public boolean waitingInClass; // whether the instructor is currently waiting in class
		public boolean teaching;
		public boolean seenProjector; // whether the instructor has seen the projector
		public symbol suitColor;
		public boolean heardCP;
		public boolean haveAnnouncement;


  relations:
		// empty

  initial_beliefs:
		(current.waitingInClass = false);
		(current.teaching = false);
		(current.suitColor = unknown);
		(current.heardCP = false);
		(current.haveAnnouncement = false);

  initial_facts:
		// empty

  activities:
		communicate answerQuestion(Student student) { // Answer question that is asked by a student
			max_duration: 30; 
			with: student; // communication established with student agent
			about:
				send(current.teaching); // sends the instructor's current value of teaching
			when: end;
		}

		broadcast announceToStudents() {
					random: false;
					max_duration: 500;
					to: Classroom_ITC315;
					about: 
						send(ITC315Camera.suitColor);
					when: end;
		}
		 
		composite_activity teach() { //instructor's activity to teach
			activities:
				primitive_activity teach()	{ // he/she "teaches" for 50 minutes
					random: false;
					max_duration: 3000; // 50 minutes
				}
			
			workframes:
//				workframe wf_teachInst3 { // the instructor can be teaching
//					repeat: false;
//					variables:
//						forone(Instructor) instructor;					
//					detectables:
//						detectable noticeQuestionStdnt01 { // if a student asks a question
//							when(whenever)
//							//TODO: couldn't one generalize this for all the students
//							detect((Student_01.haveQuestion = true), dc:100) // check the belief of a student.
//							then impasse;
//						}
//					when(
//						(instructor = Instructor_03) and
//						(current.teaching = false) and
//						(UniversityClock.time = current.teachingTime)
//						)
//					do {
//						conclude((current.teaching = true), bc:100, fc:100);
//						teach();
//					}
//				}
				
				workframe wf_teachInst2 { // the instructor can be teaching
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
					when(
						(instructor = Instructor_02) and
						(current.teaching = false) and
						(UniversityClock.time = current.teachingTime)
						)
					do {
						conclude((current.teaching = true), bc:100, fc:100);
						announceToStudents();
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