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
			location: House1;
		}

		move goToClass() {
			random: false;
			location: House2;
		}
		
		move goToSUB() {
			random: false;
			location: House3;
		}
		
		move goToGym() {
			random: false;
			location: PStation1;
		}

		move goToLibrary() {
			random: false;
			location: PStation2;
		}
						
		move leaveCampus() {
			random: false;
			location: SecurityOffice;
		}
		
  workframes:

		workframe wf_goToCampus {
			repeat: false;
			when((FredClock.time = 1))
			do {
				wait(); // between 20-40 minutes
				goToHeadHall();	// takes 15 minutes
			}
		}
}
