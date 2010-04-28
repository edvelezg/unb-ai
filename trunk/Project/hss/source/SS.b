agent SS {

	location: House1;
	attributes:
		public symbol state; 	
	
	initial_beliefs:
		(H2.location              = House2);			
		(H1.location              = House1);		
		(H1Keypad.readyToActivate = unknown);		
		(current.state            = inactive);
		
	activities:

			move moveToLocation(Building loc) {
					 location: loc;
			}

			primitive_activity inactiveSS() {
				max_duration: 28800;
			}
			
			composite_activity activeSS() { //instructor's activity to teach
				
				activities:
					primitive_activity active()	{ // he/she "teaches" for 50 minutes
						random: false;
						max_duration: 28800; // 50 minutes
					}
				workframes:
						workframe wf_active { // or he can be answering a question
							repeat: false;
							variables:
								forone(Sensor) snr;
							detectables:
								detectable keypadAcceptsPin{
									when(whenever)
										detect((<Sensor>.hasDetectedM = true), dc:100)
										then impasse;
								}							
							when(
								)
							do {
								active();
							}
						}
						
						workframe wf_active { // or he can be answering a question
							repeat: false;
							variables:
								forone(Sensor) snr;			
							when(
									(snr.hasDetectedM = true)
									)
							do {
								active();
							}
						}												
			}
			
							
	workframes:
	
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
					detectable dayHasEnded{
						when(whenever)
							detect((FredClock.time = 12), dc:100)
							then abort;
					}					
				when(
					knownval(current.state = inactive)  and
					knownval(FredClock.time >= 0 )
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
						detectable dayHasEnded{
							when(whenever)
								detect((FredClock.time = 12), dc:100)
								then abort;
						}					
				when(
					knownval(current.state = active) and
					knownval(FredClock.time < 12)
					)
				do {
					activeSS();
					conclude((current.state = inactive), bc:100, fc:100);
					conclude((H1Keypad.readyToActivate = false), bc:100, fc:100);					
				}
			}		
			
		// workframe wf_activateSystem {
		// 	repeat: false;
		// 	priority: 1;
		// 	variables:
		// 		forone(Keypad) kp;						
		// 	when(
		// 			(kp.readyToActivate = true)
		// 			)
		// 	do {
		// 		activeSS();
		// 	}
		// }			

}
