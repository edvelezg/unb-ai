agent Student_8 memberof Student {

	location: SUB;

  attributes:

  relations:

  initial_beliefs:
		(current.name = "mark");
		
  initial_facts:
		(current.name = "mark");

  activities:
		

  workframes:

		workframe wf_goToClass {  /* when it goes to first class */
			repeat: false;
			when((UniversityClock.time = 285))
			do {
				goToClass3();
			}
		}

		workframe wf_goToLib { /* when it goes to library */
			repeat: false;			
			when((UniversityClock.time = 10)) 
			do {
				goToLibrary();
			}
		}
		
		workframe wf_goToSUB { /* when it goes to SUB */
			repeat: false;
			when((UniversityClock.time = 240))
			do {
				goToSUB();
			}
		}
		
		
		workframe wf_goToSUB1 {
			repeat: false;
			when((UniversityClock.time = 360))
			do {
				goToSUB();
			}
		}
		
		workframe wf_goToGym {
			repeat: false;
			when((UniversityClock.time = 480))
			do {
				goToGym();
			}
		}
		
		workframe wf_goHome {
			repeat: false;
			when((UniversityClock.time = 540))
			do {
				goHome();
			}
		}

}
