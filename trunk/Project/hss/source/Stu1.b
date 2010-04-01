agent Stu1 memberof Student {
	location: SecurityOffice;
	
	initial_beliefs:
		(current.morningActivity = eat);
		(current.afternoonActivity = exercise);
		(current.afterClassActivity = study);
}
