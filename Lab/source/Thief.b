agent Thief {
	location: OffCampus;
  attributes:
		public int class1Time;
		public boolean inClass;
		public boolean classesStarted;		
		
  relations:
		// empty
		
	initial_beliefs:
		(current.class1Time = 2);

  initial_facts:
		// empty

				
  activities:
		
		primitive_activity steal() {
			random: false;
			max_duration: 600; // 10 minutes
		}

		primitive_activity wait() {
			random: true;
			min_duration: 1200; // 20 minutes
			max_duration: 1800; // 30 minutes
		}
		
		move goToHeadHall() {
			random: false;
			location: HeadHall;
		}
				
		move goToClass() { // Thief goes to class
			random: false;
			location: Classroom_ITC315;
		}
		
		move goToGym() { // Thief goes to the gym 
			random: false;
			location: LBGym;
		}
				
  workframes:

		workframe wf_goToCampus {
			repeat: false;
			when((UniversityClock.time = 1))
			do {
				goToHeadHall();	// takes 15 minutes
			}
		}
		
		workframe wf_stealAndHide{
			repeat: false;
			when(
				(UniversityClock.time = 1) and
				(UniversityClock.tenMinUnits = current.class1Time))
			do {
				goToClass(); /* thief goes to first class */
				steal();
				/* thief steals the projector */
				conclude((Classroom_ITC315.projector = false), bc:100, fc:100);
				goToGym(); /* thief goes to the gym to hide */
			}
		}
}
