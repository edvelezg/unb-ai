agent Student_05 memberof Student {
	location: OffCampus;
	
	initial_beliefs:
		(current.morningActivity = study);
		(current.afternoonActivity = eat);
		(current.afterClassActivity = exercise);
}
