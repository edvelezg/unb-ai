agent Thief1 memberof Thief {
	
	location: House3;
	attributes:
	
	activities:
		move movetoHouse () {
			location: House1;
		}
	
	workframes:
	
		workframe wf_movetoHouse {
			repeat: false;
			when((FredClock.time = 1))
			do {
				movetoHouse();
			}
	}
}