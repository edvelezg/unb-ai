agent Student_03 memberof Student {
	location: OffCampus;
	
	initial_beliefs:
		(current.morningActivity = eat);
		(current.afternoonActivity = study);
		(current.afterClassActivity = exercise);
}
