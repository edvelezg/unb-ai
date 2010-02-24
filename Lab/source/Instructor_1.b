agent Instructor_1 memberof Instructor {
	location: HeadHall;

  attributes:

  relations:

  initial_beliefs:
		(current.name="ulieru");
		
  initial_facts:
		(current.name="ulieru");
			
  activities:
			move goToOffice() {	/* goes to office */
			random: false;			
			location: ulieruOffice; 
		}
		
			move goToClass() {		/* goes to class */
			random: false;			
			location: Classroom_ITC315; 
		}
				
		
		move goHome() { /* goes home */
			random: false;
			location: Fredericton;
		}
		
  workframes:
		workframe wf_goToOffice {
			repeat: false;					
			when((UniversityClock.time = 12))
			do {
				goToOffice();
			}
		}
		
		workframe wf_goToClass { 
			repeat: false;					
			when((UniversityClock.time = 45))
			do {
				goToClass();
			}
		}
		
		workframe wf_goBackToOffice { 
			repeat:false;
			when((UniversityClock.time = 120))
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
		
/*  thoughtframes:
		thoughtframe tf_beginTeaching {
			repeat: false;						
			when((current.teach = false) and 
					(UniversityClock.time = 60))	
				do { conclude((current.teach = true), bc:100); } 
		} */
		 
}
