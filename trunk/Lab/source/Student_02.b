agent Student_02 memberof Student {
	location: OffCampus;
	
	initial_beliefs:
		(current.morningActivity = eat);
		(current.afternoonActivity = exercise);
		(current.afterClassActivity = leave);
}
