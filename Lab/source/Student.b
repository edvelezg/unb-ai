group Student {
	
  attributes:
		public int class1Time;
		public int class2Time;
		public int class3Time;
		public symbol morningActivity; // {eat, study, exercise}
		public symbol afternoonActivity; // {eat, study, exercise}
		public symbol afterClassActivity; // {eat, study, exercise, leave}
		public boolean inClass;
		public boolean classesStarted;
		public boolean finishedClasses;
		public boolean leaveCampus;
		public boolean haveQuestion;
		public BaseAreaDef culpritLocation;
		public symbol culpritSuit;
		
		
  relations:
		// empty
		
				
	initial_beliefs:
		(current.class1Time = 2);
		(current.class2Time = 5);
		(current.class3Time = 7);
		(current.inClass = false);
		(current.classesStarted = false);
		(current.finishedClasses = false);		
		(current.leaveCampus = false);
		(current.haveQuestion = false);
		// (current.culpritSuit = unknown);

  initial_facts:
		// empty

				
  activities:
		
		primitive_activity eat() {
			random: false;
			max_duration: 1800; // 30 minutes
		}
		
		primitive_activity study() {
			random: false;
			max_duration: 1800; // 30 minutes
		}
		
		primitive_activity exercise() {
			random: false;
			max_duration: 1800; // 30 minutes
		}
		
		primitive_activity wait() {
			random: true;
			min_duration: 1200; // 20 minutes
			max_duration: 1800; // 30 minutes
		}
		
		primitive_activity seesThief() {
			random: false;
			max_duration: 500; // 30 minutes
		}
		
		move goToHeadHall() {
			random: false;
			location: HeadHall;
		}

		move goToClass() {
			random: false;
			location: Classroom_ITC315;
		}
		
		move goToSUB() {
			random: false;
			location: SUB;
		}
		
		move goToGym() {
			random: false;
			location: LBGym;
		}

		move goToLibrary() {
			random: false;
			location: EngLibrary;
		}
						
		move leaveCampus() {
			random: false;
			location: OffCampus;
		}
		
		communicate sendQuestionStatus() {
			max_duration: 20;
			with: Instructor_01;
			about:
				send(current.haveQuestion);
			when: end;
		}

		communicate answerQuestion(Instructor instructor) { // Answer question that is asked by a instructor
			max_duration: 30; 
			with: instructor; // communication established with instructor agent
			about:
				send(current.culpritLocation); // sends the instructor's current value of teaching
			when: end;
		}
		
  workframes:
		
		workframe wf_seesThief { // This workframe is activated when the student knows the description and is in the same location as the thief
			repeat: false;
			when(
				(current.location = Thief.location) and
				(ITC315Camera.suitColor = red)
				)
			do {
				seesThief(); // between 20-40 minutes
				conclude((current.culpritLocation = Thief.location), bc:100, fc:100);
			}
		}

		workframe wf_goToCampus {
			repeat: false;
			when((UniversityClock.time = 1))
			do {
				wait(); // between 20-40 minutes
				goToHeadHall();	// takes 15 minutes
			}
		}
		
		workframe wf_goToClass1 {
			repeat: false;
			when(
				(UniversityClock.time = current.class1Time - 1) and
				(UniversityClock.tenMinUnits = 5))
			do {
				goToClass();
				conclude((current.inClass = true), bc:100, fc:100);
				conclude((current.classesStarted = true), bc:100, fc:100);
			}
		}

		workframe wf_goToClass2 {
			repeat: false;
			when(
				(UniversityClock.time = current.class2Time - 1) and
				(UniversityClock.tenMinUnits = 5))
			do {
				goToClass();
				conclude((current.inClass = true), bc:100, fc:100);
			}
		}
		
		workframe wf_goToClass3 {
			repeat: false;
			when(
				(UniversityClock.time = current.class3Time - 1) and
				(UniversityClock.tenMinUnits = 5))
			do {
				goToClass();
				conclude((current.inClass = true), bc:100, fc:100);
			}
		}
		
		workframe wf_askQuestionInClass1 {
			repeat: false;
			when( // 30 minutes into first class
				(UniversityClock.time = current.class1Time) and
				(UniversityClock.tenMinUnits = 3))
			do {
				conclude((current.haveQuestion = true), bc:100, fc:100);
				sendQuestionStatus();
				conclude((current.haveQuestion = false), bc:100, fc:100);
				sendQuestionStatus();
			}
		}
	
		workframe wf_goToSUBMorning {
			repeat: false;
			when(
				(UniversityClock.time <= 5) and
				(current.morningActivity = eat) and
				(current.inClass = false) and
				(current.classesStarted = true))
			do {
				goToSUB();
				eat();
			}
		}

		workframe wf_goToSUBAfternoon {
			repeat: false;
			when(
				(UniversityClock.time > 5) and
				(current.afternoonActivity = eat) and
				(current.inClass = false))
			do {
				goToSUB();
				eat();
			}
		}
		
		workframe wf_goToSUBAfterClass {
			repeat: false;
			when(
				(UniversityClock.time > 5) and
				(current.afterClassActivity = eat) and
				(current.finishedClasses = true))
			do {
				goToSUB();
				eat();
				conclude((current.leaveCampus = true), bc:100, fc:100);
			}
		}

		workframe wf_goToLibraryMorning {
			repeat: false;
			when(
				(UniversityClock.time <= 5) and
				(current.morningActivity = study) and
				(current.inClass = false) and
				(current.classesStarted = true))
			do {
				goToLibrary();
				study();
			}
		}

		workframe wf_goToLibraryAfternoon {
			repeat: false;
			when(
				(UniversityClock.time > 5) and
				(current.afternoonActivity = study) and
				(current.inClass = false))
			do {
				goToLibrary();
				study();
			}
		}
		
		workframe wf_goToLibraryAfterClass {
			repeat: false;
			when(
				(UniversityClock.time > 5) and
				(current.afterClassActivity = study) and
				(current.finishedClasses = true))
			do {
				goToLibrary();
				study();
				conclude((current.leaveCampus = true), bc:100, fc:100);
			}
		}

		workframe wf_goToGymMorning {
			repeat: false;
			when(
				(UniversityClock.time <= 5) and
				(current.morningActivity = exercise) and
				(current.inClass = false) and
				(current.classesStarted = true))
			do {
				goToGym();
				exercise();
			}
		}

		workframe wf_goToGymAfternoon {
			repeat: false;
			priority: 2;
			when( 
				(UniversityClock.time > 5) and
				(current.afternoonActivity = exercise) and
				(current.inClass = false))
			do {
				goToGym();
				exercise();
			}
		}
		
		workframe wf_goToGymAfterClass {
			repeat: false;
			priority: 2;
			detectables:
				detectable senseThief {
						when(whenever)
						detect((Thief.location = current.location), dc:100)
						then abort;
				}
				// detectable answerCall { // if the instructor calls 
				// 	when(whenever)
				// 	detect((Instructor_01.seenProjector = false), dc:100)
				// 	then abort;
				// }		
			when(
				(UniversityClock.time > 5) and
				(current.afterClassActivity = exercise) and
				(current.finishedClasses = true))
			do {
				goToGym();
				exercise();
				conclude((current.leaveCampus = true), bc:100, fc:100);
			}
		}
		
		workframe wf_leaveCampusImmediately {
			repeat: false;
			when(
				(current.finishedClasses = true) and
				(current.afterClassActivity = leave))
			do {
				leaveCampus();
			}
		}
		
		workframe wf_leaveCampusAfterActivity {
			repeat: false;
			when(
				(current.leaveCampus = true))
			do {
				leaveCampus();
			}
		}
		
		workframe wf_answerQuestion { // or he can be answering a question
			repeat: false;
			variables:
				forone(Instructor) instructor; // referring to one agent of the student group
			when(
				(current.inClass = true) and
				(instructor.haveQuestion = true))
			do {
				answerQuestion(instructor);
			}
		}
		
  thoughtframes:
		
		thoughtframe tf_resetInClass1 {
			repeat: false;
			when((UniversityClock.time = current.class1Time + 1))
			do {
				conclude((current.inClass = false), bc:100, fc:100);
			}
		}
		
		thoughtframe tf_resetInClass2 {
			repeat: false;
			when((UniversityClock.time = current.class2Time + 1))
			do {
				conclude((current.inClass = false), bc:100, fc:100);
			}
		}
		
		thoughtframe tf_resetInClass3 {
			repeat: false;
			when((UniversityClock.time = current.class3Time + 1))
			do {
				conclude((current.inClass = false), bc:100, fc:100);
				conclude((current.finishedClasses = true), bc:100, fc:100);
			}
		}

}
