agent ResponseAgent911 {
location: EmgResponse;

activities:
	primitive_activity sendTeam() {
		max_duration: 300;
	}
	
workframes:
	workframe wf_SendTeam {
		repeat: false;

		when(
				knownval(SecurityOfficer.Alarm = true)
				)
		do {
					sendTeam();
//					conclude((current.calledUser = true), bc:100, fc:100);
//					conclude((current.securitypinAsked = true), bc:100, fc:100);
//					askSOPin();
				}
	}
}
