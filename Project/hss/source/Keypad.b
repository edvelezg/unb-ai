class Keypad {

	display: "Keypad";
  	cost: 0.0;
 	resource: true;

	attributes:
		public boolean hasStarted;
		public boolean pinIsWrong;	
		public boolean pinReceived;
		public boolean pinAsked;	
		public boolean hasComparedOnce;	
		// public boolean pinIsCorrect;	
		public boolean readyToActivate;
		public int enteredPin;		
		public int correctPin;
		public int errorCount;		

	initial_beliefs:
		(current.pinIsWrong != false);
		(current.hasStarted = false);
		(current.pinReceived = false);				
		(current.pinAsked = false);
		(current.hasComparedOnce = false);
		(current.errorCount = 0);		
		
	initial_facts:
		(current.pinReceived = false);
		(current.pinAsked = false);
		(current.pinIsWrong != false);		
		(current.correctPin = 1111);
		(current.hasStarted = false);	
		(current.hasComparedOnce = false);	
		(current.errorCount = 0);		

	activities:

		primitive_activity startKeypad() {
					max_duration: 50;
				}
				
		primitive_activity getPin() {
					max_duration: 100;
				}
				
		primitive_activity comparePins() {
					max_duration: 100;
				}

		primitive_activity matchPin_No() {
					max_duration: 100;
				}

		primitive_activity matchPin_Yes() {
					max_duration: 100;
				}

		primitive_activity returnCardandMoney() {
					max_duration: 100;
				}

		primitive_activity returnCardwithNoMoney() {
					max_duration: 100;
				}

		primitive_activity processAskPin() {
					max_duration: 100;
		}
		
//		communicate askPin(HouseUser hur) { // WHY DOESN'T THIS WORK :(
//					max_duration: 300;
//					with: hur;
//					about:
//						send(current.pinAsked = true);
//					when: end;
//		}

		communicate askPin() {
					max_duration: 1;
					with: H1User;
					about:
						send(current.pinAsked = true);
					when: start;
		}


	workframes:

		workframe wf_startKeypad {

					repeat: false;

					variables:
						forone(HouseUser) hur0; 

					when(
						knownval(hur0.isAtKeypad = true) and
						knownval(current.hasStarted = false)
						)

					do {
						startKeypad();
						conclude((current.hasStarted = true), bc:100, fc:100);
					}
		}	
		
		// workframe wf_askPin {
		// 
		// 			repeat: true;
		// 
		// 			variables:
		// 				forone(HouseUser) hur1;
		// 
		// 			when(
		// 				knownval(hur1.isAtKeypad = true) and					
		// 				knownval(current.hasStarted = true) and
		// 				knownval(current.pinAsked = false)
		// 				)
		// 
		// 
		// 			do {
		// 				processAskPin();
		// 				askPin(hur1);
		// 				conclude((current.pinAsked = true), bc:100, fc:100);
		// 			}
		// }	

		workframe wf_askPin {

					repeat: true;

					when(
						knownval(H1User.isAtKeypad = true) and					
						knownval(current.hasStarted = true) and
						knownval(current.pinAsked = false)
						)


					do {
						conclude((current.pinAsked = true), bc:100, fc:100);
						askPin();
					}
		}
		
		workframe wf_getPin {

					repeat: true;

					when(
						knownval(current.pinReceived = false) and
						knownval(H1User.pinCommunicated = true)
						)
						
					do {
						getPin();
						conclude((current.enteredPin = H1User.believedPin), bc:100, fc:100);
						conclude((current.pinReceived = true), bc:100, fc:100);
						
					}
		}

		workframe wf_comparePins_ok {

					repeat: false;

					when(
						known(current.enteredPin) and
						known(current.correctPin) and
						knownval(current.pinReceived = true) and
						knownval(current.enteredPin = current.correctPin))
					do {
						comparePins();
						conclude((current.pinIsWrong = false), bc:100, fc:100);
						conclude((current.readyToActivate = true), bc:100, fc:100);
					}
		}
		
		workframe wf_comparePins_bad {

					repeat: false;
					
					when(
						known(current.enteredPin) and
						known(current.correctPin) and
						knownval(current.pinReceived = true) and
						knownval(current.enteredPin != current.correctPin) // and
						// knownval(current.hasComparedOnce = false)
						)
					do {
						comparePins();
						conclude((current.pinIsWrong = true), bc:100, fc:100);
						conclude((current.hasComparedOnce = true), bc:100, fc:100);
						conclude((current.readyToActivate = false), bc:100, fc:100);
					}
		}
		
		workframe wf_comparePins_again {

					repeat: true;		
											
					when(
						knownval(current.pinIsWrong = true) and
						knownval(current.hasComparedOnce = true) and
						knownval(current.errorCount < 2) and 
						knownval(current.pinAsked = true)
						) 

					do {
						processAskPin();
						conclude((current.pinIsWrong = false), bc:100, fc:100);
						// conclude((current.pinAsked = false), bc:100, fc:100);
						conclude((H1User.pinCommunicated = false), bc:100, fc:100);
						conclude((H1User.pinRemembered = false), bc:100, fc:100);
						conclude((current.errorCount =  current.errorCount + 1), bc:100, fc:100);
					}
		}		
		
}
