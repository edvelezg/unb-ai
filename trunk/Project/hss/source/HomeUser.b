group HomeUser {

	attributes:
		public boolean needsToToggleSystem;
		public boolean pinCommunicated;
		public boolean sessionIsOn;
		public boolean hasCard;
		public boolean pinRemembered;
		public int correctPin;
		public int believedPin;
		public boolean waitAtmAsksPin;
		public boolean waitAtmAsksAmount;
		public boolean waitAtmRepliesVerification;
		public double amountRequested;
		public boolean amountCommunicated;
		public boolean repeatPin;

	initial_beliefs:
		(current.pinCommunicated = false);
		(current.sessionIsOn = false);
		(current.hasCard = true);
		(current.needsToToggleSystem = false);
		(current.pinRemembered = false);
		(current.waitAtmAsksPin = false);
		(current.waitAtmAsksAmount = false);
		(current.waitAtmRepliesVerification = false);
		(current.amountCommunicated = false);
		(current.repeatPin = false);

	activities:
	
	move moveToLocation(Building loc) {
			 location: loc;
	}

	primitive_activity waitAtmReply() {
		max_duration: 300;
	}

	composite_activity useKeypad() {

		activities:
			primitive_activity insertBankCard() {
				max_duration: 300;
			}
		
			primitive_activity rememberPin() { // user remembers pin
				max_duration: 10;
			}	

			primitive_activity 	processCommunicatePin() { // user communicates pin to the keypad
				max_duration: 3;
			}

			communicate communicatePIN() { // pin will be communicated to keypad
				max_duration: 300;
				with: H1Keypad;
				about:
					send(current.pinCommunicated = true),
				//	send(current.believedPin = current.believedPin);
					send(current.believedPin = unknown);

				when: end;
			}

			primitive_activity waitKeypadReply() { // waits for the keypad's reply
				max_duration: 300;
			}

			primitive_activity activateSecuritySystem() {
				max_duration: 18; 
			}

			primitive_activity doNotActivateSecuritySystem() {
				 max_duration: 18;
			}
		
			primitive_activity finishTransaction() {
				 max_duration: 14;
			}

		workframes:
			
			//THe user moves towards his new home to activate his system
			workframe wf_moveToHome {
				repeat: false;
			
				variables:
					//TODO: why doesn't this work !!!! :( forone(Keypad) kp;
					forone(Building) bd;
				
				when(
					knownval(current.needsToToggleSystem = true) // and
					// not(current.location = H1Keypad.location) and
					// knownval(H1Keypad.location = bd )
					)
				do {
					moveToLocation(House1);
				}
			}  
				
			
			workframe wf_insertBankCard {
				
				repeat: false; 
				
				variables:
					forone(Keypad) kp2;
					forone(Building) bd2;
				
				when(
					knownval(current.needsToToggleSystem = true) and
					knownval(current.location = kp2.location) and
					knownval(current.pinRemembered = false)
					) 
								
				
				do {
					insertBankCard();
					conclude((current.waitAtmAsksPin = true), bc:100, fc:100);
				}
			}

			workframe wf_waitKeypadAsksPin {
			
				repeat: false; 

				variables:
					forone(Keypad) kp4;
									
				detectables:
					detectable atmAsksPin{
						when(whenever)
							detect((kp4.pinAsked = true), dc:100)
							then complete;
					}
				
				when(knownval(current.waitAtmAsksPin = true) and
					knownval(current.pinCommunicated = false)) 
				do {
					waitAtmReply();
					conclude((current.waitAtmAsksPin = false), bc:100, fc:100);
				}
			}
			
			workframe wf_communicatePIN {
			
				repeat: false;
				when(
						knownval(current.pinCommunicated = false) and
						knownval(current.pinRemembered = true) and
						knownval(current.waitAtmAsksPin = false)
						)					
				do {
					communicatePIN();
					conclude((current.pinCommunicated = true), bc:100, fc:0);
				}
			}
	} 

	workframes:
	
			workframe wf_useKeypad{
				repeat: false;
				when(
					knownval(current.needsToToggleSystem = true)
					)
				do {
					useKeypad();
				}
			}

}
