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
			when: start;
		}		

		// communicate informInstructor(Instructor instructor) { // inform instructor
		// 	max_duration: 500; 
		// 	with: instructor; // communication established with instructor
		// 	about:
		// 		send(ITC315Camera.suitColor); // sends the thief's suitColor to the instructors
		// 	when: end;
		// }
		
		communicate informInstructor1() { // inform instructor
			max_duration: 500; 
			with: Instructor_01; // communication established with instructor
			about:
				send(ITC315Camera.suitColor); // sends the thief's suitColor to the instructors
			when: end;
		}
		
		communicate informInstructor2() { // inform instructor
			max_duration: 500; 
			with: Instructor_02; // communication established with instructor
			about:
				send(ITC315Camera.suitColor); // sends the thief's suitColor to the instructors
			when: end;
		}

		communicate informInstructor3() { // inform instructor
			max_duration: 500; 
			with: Instructor_03; // communication established with instructor
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
					// variables:  // this did not work for some unknown reason.
					// 	collectall (Instructor) instructor;
					when(
						known(ITC315Camera.suitColor)
						)
					do 
					{
						conclude((current.suitColor = ITC315Camera.suitColor), bc:100, fc: 100);
//						informInstructor(instructor);
						informInstructor1();
						informInstructor2();
						informInstructor3();
					}
				}
}				