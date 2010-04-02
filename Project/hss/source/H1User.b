agent H1User memberof HouseUser{

	location: House2;
		
	initial_beliefs:
		(current.needsToToggleSystem = true);
		(current.activity1Time = 1);
		(current.pinRemembered = false);
		(current.believedPin = 1111); 

		
  	initial_facts:
		(current.needsToToggleSystem = true);
		(current.activity1Time = 1);

}
