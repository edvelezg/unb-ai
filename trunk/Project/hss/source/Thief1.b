agent Thief1 memberof Thief {
	
	location: House3;
	attributes:
		public Rooms first;	
		public Rooms second;	
		public Rooms third;	
		public Rooms visitedRoom1;	
		public Rooms visitedRoom2;
		public Rooms visitedRoom3;
		public boolean isAtHouse;			
		public boolean hasOrder;			
		public boolean wasDetectedInRoom1;			
		public boolean wasDetectedInRoom2;			
		public boolean wasDetectedInRoom3;			
		
		
	initial_beliefs:
		(H2.location                = House2);			
		(H1.location                = House1);		
		(Garage2.hasEntry           = true);
		(OpenGround.hasEntry        = true);		
		(Foyer.hasEntry             = true);		
		(current.visitedRoom1       = unknown);
		(current.visitedRoom2       = unknown);
		(current.visitedRoom3       = unknown);		
		(current.isAtHouse          = false);
		(current.hasOrder           = false);
		(current.wasDetectedInRoom3 = false);
		(current.wasDetectedInRoom2 = false);
		(current.wasDetectedInRoom1 = false);
		(SS.alarmSound              = false);

	activities:

			move moveToLocation(Building loc) {
					 location: loc;
			}

			move moveToRoom(Rooms room) {
					 location: room;
			}

			primitive_activity stayInRoom() {
				max_duration: 1000;
			}	

			primitive_activity hearsAlarm() {
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
					(FredClock.time = 2)
					)
				do 
				{
					moveToLocation(bd);
					conclude((current.isAtHouse = true), bc:100, fc:100);					
				}
			}	

			workframe wf_determineOrder 
			{
				repeat: false;
				variables:
					forone(Building) bd;
					forone(House) hs;
				when(
					(current.location = hs.location) and
					knownval(hs.location = bd) and
					knownval(current.hasOrder = false)
					)
				do 
				{
					moveToLocation(bd);
					conclude((current.first = Garage2), bc:100, fc:100);					
					conclude((current.first = OpenGround), bc:50, fc:50);					
					conclude((current.first = Foyer), bc:50, fc:50);					
					conclude((current.hasOrder = true), bc:100, fc:100);					
					
				}
			}	
			
			workframe wf_movetoRoom1
			{
				repeat: false;
				priority: 2;
				variables:
					forone(Building) bd;
					forone(House) hs;
					foreach(Rooms) rm;
				detectables:
					detectable wasDetected{
						when(whenever)
							detect((SS.alarmSound = true), dc:100)
							then complete;
					}
					
				when(
					knownval(current.isAtHouse = true) and
					knownval(rm.hasEntry = true) and
					knownval(current.hasOrder = true) and
					knownval(current.visitedRoom1 = unknown) and
					knownval(current.first = rm) and
					knownval(SS.alarmSound = false)
					)
				do 
				{
					moveToRoom(rm);
					stayInRoom();
					conclude((current.visitedRoom1 = rm), bc:100, fc:100);
				}
			}
			
			workframe wf_wasDetectedInRoom1
			{
				repeat: false;
				variables:
					forone(Building) bd;
					forone(House) hs;
					forone(Rooms) rm;			
				when(
					knownval(current.isAtHouse = true) and
					knownval(rm.hasEntry = true) and
					knownval(current.hasOrder = true) and
					knownval(current.visitedRoom1 = rm) and
					knownval(SS.alarmSound = true)
					)
				do 
				{
					hearsAlarm();
					conclude((current.wasDetectedInRoom1 = true), bc:100, fc:100);
					conclude((SS.alarmSound = false), bc:100, fc:100);
				}
			}	
					
			workframe wf_movetoRoom2
			{
				repeat: false;
				priority: 1;				
				variables:
					forone(Building) bd;
					forone(House) hs;
					forone(Rooms) rm;
				detectables:
					detectable wasDetected{
						when(whenever)
							detect((SS.alarmSound = true), dc:100)
							then complete;
					}
				when(
					knownval(current.isAtHouse = true) and
					knownval(rm.hasEntry = true) and
					knownval(current.hasOrder = true) and
					known(current.visitedRoom1) and
					knownval(rm != current.visitedRoom1) and
					knownval(current.visitedRoom2 = unknown) and
					knownval(SS.alarmSound = false)
					)
				do 
				{
					moveToRoom(rm);
					stayInRoom();
					conclude((current.visitedRoom2 = rm), bc:100, fc:100);
				}
			}
			
			workframe wf_wasDetectedInRoom2
			{
				repeat: false;
				variables:
					forone(Building) bd;
					forone(House) hs;
					forone(Rooms) rm;			
				when(
					knownval(current.isAtHouse = true) and
					knownval(rm.hasEntry = true) and
					knownval(current.hasOrder = true) and
					knownval(current.visitedRoom2 = rm) and
					knownval(SS.alarmSound = true)
					)
				do 
				{
					hearsAlarm();
					conclude((current.wasDetectedInRoom2 = true), bc:100, fc:100);
					conclude((SS.alarmSound = false), bc:100, fc:100);
				}
			}				

			workframe wf_movetoRoom3
			{
				repeat: false;
				variables:
					forone(Building) bd;
					forone(House) hs;
					forone(Rooms) rm;
				detectables:
					detectable wasDetected{
						when(whenever)
							detect((SS.alarmSound = true), dc:100)
							then complete;
					}
				when(
					knownval(current.isAtHouse = true) and
					knownval(rm.hasEntry = true) and
					knownval(current.hasOrder = true) and
					knownval(rm != current.visitedRoom1) and
					knownval(rm != current.visitedRoom2) and
					knownval(current.visitedRoom3 = unknown) and
					knownval(SS.alarmSound = false)
					)
				do 
				{
					moveToRoom(rm);
					stayInRoom();
					conclude((current.visitedRoom3 = rm), bc:100, fc:100);
				}
			}	

			workframe wf_wasDetectedInRoom3
			{
				repeat: false;
				variables:
					forone(Building) bd;
					forone(House) hs;
					forone(Rooms) rm;			
				when(
					knownval(current.isAtHouse = true) and
					knownval(rm.hasEntry = true) and
					knownval(current.hasOrder = true) and
					knownval(current.visitedRoom3 = rm) and
					knownval(SS.alarmSound = true)
					)
				do 
				{
					hearsAlarm();
					conclude((current.wasDetectedInRoom3 = true), bc:100, fc:100);
					conclude((SS.alarmSound = false), bc:100, fc:100);
				}
			}							
			
}
