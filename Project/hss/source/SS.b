agent SS {

	location: House1;
	attributes:
		public symbol state; 	
	
	initial_beliefs:
		(H2.location = House2);			
		(H1.location = House1);		
		(H1Keypad.readyToActivate = unknown);		
		(current.state = inactive);
		
	activities:

			move moveToLocation(Building loc) {
					 location: loc;
			}

			primitive_activity inactiveSS() {
				max_duration: 5000;
			}
			
			primitive_activity activeSS() {
				max_duration: 5000;
			}
						
			
//			composite_activity activeSS() { //instructor's activity to teach
//				activities:
//				workframes:
//			}	
	
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
					knownval(current.state = inactive) and
					knownval(FredClock.time < 8)
					)
				do 
				{
					
					inactiveSS();
					conclude((current.state = active), bc:100, fc:100);
					conclude((H1Keypad.readyToActivate = false), bc:100, fc:100);
				}
			}

			workframe wf_activeSS {
				repeat: false;
				detectables:
						detectable keypadAcceptsPin{
							when(whenever)
								detect((H1Keypad.readyToActivate = true), dc:100)
								then complete;
						}

				when(
					knownval(current.state = active) and
					knownval(FredClock.time < 8)
					)
				do {
					activeSS();
					conclude((current.state = inactive), bc:100, fc:100);
					conclude((H1Keypad.readyToActivate = false), bc:100, fc:100);					
				}
			}		
			
//		workframe wf_activateSystem {
//			repeat: false;
//			priority: 1;
//			variables:
//				forone(Keypad) kp;						
//			when(
//					(kp.readyToActivate = true)
//					)
//			do {
//				activeSS();
//			}
//		}			

}
