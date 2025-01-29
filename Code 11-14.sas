proc reg data=fitness;
A:  model Oxygen=RunTime Age Weight RunPulse RestPulse / tol vif collin;
B: 	model Oxygen=RunTime Age Weight MaxPulse RestPulse / tol vif collin;
C:  model Oxygen=RunTime Age Weight RunPulse MaxPulse RestPulse / tol vif collin;
run;
