agent Student_10 memberof Student {
	location: OffCampus;
	
	initial_beliefs:
		(current.morningActivity = exercise);
		(current.afternoonActivity = eat);
		(current.afterClassActivity = study);
}