group HouseUser {

  attributes:
		public boolean needsToToggleSystem;
		public int activity1Time;
		public boolean pinRemembered;		
		public boolean waitKeypadAsksPin;		
		public boolean isAtKeypad;

			
  relations:
		// empty
		
  activities:

			move moveToLocation(Building loc) {
					 location: loc;
			}

			composite_activity useKeypad() {

				activities:
					primitive_activity goToKeypad() {
						max_duration: 300;
					}
				
					primitive_activity rememberPin() { // user remembers pin
						max_duration: 10;
					}	
		
					primitive_activity 	processCommunicatePin() { // user communicates pin to the keypad
						max_duration: 3;
					}

				workframes:
				
					//The user moves towards his new home to activate his system
					workframe wf_moveToHome {
						
						repeat: false;
						variables:
						// none yet
						when(
							knownval(current.needsToToggleSystem = true) and
							not(current.location = H1Keypad.location)
							)
						do {
							moveToLocation(House1);
						}
					}  
					
					workframe wf_goToKeypad {
						
						repeat: false; 
						
						variables:
							forone(Keypad) kp2;
						
						when(
							knownval(current.needsToToggleSystem = true) and
							knownval(current.location = kp2.location) and
							knownval(current.pinRemembered = false)
							) 
						
						do {
							goToKeypad();
							conclude((current.isAtKeypad = true), bc:100, fc:100);
							conclude((current.waitKeypadAsksPin = true), bc:100, fc:100);
						}
					}					
	}
				
  workframes:

		workframe wf_useKeypad{
			repeat: false;
			when(
				knownval(current.needsToToggleSystem = true) and
				knownval(current.activity1Time = FredClock.time)
				)
			do {
				useKeypad();
			}
		}

}
