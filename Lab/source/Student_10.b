agent Student_10 memberof Student {

location: SUB;

  attributes:

  relations:

  initial_beliefs:
		(current.name = "stuart");
		
  initial_facts:
		(current.name = "stuart");

  activities:
		

  workframes:
		workframe wf_goToClass { 
			repeat: false;					
			when((UniversityClock.time = 55))
			do {
				goToClass1();
			}
		}
		
		workframe wf_goToLib {
			repeat: false;
			when((UniversityClock.time = 117))
			do {
				goToLibrary();
			}
		}
		
		workframe wf_goToGym {
			repeat: false;
			when((UniversityClock.time = 240))
			do {
				goToGym();
			}
		}
		
		workframe wf_goToSUB {
			repeat: false;
			when((UniversityClock.time = 300))
			do {
				goToSUB();
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
