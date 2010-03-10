agent Student_09 memberof Student {
	location: OffCampus;
	
	initial_beliefs:
		(current.morningActivity = exercise);
		(current.afternoonActivity = study);
		(current.afterClassActivity = leave);
}
