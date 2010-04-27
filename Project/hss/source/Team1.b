agent Team1 memberof ResponseTeam {
location: PStation1;

attributes:
	public Building whereTo;
	
initial_beliefs:
	(current.whereTo = unknown);

initial_facts:
	(current.whereTo = unknown);

activities:

	move moveToLocation(Building loc) {
			location: loc;
	}

workframes:
		workframe wf_decideWhereTo {
		
		repeat: false;
		priority:0;
		
		when(knownval(SecurityOfficer.Alarm = true))
		do {
					conclude((current.whereTo = ResponseAgent911.whereTo), bc:100, fc:100);
				}
		}

		workframe wf_moveTeam{
		repeat: false;
		variables:
				forone(Building) bd;
		when(
					knownval(SecurityOfficer.Alarm = true) and
					(current.whereTo = bd)
				)
		do {
							moveToLocation(bd);
				}
		
		}
		
}
