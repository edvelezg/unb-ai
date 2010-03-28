class Keypad {

	display: "Atm";
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

}
