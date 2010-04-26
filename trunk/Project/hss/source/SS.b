agent SS {

	location: House1;
	attributes:
	
	initial_beliefs:
		(H2.location = House2);			
		(H1.location = House1);		
		(H1Keypad.readyToActivate = unknown);		
		
	activities:

			move moveToLocation(Building loc) {
					 location: loc;
			}

			primitive_activity inactiveSS() {
				max_duration: 5000;
			}
			
			primitive_activity activateSS() {
				max_duration: 100;
			}
			
			composite_activity activeSS() { //instructor's activity to teach

				activities:
					primitive_activity active()	{ // he/she "teaches" for 50 minutes
						random: false;
						max_duration: 3000; // 50 minutes
					}
				
				workframes:
					workframe wf_activeSS { // the instructor can be teaching
						repeat: false;
						detectables:
						when(
								)
						do {
							active();
						}
					}		
			}	
	
	workframes:
	
//			workframe wf_movetoHouse 
//			{
//				repeat: false;
//				variables:
//					forone(Building) bd;
//					forone(House) hs;
//				when(
//					not(current.location = hs.location) and
//					knownval(hs.location = bd) and
//					(FredClock.time = 1)
//					)
//				do 
//				{
//					moveToLocation(bd);
//				}
//			}

			workframe wf_inactiveSS
			{
				repeat: false;
				variables:
					forone(Keypad) kp;
				detectables:
					detectable keypadAcceptsPin{
						when(whenever)
							detect((H1Keypad.readyToActivate = true), dc:100)
							then complete;
					}
				when(
//						(current.location = hs.location) and
//						knownval(hs.location = bd) and
//						(FredClock.time = 1)
						)
				do 
				{
					
					inactiveSS();
				}
			}
			
		workframe wf_activateSystem {
			repeat: false;
			priority: 1;
			variables:
				forone(Keypad) kp;						
			when(
					(kp.readyToActivate = true)
					)
			do {
				activeSS();
			}
		}			

}
