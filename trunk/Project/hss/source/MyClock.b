class MyClock {

	attributes:
		public int time;
		public int tenMinUnits;
	
	
	initial_facts:
		(current.tenMinUnits = 0);
		
		
	activities:
		primitive_activity waitTenMinutes() {
					random: false;
					max_duration: 599; // 10 minutes
		}
	
		broadcast announceTime() {
					random: false;
					max_duration: 1;
					to: Fredericton;
					about: 
						send(current.tenMinUnits),
						send(current.time);
					when: end;	 
		}
			
			
	workframes:

		workframe wf_waitOneHour {
				repeat: true;
				when(
					(current.tenMinUnits = 5) and
					(current.time <= 10))
				do {
					waitTenMinutes();
					conclude((current.tenMinUnits = 0), bc:100, fc:100);
					conclude((current.time = current.time + 1), bc:100, fc:100);
					announceTime();
				}
		}
		
		workframe wf_waitTenMinutes {
				repeat: true;
				when(
					(current.tenMinUnits < 5) and
					(current.time <= 10))
				do {
					waitTenMinutes();
					conclude((current.tenMinUnits = current.tenMinUnits + 1), bc:100, fc:100);
					announceTime();
				}
		}
}