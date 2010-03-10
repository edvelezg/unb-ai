agent Student_08 memberof Student {
	location: OffCampus;
	
	initial_beliefs:
		(current.morningActivity = study);
		(current.afternoonActivity = eat);
		(current.afterClassActivity = study);
}
