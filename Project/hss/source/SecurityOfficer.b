agent SecurityOfficer {

location: SecurityOffice; 

attributes:
	public boolean alarmRaised;
	public boolean inform911;
	public boolean securitypinAsked;
	public boolean calledUser;
	public boolean SOpinRecd;
	public string SOpin;
	public string correctSOpin;
	public boolean pinIsWrong;
	public boolean hasComparedOnce;
	public boolean call911;
	public boolean Alarm;
	public Building Name; 
	
initial_beliefs:
	(current.alarmRaised = true);
	(current.inform911 = false);
	(current.securitypinAsked = false);
	(current.calledUser = false);
	(current.SOpinRecd = false);
	(current.correctSOpin = "house");
	(current.Name = House1);
	
initial_facts:
	(current.alarmRaised = true);
	(current.inform911 = false);
	(current.securitypinAsked = false);
	(current.calledUser = false);
	(current.SOpinRecd = false);
	(current.SOpin = unknown);
	(current.correctSOpin = "house");
	(current.pinIsWrong = true);
	(current.Alarm = false);
	(current.Name = House1);
	
activities:
	primitive_activity dialOwner() {
		max_duration: 100;
	}
			
	primitive_activity getPin() {
		max_duration: 100;
	}
	
	primitive_activity comparePins() {
		max_duration: 100;
	}
				
	communicate askSOPin() {
		max_duration: 10;
		with: H1User;
		about:
			send(current.securitypinAsked = true),
			send(current.calledUser = true);
			when: start;
		}
	
	communicate call911() {
		max_duration: 10;
		with: ResponseAgent911;
		about:
			send(current.Alarm = true),
			send(current.Name = current.Name);
			when: end;
		}

workframes:
	workframe wf_dialHOwner {
		repeat: false;

		when(
				knownval(current.alarmRaised = true) and
				knownval(current.calledUser = false)
				)
		do {
					dialOwner();
					conclude((current.calledUser = true), bc:100, fc:100);
					conclude((current.securitypinAsked = true), bc:100, fc:100);
					askSOPin();
				}
	}
	
	workframe wf_getSOPin {
		repeat: false;

		when(
				knownval(current.SOpinRecd = false) and
				knownval(H1User.SOpinCommunicated = true)
				)
						
		do {
					getPin();
					conclude((current.SOpin = H1User.SOpin), fc:100, bc:100);
				  conclude((current.hasComparedOnce = false), fc:100, bc:100);
					conclude((current.SOpinRecd = true), fc:100, bc:100);
				}
		}
	
		workframe wf_comparePins_ok {
			repeat: false;

			when(
					known(current.SOpin) and
					known(current.correctSOpin) and
					knownval(current.SOpinRecd = true) and
					(H1User.SOpin = current.correctSOpin)
					)
			do {
					comparePins();
					conclude((current.pinIsWrong = false), bc:100, fc:100);
					conclude((current.call911 = false), bc:100, fc:100);
					conclude((current.hasComparedOnce = true), fc:100, bc:100);
					}
		}
		
		workframe wf_comparePins_bad {
			repeat: false;
					
			when(
					known(current.SOpin) and
					known(current.correctSOpin) and
					knownval(current.SOpinRecd = true) and
					knownval(current.hasComparedOnce = false) and
					(H1User.SOpin != current.correctSOpin)
					)
			do {
					comparePins();
					conclude((current.pinIsWrong = true), bc:100, fc:100);
					conclude((current.call911 = true), bc:100, fc:100);
					conclude((current.Alarm = true), bc:100, fc:100);
					conclude((current.hasComparedOnce = true), fc:100, bc:100);
					}
		}
		
		workframe wf_call911 {
			repeat: false;
		
			when((current.call911 = true) and
					(current.hasComparedOnce = true) and
					(current.Alarm = true)
					)
			do {
					call911();
					}
		}
}
