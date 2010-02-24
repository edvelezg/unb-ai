agent Student_1 memberof Student {
	
	location: SUB;

  attributes:

  relations:

  initial_beliefs:
		(current.name = "john");
		
  initial_facts:
		(current.name = "john");

  activities:
		

  workframes:
		workframe wf_goToClass {  /* when it goes to first class */
			repeat: false;					
			when((UniversityClock.time = 55)) 
			do {
				goToClass1();
			}
		}
		
		workframe wf_goToLib { /* when it goes to the library */
			repeat: false;
			when((UniversityClock.time = 118))
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
			when((UniversityClock.time = 420))
			do {
				goHome();
			}
		}		

}
