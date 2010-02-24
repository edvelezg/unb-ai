agent Instructor_2 memberof Instructor {
location: HeadHall;

  attributes:

  relations:

  initial_beliefs:
		(current.name="kent");
		
  initial_facts:
		(current.name="kent");
			
  activities:
			move goToOffice() {	/* goes to office */
			random: false;			
			location: kentOffice; 
		}
		
	move goToClass() {		/* goes to class */
			random: false;			
			location: ITC317; 
		}
						
	move goHome() { /* goes home */
			random: false;
			location: Fredericton;
		}
		
  workframes:
		workframe wf_goToOffice {
			repeat: false;					
			when((UniversityClock.time = 10))
			do {
				goToOffice();
			}
		}
		
		workframe wf_goToClass { 
			repeat: false;					
			when((UniversityClock.time = 275)) 
			do {
				goToClass();
			}
		}
				
		workframe wf_gobackToOffice { 
			repeat:false;
			when((UniversityClock.time = 345))
			do {
				conclude((current.teach=false),bc:100);
				goToOffice();
			}
		}
		
		workframe wf_goHome {
			repeat: false;
			when((UniversityClock.time=480))
			do {
				goHome();
			}
		}
		
 /* thoughtframes:
		thoughtframe tf_beginTeaching {
			repeat: false;					
			when((current.teach = false) and 
					(UniversityClock.time = 285))	
				do { conclude((current.teach = true), bc:100); }
		} */
}
