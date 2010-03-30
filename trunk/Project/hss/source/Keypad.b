class Keypad {

	display: "Keypad";
  	cost: 0.0;
 	resource: true;

	attributes:
		public int currentAccountCode;
		public int currentAccountPin;
		public boolean sessionIsOn;
		public boolean checkedAccountCode;
		public boolean checkedAccountPin;
		public boolean pinChecked;
		public boolean askedVerification;
		public boolean cashCanBeDispensed;
		public int errorCount;
		public boolean pinIsWrong;
		public boolean pinAsked;
		public boolean waitReply;
		public boolean amountAsked;
		public boolean amountChecked;
		public double currentAmountRequested;
		public boolean cashDispensed;
		public double cashToDispense;
		public boolean RepliedVerification;
		
		//CHANGED: Ed
		public int pin;

	initial_beliefs:
		(current.pinIsWrong != false);
		(current.waitReply = false);
		(current.amountAsked = false);
		(current.RepliedVerification = false);
		(current.amountChecked = false);
		(current.currentAmountRequested = 0.0);
		(current.askedVerification = false);
		(current.cashDispensed != false);
		(current.sessionIsOn = false);
		(current.cashToDispense = 0.0);

	initial_facts:
		(current.sessionIsOn = false);
		(current.checkedAccountCode = false);
		(current.checkedAccountPin = false);
		(current.pinChecked = false);
		(current.askedVerification = false);
		(current.cashCanBeDispensed != false);
		(current.currentAccountPin = 0);
		(current.currentAccountCode = 0);
		(current.errorCount = 0);
		(current.pinAsked = false);
		(current.waitReply = false);
		(current.RepliedVerification = false);
		(current.amountAsked = false);
		(current.amountChecked = false);
		(current.currentAmountRequested = 0.0);
		(current.cashDispensed != false);
		(current.pinIsWrong != false);
		(current.cashToDispense = 0.0);
		
		//CHANGED: Ed
		(current.pin = 1111);

	activities:

		primitive_activity getAccount() {
					max_duration: 4;
				}

		primitive_activity getPin() {
					max_duration: 500;
				}

		primitive_activity getAmount() {
					max_duration: 5;
				}

		primitive_activity comparePins() {
					max_duration: 4;
				}

		primitive_activity matchPin_No() {
					max_duration: 3;
				}


		primitive_activity matchPin_Yes() {
					max_duration: 3;
				}

		primitive_activity returnCardandMoney() {
					max_duration: 9;
				}

		primitive_activity returnCardwithNoMoney() {
					max_duration: 6;
				}

		primitive_activity waitStudentReply() {
					max_duration: 3000;
		}

		primitive_activity waitBankReply() {
					max_duration: 3000;
		}

		primitive_activity processPinReply() {
					max_duration: 4;
		}

		primitive_activity processAskPin() {
					max_duration: 100;
		}


		primitive_activity processAskBankVerification() {
					max_duration: 4;
		}

		primitive_activity processAskAmount() {
					max_duration: 2;
		}		

		primitive_activity waitOnPin() {
					max_duration: 50;
		}		

		communicate askPin(HomeUser hur) {
					max_duration: 1;
					with: hur;
					about:
						send(current.pinAsked = true);
					when: end;
		}

	workframes:

		workframe wf_getAccount {

					repeat: false;

					variables:
						forone(HomeUser) hur0; 

					when(
						knownval(hur0.isAtKeypad = true) and
						knownval(current.sessionIsOn = false) and
						knownval(current.checkedAccountCode = false)
						)

					do {
						getAccount();
						conclude((current.sessionIsOn = true), bc:100, fc:100);
						conclude((current.checkedAccountCode = true), bc:100, fc:100);

					}
		}
		

		workframe wf_askPin {

					repeat: true;

					variables:
						forone(HomeUser) hur1;

					when(
						knownval(current.checkedAccountPin = false) and
						knownval(current.checkedAccountCode = true) and
						knownval(current.pinAsked = false)
						)


					do {
						processAskPin();
						askPin(hur1);
						conclude((current.pinAsked = true), bc:100, fc:100);
					}
		}			
			
			// workframe wf_getPin {
			// 
			// 			repeat: false;
			// 
			// 			variables:
			// 				forone(HomeUser) hur1;
			// 
			// 			when(
			// 				knownval(current.checkedAccountPin = false) and
			// 				knownval(current.checkedAccountCode = true) and
			// 				knownval(homeusr.pinCommunicated = true)
			// 				)
			// 
			// 			do {
			// 				getPin();
			// 				conclude((current.currentAccountPin = homeusr.believedPin), bc:100, fc:100);
			// 				conclude((current.checkedAccountPin = true), bc:100, fc:100);
			// 
			// 			}
			// }			
		
}
