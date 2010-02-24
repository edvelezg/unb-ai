agent Student_9 memberof Student {

	location: SUB;

  attributes:

  relations:

  initial_beliefs:
		(current.name = "joel");
		
  initial_facts:
		(current.name = "joel");

  activities:
		

  workframes:
		workframe wf_goToLib { 
			repeat: false;				
			when((UniversityClock.time = 10))
			do {
				goToLibrary();
			}
		}
		
		workframe wf_goToSUB {
			repeat: false;
			when((UniversityClock.time = 230))
			do {
				goToSUB();
			}
		}
		
		workframe wf_goToClass {
			repeat: false;
			when((UniversityClock.time = 285))
			do {
				goToClass3();
			}
		}
		
		workframe wf_goToGym {
			repeat: false;
			when((UniversityClock.time = 355))
			do {
				goToGym();
			}
		}
		
/*		workframe wf_goToLib {
			repeat: false;
			when((UniversityClock.time = 480))
			do {
				goToLibrary();
			}
		} */
		
		workframe wf_goHome {
			repeat: false;
			when((UniversityClock.time = 480))
			do {
				goHome();
			}
		}

  thoughtframes:

}
