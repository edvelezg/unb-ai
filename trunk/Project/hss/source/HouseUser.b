group HouseUser {

  attributes:
		public boolean needsToToggleSystem;
		public boolean hasResponse;
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
		(current.hasResponse = false);

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
				max_duration: 10;
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
							forone(Building) bd;
							forone(Keypad) kp;
						when(
							knownval(current.needsToToggleSystem = true) and
							not(current.location = kp.location) and
							(kp.location = bd)
							)
						do {
							moveToLocation(bd);
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
							conclude((current.believedPin = H1Keypad.correctPin), bc:100, fc:100);
//							conclude((current.believedPin = 9999), bc:25, fc:25);
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
							conclude((current.pinCommunicated = true), bc:100, fc:100);
							conclude((current.hasResponse = false), bc:100, fc:100);
							conclude((H1Keypad.repeatPin = false), bc:100, fc:100);
							communicatePIN(kp3);
						}
					}			
					
					workframe wf_waitKeypadResponse {

						repeat: true; 

						variables:
							// forone(Keypad) kp;

						detectables:

						detectable keypadAsksPin{
							when(whenever)
								detect((H1Keypad.repeatPin = true), dc:100)
								then complete;
						}
							
						when(
							knownval(current.pinCommunicated = true) and
							knownval(current.hasResponse = false) 
							) 
						do {
							waitOnKeypad();
							conclude((current.hasResponse = true), bc:100, fc:100);
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
