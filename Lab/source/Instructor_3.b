agent Instructor_3 memberof Instructor {

	location: HeadHall;

  attributes:

  relations:

  initial_beliefs:
		(current.name="aubanel");
		
  initial_facts:
		(current.name="aubanel");
			
  activities:
			move goToOffice() {		
			random: false;			
			location: aubanelOffice; 
		}
		
		move goToClass() {		/* moves professor to class */
			random: false;			
			location: HH201;
		}
						
		move goHome() {
			random: false;
			location: Fredericton;
		}
		
  workframes:
		workframe wf_goToOffice { 
			repeat: false;					
			when((UniversityClock.time = 13))
			do {
				goToOffice();
			}
		}
		
		workframe wf_goToClass { 
			repeat: false;					
			when((UniversityClock.time = 200))
			do {
				goToClass();
			}
		}
				
		workframe wf_gobackToOffice {
			repeat:false;
			when((UniversityClock.time = 270))
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
					(UniversityClock.time = 210))	
				do { conclude((current.teach = true), bc:100); }
		} */
}
