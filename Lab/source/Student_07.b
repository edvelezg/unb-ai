agent Student_07 memberof Student {
	location: OffCampus;
	
	initial_beliefs:
		(current.morningActivity = study);
		(current.afternoonActivity = exercise);
		(current.afterClassActivity = leave);
}
