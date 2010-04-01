class Keypad {

	display: "Keypad";
  	cost: 0.0;
 	resource: true;

	attributes:
		public boolean pinIsWrong;	
		public boolean pinChecked;
		public boolean pinAsked;	
		public boolean hasStarted;
		public int pin;

	initial_beliefs:
		(current.pinIsWrong != false);
		(current.hasStarted = false);
		(current.pinChecked = false);		
		(current.pinAsked = false);		
		
	initial_facts:
		(current.pinChecked = false);
		(current.pinAsked = false);
		(current.pinIsWrong != false);		
		(current.pin = 1111);
		(current.hasStarted = false);		

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
					max_duration: 50;
					with: H1User;
					about:
						send(current.pinAsked = true);
					when: end;
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
		
//		workframe wf_askPin {
//
//					repeat: true;
//
//					variables:
//						forone(HouseUser) hur1;
//
//					when(
//						knownval(hur1.isAtKeypad = true) and					
//						knownval(current.hasStarted = true) and
//						knownval(current.pinAsked = false)
//						)
//
//
//					do {
//						processAskPin();
//						askPin(hur1);
//						conclude((current.pinAsked = true), bc:100, fc:100);
//					}
//		}	

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
		
}
