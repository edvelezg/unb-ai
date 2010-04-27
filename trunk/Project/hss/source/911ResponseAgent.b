agent ResponseAgent911 {
location: EmgResponse;

attributes:
	public Building whereTo;
	
initial_beliefs:
	(current.whereTo = unknown);
	
initial_facts:
	(current.whereTo = unknown);
	
activities:
	communicate sendTeam1() {
	max_duration: 20;
	with: Team1;
	about:
		send(current.whereTo = current.whereTo);
		when: end;
	}
	
	communicate sendTeam2() {
	max_duration: 20;
	with: Team2;
	about:
		send(current.whereTo = current.whereTo);
		when: end;
	}
	
//	primitive_activity sendTeam() {
//		max_duration: 300;
//	}
	
workframes:
	workframe wf_decideWhereTo {
		
		repeat: false;
		priority:0;
		
		when(knownval(SecurityOfficer.Alarm = true))
		do {
					conclude((current.whereTo = SecurityOfficer.Name), bc:100, fc:100);
				}
	}
	
	workframe wf_SendTeam1 {
	
		repeat: false;
		priority:1;
		
		when(
				knownval(SecurityOfficer.Alarm = true) and
				knownval(current.whereTo = House1)
				)
		do {
					sendTeam1();
				}
	}
	
	workframe wf_SendTeam2 {
		repeat: false;

		when(
				knownval(SecurityOfficer.Alarm = true) and
				knownval(current.whereTo = House2)
				)
		do {
					sendTeam2();
				}
	}
}
