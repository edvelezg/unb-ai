class Sensor extends BaseClass {
	
	attributes:
		public int senseTime;
		public boolean hasDetectedM;
	
	initial_facts:
		(current.senseTime = unknown);
		(Thief1.location = House2);
			
	activities:
		
		primitive_activity sense() {
			random: false;
			max_duration: 43200; // the whole 12 hours
		}
		
		primitive_activity record() {
			random: false;
			max_duration: 1;
		}
		
		communicate communicateAlarm() {
			max_duration: 10;
			with: SS;
			about:
				send(current.hasDetectedM = true);
			when: end;
		}		
			
			
	workframes:

		workframe wf_sense1 {
			repeat: false;
		//	priority: 2;
			variables:
				forone(Thief) th;
				
			detectables:
				detectable senseThief {
						when(whenever)
						detect((th.location = current.location), dc:100)
						then abort;
				}
			when(knownval(th.location = current.location))
			do {
				sense();
			}
		}

		workframe wf_S {
			repeat: false;
		//	priority: 2;
			variables:
				forone(Thief) th;
				
		//	detectables:
		//		detectable senseThief {
		///				when(whenever)
		//				detect((th.location = current.location), dc:100)
		//				then abort;
		//		}
			when(knownval(th.location = current.location))
			do {
				sense();
			}
		}	
		workframe wf_senseMovement {
			repeat: false;
		//priority: 1;
			variables:
				forone(Thief) th;
			when((th.location = current.location))
			do {
				record();
				conclude((current.senseTime = MyClock.time), fc:100);
				conclude((current.hasDetectedM = true), fc:100);
				communicateAlarm();
			}
		}

		workframe wf_sense2 {
			repeat: false;
		//	priority: 0;
			variables:
				forone(Thief) th;		
			detectables:
				detectable timeIsUp {
						when(whenever)
						detect((FredClock.time = 12), dc:100)
						then abort;
				}
				detectable senseThief {
						when(whenever)
						detect((th.location = current.location), dc:100)
						then abort;
				}				
			when()
			do {
				sense();
			}
		}
}
