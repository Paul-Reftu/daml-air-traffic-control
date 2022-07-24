dtmc

// Gateway counters.
global ctr_gate1Planes    : [0..1];
global ctr_gate2Planes    : [0..1];
global ctr_gate3Planes    : [0..1];
global ctr_gate4Planes    : [0..1];


// Taxiway counters.
global ctr_taxiway1Planes : [0..2];
global ctr_taxiway2Planes : [0..2];

// Runway counter.
global ctr_runwayPlanes   : [0..2];

formula sky 	 	= s=0;
formula runway   	= s=1;
formula taxiway2_1 	= s=2;
formula taxiway2_2 	= s=8;
formula gate1 	 	= s=3;
formula gate2 	 	= s=4;
formula gate3 	 	= s=5;
formula gate4 	 	= s=6;
formula taxiway1_1 	= s=7;
formula taxiway1_2 	= s=9;

module plane1
	s 	                   : [0..9];
	imminentLand           : bool init true;
	trafficPatternComplete : bool init false;

	// Sky -> Runway transitions.
	[] sky & ctr_runwayPlanes < 2 & !trafficPatternComplete -> 
		1/1000 : (s'=1) & (ctr_runwayPlanes'=ctr_runwayPlanes+1) +
		999/1000 : (s'=0);
	[] sky & !trafficPatternComplete ->
		(s'=0);

	// Runway -> Taxiway2 transitions.
	[] runway & ctr_taxiway2Planes < 2 & imminentLand & ctr_runwayPlanes>0 ->
		1/2 : (s'=2) & (ctr_taxiway2Planes'=ctr_taxiway2Planes+1) & (ctr_runwayPlanes'=ctr_runwayPlanes-1) +
		1/2 : (s'=8) & (ctr_taxiway2Planes'=ctr_taxiway2Planes+1) & (ctr_runwayPlanes'=ctr_runwayPlanes-1);

	// Taxiway2 -> Gate_i transitions, for all i \in [1, 4].
	[] (taxiway2_1 | taxiway2_2) & ctr_gate1Planes < 1 & ctr_taxiway2Planes>0 ->
		(s'=3) & (ctr_gate1Planes'=ctr_gate1Planes+1) & (ctr_taxiway2Planes'=ctr_taxiway2Planes-1);
	[] (taxiway2_1 | taxiway2_2) & ctr_gate2Planes < 1 & ctr_taxiway2Planes>0 ->
		(s'=4) & (ctr_gate2Planes'=ctr_gate2Planes+1) & (ctr_taxiway2Planes'=ctr_taxiway2Planes-1);
	[] (taxiway2_1 | taxiway2_2) & ctr_gate3Planes < 1 & ctr_taxiway2Planes>0 ->
		(s'=5) & (ctr_gate3Planes'=ctr_gate3Planes+1) & (ctr_taxiway2Planes'=ctr_taxiway2Planes-1);
	[] (taxiway2_1 | taxiway2_2) & ctr_gate4Planes < 1 & ctr_taxiway2Planes>0 ->
		(s'=6) & (ctr_gate4Planes'=ctr_gate4Planes+1) & (ctr_taxiway2Planes'=ctr_taxiway2Planes-1);
	
	// Gate_i -> Taxiway1 transitions, for all i \in [1, 4].
	[] gate1 & ctr_taxiway1Planes < 2 & ctr_gate1Planes>0 ->
		1/2 : (s'=7) & (ctr_taxiway1Planes'=ctr_taxiway1Planes+1) & (ctr_gate1Planes'=ctr_gate1Planes-1) + 
		1/2 : (s'=9) & (ctr_taxiway1Planes'=ctr_taxiway1Planes+1) & (ctr_gate1Planes'=ctr_gate1Planes-1);
	[] gate2 & ctr_taxiway1Planes < 2 & ctr_gate2Planes>0 ->
		1/2 : (s'=7) & (ctr_taxiway1Planes'=ctr_taxiway1Planes+1) & (ctr_gate2Planes'=ctr_gate2Planes-1) + 
		1/2 : (s'=9) & (ctr_taxiway1Planes'=ctr_taxiway1Planes+1) & (ctr_gate2Planes'=ctr_gate2Planes-1);
	[] gate3 & ctr_taxiway1Planes < 2 & ctr_gate3Planes>0 ->
		1/2 : (s'=7) & (ctr_taxiway1Planes'=ctr_taxiway1Planes+1) & (ctr_gate3Planes'=ctr_gate3Planes-1) + 
		1/2 : (s'=9) & (ctr_taxiway1Planes'=ctr_taxiway1Planes+1) & (ctr_gate3Planes'=ctr_gate3Planes-1);
	[] gate4 & ctr_taxiway1Planes < 2 & ctr_gate4Planes>0 ->
		1/2 : (s'=7) & (ctr_taxiway1Planes'=ctr_taxiway1Planes+1) & (ctr_gate4Planes'=ctr_gate4Planes-1) + 
		1/2 : (s'=9) & (ctr_taxiway1Planes'=ctr_taxiway1Planes+1) & (ctr_gate4Planes'=ctr_gate4Planes-1);

	// Taxiway1 -> Runway transitions.
	[] (taxiway1_1 | taxiway1_2) & ctr_runwayPlanes < 2 & ctr_taxiway1Planes>0 ->
		(s'=1) & (ctr_runwayPlanes'=ctr_runwayPlanes+1) & (ctr_taxiway1Planes'=ctr_taxiway1Planes-1) & (imminentLand'=false);
	
	// Runway -> Sky transition.
	[] runway & !imminentLand & ctr_runwayPlanes>0  ->
		(s'=0) & (imminentLand'=true) & (ctr_runwayPlanes'=ctr_runwayPlanes-1) & (trafficPatternComplete' = true);

endmodule

module plane2=plane1[s=s2, imminentLand=imminentLand2, trafficPatternComplete=trafficPatternComplete2] endmodule
module plane3=plane1[s=s3, imminentLand=imminentLand3, trafficPatternComplete=trafficPatternComplete3] endmodule
module plane4=plane1[s=s4, imminentLand=imminentLand4, trafficPatternComplete=trafficPatternComplete4] endmodule