agent Thief1 memberof Thief {
	
	location: House3;
	attributes:
	
	initial_beliefs:
		(H2.location = House2);			
		(H1.location = House1);		

	activities:

			move moveToLocation(Building loc) {
					 location: loc;
			}
	
	workframes:
	
			workframe wf_movetoHouse 
			{
				repeat: false;
				variables:
					forone(Building) bd;
					forone(House) hs;
				when(
					not(current.location = hs.location) and
					knownval(hs.location = bd) and
					(FredClock.time = 1)
					)
				do 
				{
					moveToLocation(bd);
				}
			}
}
