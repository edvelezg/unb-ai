agent H1User memberof HouseUser{

	location: House2;
		
	initial_beliefs:
		(current.needsToToggleSystem = true);
		(current.activity1Time = 1);
		(current.pinRemembered = false);
		(H1Keypad.correctPin = 1111); 
		(H1Keypad.location = House1);		
		
		(current.callReceived = true);
		(current.SOpinCommunicated = false);
		(current.SOpin = "abc");
		
  	initial_facts:
		(current.needsToToggleSystem = true);
		(current.activity1Time = 1);
		(current.callReceived = true);
		(current.SOpinCommunicated = false);
		(current.SOpin = "abc");

}
