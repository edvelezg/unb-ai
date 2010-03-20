agent CampusPolice {
	location: PoliceBuilding;
	
	attributes:
		public boolean projector;
		public boolean checkingCamera;
		public symbol suitColor;
	
	initial_beliefs:
		(current.projector = true);
		(current.suitColor = unknown);
		(current.checkingCamera = false);
		
	
	activities:	
		primitive_activity wait() {
			random: false;
			max_duration: 36000; // the whole 10 hours
		}

		primitive_activity answerCall() {
			random: false;
			max_duration: 500;
		}
		
		communicate checkCamera() { // Answer question that is asked by a student
			max_duration: 500; 
			with: ITC315Camera; // communication established police agent
			about:
				send(current.checkingCamera); // sends the instructor's current value of teaching
			when: end;
		}		

		communicate informInstructor(Instructor instructor) { // inform instructor
			max_duration: 500; 
			with: instructor; // communication established with instructor
			about:
				send(ITC315Camera.suitColor); // sends the thief's suitColor to the instructors
			when: end;
		}
		
	workframes:
	
				workframe wf_wait { // the instructor can be teaching
					repeat: false;
					priority: 0;
					detectables:
						detectable answerCall { // if the instructor calls 
							when(whenever)
							detect((Instructor_01.seenProjector = false), dc:100)
							then abort;
						}
					when()
					do {
						wait();
					}
				}
								
				workframe wf_checkSecurityCamera 
				{
					repeat: false;
					when(
						(Instructor_01.seenProjector = false)
						)
					do 
					{
						answerCall();
						conclude((current.projector = Instructor_01.seenProjector), bc:100, fc:100);
						checkCamera();
						conclude((current.checkingCamera = true), bc:100, fc:100);
						
					}
				}
								
				workframe wf_informInstructors 
				{
					repeat: false;
					variables:
						collectall (Instructor) instructor;
					when(
						known(ITC315Camera.suitColor)
						)
					do 
					{
						conclude((current.suitColor = ITC315Camera.suitColor), bc:100, fc: 100);
						informInstructor(instructor);
					}
				}
}				

//class Sensor extends BaseClass {
//	
//	attributes:
//		public int senseTime;
//	
//	
//	initial_facts:
//		(current.senseTime = unknown);
//	
//			
//	activities:
//
//		primitive_activity sense() {
//			random: false;
//			max_duration: 36000; // the whole 10 hours
//		}
//		
//		primitive_activity record() {
//			random: false;
//			max_duration: 1;
//		}
//
//				
//	workframes:
//
//		workframe wf_sense1 {
//			repeat: false;
//			priority: 2;
//			detectables:
//				detectable senseInstructor {
//						when(whenever)
//						detect((Instructor_03.location = current.location), dc:100)
//						then abort;
//				}
//			when()
//			do {
//				sense();
//			}
//		}
//	
//		workframe wf_recordInstructor {
//			repeat: false;
//			priority: 1;
//			variables:
//				forone(Instructor) instructor;
//			when(
//				(instructor.location = current.location))
//			do {
//				record();
//				conclude((current.senseTime = MyClock.time), fc:100);
//			}
//		}
//
//		workframe wf_sense2 {
//			repeat: false;
//			priority: 0;
//			detectables:
//				detectable timeIsUp {
//						when(whenever)
//						detect((UniversityClock.time = 11), dc:100)
//						then abort;
//				}
//			when()
//			do {
//				sense();
//			}
//		}
//}
