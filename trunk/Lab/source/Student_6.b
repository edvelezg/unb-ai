agent Student_6 memberof Student {

	location: SUB;

  attributes:

  relations:

  initial_beliefs:
		(current.name = "ed");
		
  initial_facts:
		(current.name = "ed");

  activities:
		

  workframes:
  	workframe wf_goToClass {
			repeat: false;				
			when((UniversityClock.time = 200))
			do {
				goToClass2();
			}
		}
		
		workframe wf_goToGym {
			repeat: false;
			when((UniversityClock.time = 265))
			do {
				goToGym();
			}
		}
		
		workframe wf_goToLib {
			repeat: false;
			when((UniversityClock.time = 420))
			do {
				goToLibrary();
			}
		}
		
		workframe wf_goToHome {
			repeat: false;
			when((UniversityClock.time = 540))
			do {
				goHome();
			}
		}
		

  thoughtframes:

}
