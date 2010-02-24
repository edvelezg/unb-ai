group Instructor {

  attributes:
		public boolean teach; // whether the Instructor is teaching or not
		string name;

  relations:

  initial_beliefs:
		(UniversityClock.time = 40); // initially the instructor believes that
		(current.teach = false);		// it doesn't have to teach and the time is 1.

  initial_facts:

  activities:
		primitive_activity teach()	{ // the teach activity is defined as for 
			random: false;							// max_duration determines the amount of time the
			max_duration: 3000;					// amount of time the activity will take
		}															// random: false specifies that this action does
																	// not happen randomly		

	workframes:
	workframe wf_teach {						// the instructor starts to teach when it's
	when((current.teach = true))	// believes "teach" changes to true.
		do 
		{
			teach();
		}
	}
	
	thoughtframes:
	thoughtframe tf_beginTeaching {
		repeat: false; 
		when((current.teach = false) and (UniversityClock.time = 120)) 
				do 
				{
					conclude((current.teach = true), bc:100); 
				}
		}	

}
