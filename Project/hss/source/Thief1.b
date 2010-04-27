agent Thief1 memberof Thief {
	
	location: House3;
	attributes:
		public Rooms visitedRoom1;	
		public Rooms visitedRoom2;
		public boolean isAtHouse;			
		
	initial_beliefs:
		(H2.location = House2);			
		(H1.location = House1);		
		(Garage2.hasEntry = true);
		(OpenGround.hasEntry = true);		
		(current.visitedRoom1 = unknown);
		(current.visitedRoom2 = unknown);
		(current.isAtHouse = false);

	activities:

			move moveToLocation(Building loc) {
					 location: loc;
			}

			move moveToRoom(Rooms room) {
					 location: room;
			}

			primitive_activity sneakToRoom() {
				max_duration: 100;
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
					conclude((current.isAtHouse = true), bc:100, fc:100);					
				}
			}	
			
			workframe wf_movetoRoom1
			{
				repeat: false;
				priority: 1;
				variables:
					forone(Building) bd;
					forone(House) hs;
					forone(Rooms) rm;
				when(
					knownval(current.isAtHouse = true) and
					knownval(rm.hasEntry = true) and
					knownval(current.visitedRoom1 = unknown)
					)
				do 
				{
					sneakToRoom();
					moveToRoom(rm);
					conclude((current.visitedRoom1 = rm), bc:100, fc:100);
				}
			}			
			workframe wf_movetoRoom2
			{
				repeat: false;
				variables:
					forone(Building) bd;
					forone(House) hs;
					forone(Rooms) rm;
				when(
					knownval(current.isAtHouse = true) and
					knownval(rm.hasEntry = true) and
//					not(rm = current.visitedRoom1) and
					(rm != current.visitedRoom1)
					)
				do 
				{
					sneakToRoom();
					moveToRoom(rm);
					conclude((current.visitedRoom2 = rm), bc:100, fc:100);
				}
			}			
			
}
