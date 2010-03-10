group Instructor {

  attributes:
		public Room myOfficeLoc;
		public int leaveCampusTime;
		public int teachingTime;
		public boolean waitingInClass;
		public boolean teaching;


  relations:
		// empty


  initial_beliefs:
		(current.waitingInClass = false);
		(current.teaching = false);


  initial_facts:
		// empty
		

  activities:

		composite_activity teach() {
			activities:
				primitive_activity teach()	{
					random: false;
					max_duration: 3000; // 50 minutes
				}
				
				communicate answerQuestion(Student student) {
					max_duration: 30;
					with: student;
					about:
						send(current.teaching);
					when: end;
				}
			
			workframes:
				workframe wf_teach {
					repeat: false;
					detectables:
						detectable noticeQuestionStdnt01 {
							when(whenever)
							detect((Student_01.haveQuestion = true), dc:100)
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
				
				workframe wf_answerQuestion {
					repeat: false;
					variables:
						forone(Student) studentToAnswer;
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