group Student {

	attributes:
		public string name;

	initial_beliefs:
		(UniversityClock.time = 1); 

	activities:
	
		move goToClass() { 		// the student can perform the following activities:
			random: false;			// it can go to class, or go to the sub.
			location: HeadHall; // This two events don't happen at random in the simulation
		}
		
		move goToClass1() {		/* goes to first class */
			random: false;			
			location: Classroom_ITC315; 
		}

		move goToClass2() {	 /* goes to second class */
			random: false;		
			location: HH201; 
		}
		
		move goToClass3() { /* goes to third class */
			random: false;		
			location: ITC317; 
		}
		
		move goToSUB() {      /* goes to sub */
			random: false;			
			location: SUB;			
		}
		
		move goToGym() {		/* goes to the gym */
			random: false;		
			location: LBGym; 
		}
		
		move goToLibrary() {		/* goes to the library */
			random: false;			
			location: EngLibrary; 
		}
	
		move goHome() { /* goes home */
			random: false;
			location: Fredericton;
		}

}