class MyClock {

	attributes:
		public int time;	//time variable defined
	
	activities:
			primitive_activity waitAMin() { //activity 1 definition
						random: false;		//set if the activity can be preformed randomly to false
						max_duration: 59; //set the time duration for the activity in Sec.
			}
	
			broadcast announceTime() { //activity 2 definition
						random: false;			//set if the activity can be preformed randomly to false
						max_duration: 1;		//set the time duration for the activity in Sec.
						to: UNB;						//set to where the broadcast should be sent
						about: 
							send(current.time = current.time); //what should be broadcasted
						when: end;	 //define when this activity should end
			}
			
	workframes:
			workframe wf_waitAMin {   //workframe 1 definition
					repeat: true;						//set if the workframe should be repeated
					when(knownval(current.time <= 600)) //check if the current time is less than or equal to 5
					do {
						waitAMin();					// if the condition is true then call waitAnHour activity
						conclude((current.time = current.time + 1), bc:100, fc:100); //conclude that current time 
						//has changed with belief certainity of 100% and fact certainity of 100%
						announceTime(); //do the actual broadcast of time announcement
					}
			}
}
