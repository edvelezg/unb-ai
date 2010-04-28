class Sensor extends BaseClass {
	
	attributes:
		public int senseTime;
		public boolean hasDetectedM;
	
	initial_beliefs:
		(current.hasDetectedM = false); 
	
	initial_facts:
		(current.senseTime = unknown);
		(current.hasDetectedM = false);
			
	activities:
		
		primitive_activity sense() {
			random: false;
			max_duration: 43200; // the whole 12 hours
		}
		
		primitive_activity sendAlert() {
			random: false;
			max_duration: 120;
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
			priority: 2;
			variables:
//				forone(Thief) th; TODO: how do we make this detectable generic.
			detectables:
				detectable senseThief {
						when(whenever)
						detect((<Thief>.location = current.location), dc:100)
						then abort;
				}
			when()
			do {
				sense();
			}
		}
	
		workframe wf_senseMovement {
			repeat: false;
			priority: 1;
			variables:
				forone(Thief) th;
			when((th.location = current.location))
			do {
				conclude((current.senseTime = MyClock.time), fc:100);
				conclude((current.hasDetectedM = true), bc:100, fc:0);
				sendAlert();
				communicateAlarm();
			}
		}

		workframe wf_sense2 {
			repeat: false;
			priority: 0;
			detectables:
				detectable timeIsUp {
						when(whenever)
						detect((FredClock.time = 12), dc:100)
						then abort;
				}
			when()
			do {
				sense();
			}
		}

}
