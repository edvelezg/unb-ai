agent Student_7 memberof Student {

	location: SUB;

  attributes:

  relations:

  initial_beliefs:
		(current.name = "andrew");

  initial_facts:
		(current.name = "andrew");

  activities:
		

  workframes:
  	workframe wf_goToGym { 
			repeat: false;				
			when((UniversityClock.time = 10))
			do {
				goToGym();
			}
		}
		
		workframe wf_goToSUB {
			repeat: false;
			when((UniversityClock.time = 240))
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
		
		workframe wf_goToLib {
			repeat: false;
			when((UniversityClock.time = 360))
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