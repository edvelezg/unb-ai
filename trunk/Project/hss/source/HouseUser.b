group HouseUser {

  attributes:
		public boolean needsToToggleSystem;
		public int activity1Time;
		public boolean pinRemembered;		
		public boolean waitKeypadAsksPin;		
		public boolean isAtKeypad;
		public boolean pinCommunicated;		
		public int believedPin;
		
			
	initial_beliefs:
		(current.needsToToggleSystem = true);
		(current.activity1Time = 1);
		(current.pinRemembered = false);
		(current.pinCommunicated = false);		

  	initial_facts:
		(current.needsToToggleSystem = true);
		(current.activity1Time = 1);
		
  activities:

			primitive_activity rememberPin() {
				max_duration: 100;
			}	

			move moveToLocation(Building loc) {
					 location: loc;
			}
			
			primitive_activity waitOnKeypad() {
				max_duration: 400;
			}

			primitive_activity 	processCommunicatePin() {
				max_duration: 100;
			}

			communicate communicatePIN(Keypad kp3) {
				max_duration: 1;
				with: kp3;
				about:
					send(current.pinCommunicated = true),
					send(current.believedPin = current.believedPin);
					// send(current.believedPin = unknown);
				when: end;
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

					workframe wf_waitKeypadAsksPin {

						repeat: true; 

						variables:
							// forone(Keypad) kp;

						detectables:

							detectable keypadAsksPin{
								when(whenever)
									detect((H1Keypad.pinAsked = true), dc:100)
									then complete;
							}
							
						when(
							knownval(current.waitKeypadAsksPin = true) and
							knownval(current.pinCommunicated = false)
							) 
						do {
							waitOnKeypad();
							conclude((current.waitKeypadAsksPin = false), bc:100, fc:100);

						}

					}		
													
					workframe wf_rememberPin {
						repeat: true;

						variables:
							// forone(Keypad) kp3;

						when(
							knownval(current.pinCommunicated = false) and
							knownval(current.location = H1Keypad.location) and
							knownval(current.pinRemembered = false) and
							knownval(H1Keypad.pinAsked = true)
							)


						do {
							rememberPin();
							conclude((current.believedPin = H1Keypad.pin), bc:100, fc:50);
							conclude((current.believedPin = 9999), bc:50, fc:50);
							conclude((current.pinRemembered = true), bc:100, fc:0);

						}

					}					

					workframe wf_communicatePIN {

						repeat: true;

						variables:

							forone(Keypad) kp3;

						when(
							knownval(current.pinCommunicated = false) and
							knownval(current.location = kp3.location) and
							knownval(current.pinRemembered = true) and
							knownval(current.waitKeypadAsksPin = false))

						do {
							processCommunicatePin();
							communicatePIN(kp3);
							conclude((current.pinCommunicated = true), bc:100, fc:100);
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
