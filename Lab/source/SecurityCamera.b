class SecurityCamera {
	
	attributes:
		public int senseTime;
		public symbol suitColor;
		
	initial_facts:
		(current.senseTime = unknown);
		(current.suitColor = unknown);
	
			
	activities:
	
		communicate sendSuitColor() { // Answer question that is asked by a student
			max_duration: 30; 
			with: CampusPolice; // communication established police agent
			about:
				send(current.suitColor); // sends the instructor's current value of teaching
			when: end;
		}
	
		primitive_activity sense() {
			random: false;
			max_duration: 36000; // the whole 10 hours
		}
		
		primitive_activity record() {
			random: false;
			max_duration: 500;
		}

				
	workframes:

		workframe wf_sense1 {
			repeat: false;
			priority: 2;
			detectables:
				detectable senseThief {
						when(whenever)
						detect((Thief.location = current.location), dc:100)
						then abort;
				}
			when()
			do {
				sense();
			}
		}
	
		workframe wf_recordEvent {
			repeat: false;
			priority: 1;
			when(
				(Thief.location = current.location))
			do {
				record();
				conclude((current.senseTime = MyClock.time), fc:100);
				conclude((current.suitColor = Thief.suitColor), fc:100);
			}
		}

		workframe wf_sense2 {
			repeat: false;
			priority: 0;
			detectables:
				detectable timeIsUp {
						when(whenever)
						detect((UniversityClock.time = 11), dc:100)
						then abort;
				}
				detectable isBeingChecked {
						when(whenever)
						detect((CampusPolice.checkingCamera = true), dc:100)
						then abort;
				}
				
			when()
			do {
				sense();
			}
		}
		
		workframe wf_sendSuitColor {
			repeat: false;
			when(
			(CampusPolice.checkingCamera = true)
			)
			do {
				sendSuitColor();
			}
		}

}	
