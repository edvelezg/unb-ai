agent Student_5 memberof Student {

	location: SUB;

  attributes:

  relations:

  initial_beliefs:
		(current.name = "alexis");
		
  initial_facts:
		(current.name = "alexis");

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
			when((UniversityClock.time = 480))
			do {
				goHome();
			}
		}
		

  thoughtframes:

}
