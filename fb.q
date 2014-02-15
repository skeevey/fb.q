//FLAPPY BIRDS

//UP - u/w [ENTER]
//DOWN - d/s [ENTER]
//EXIT - x [ENTER]

INITIAL_SPEED:1000;
DIFFICULTY_CURVE:0.03;
LEVEL_LENGTH:30;
MIN_TIME_INTERVAL:1;
SCREEN_WIDTH:40;
SCREEN_HEIGHT:8; //can't adjust this yet
INDENT:2;
COLLISION_DETECTION_ON:1b; //change to turn off collision detection
CLS:@[system;$[`w32~.z.o;"cls";"clear"];""];

UNIVERSE:(
	SCREEN_WIDTH#"#";
	SCREEN_WIDTH#"         #";
	SCREEN_WIDTH#"         #";
	SCREEN_WIDTH#"         #";
	SCREEN_WIDTH#"     #    ";
	SCREEN_WIDTH#"     #    ";
	SCREEN_WIDTH#"     #    ";
	SCREEN_WIDTH#"#");

update_world:{
	//ugly
	res:("#",(SCREEN_HEIGHT-2)#" "),"#";
	if[(0=.state.counter mod 4);
		res:@[res;$[.state.lastdirup;0+;SCREEN_HEIGHT-]@1 2,3+til rand SCREEN_HEIGHT - rand 4 5;:;"#"];
		@[`.state;`lastdirup;$[rand 7;not;(::)]];
	];
	@[`.;`UNIVERSE;:;1_'UNIVERSE,'res];
	};

clear:{-1@CLS};

print:{clear[];
	-1@"\n" sv .[;(.state.altitude;INDENT);:;"VA" .state.counter mod 2]UNIVERSE;};

bad_position:{[]"#"=UNIVERSE[.state.altitude;INDENT]};

.z.ts:{
	@[`.state;`counter;+;1];
	update_world[];
	print[];
	level:.state.counter div LEVEL_LENGTH;
	//level up?
	if[0 = .state.counter mod LEVEL_LENGTH;
		new_speed:ceiling INITIAL_SPEED * exp neg DIFFICULTY_CURVE * level;
		system"t ", string MIN_TIME_INTERVAL | new_speed;
	];
	//check for crash
	if[COLLISION_DETECTION_ON and bad_position[];
		system"t ",string 0;
		clear[];
		-1@"\n" sv SCREEN_HEIGHT#enlist SCREEN_WIDTH#"*";
		-1@"Game over!";
		-1@"Score ",string level;
		exit 0;
	];
	};

.z.pi:{$[
	x like "[xX]*";
	[exit 0];
	x like "[uUwW]*"; //go up
	[@[`.state;`altitude;:;0|.state.altitude - 1]];
	x like "[dDsS]*"; //go down
	[@[`.state;`altitude;:;(SCREEN_HEIGHT-1)&.state.altitude + 1]];
	{`do_nothing;::}
	];
	};

start:{[]
	`.state.counter set 1;
	`.state.altitude set 2;
	`.state.lastdirup set 0b;
	system"S ",-5#string `int$.z.t;
	system"t ",string INITIAL_SPEED;
	};

start[];