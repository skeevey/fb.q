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
GRAVITY:1;
CLS:@[system;$[`w32~.z.o;"cls";"clear"];""];

update_world:{
	//ugly
	res:("#",(SCREEN_HEIGHT-2)#" "),"#";
	if[(0=.state.counter mod 5);
		wall_size:rand SCREEN_HEIGHT - rand 4 5;
		res[$[.state.lastdirup;0+;SCREEN_HEIGHT-]@1 2,3+til wall_size]:"#";
		@[`.state;`lastdirup;$[bernoulli 0.85;not;(::)]];
	];
	`.state.universe set 1_'.state.universe,'res;
	};

bernoulli:{x > rand 1.0};

clear:{-1@CLS};

print:{clear[];
	sprite:"VA" .state.counter mod 2;
	-1@"\n" sv .[;(.state.altitude;INDENT);:;sprite].state.universe;};

bad_position:{[]"#"=.state.universe[.state.altitude;INDENT]};

move:{`.state.altitude set (SCREEN_HEIGHT - 1) & 0 | .state.altitude + x};

.z.ts:{
	`.state.counter set .state.counter + 1;
	move GRAVITY;
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
	[move[neg 1]];
	x like "[dDsS]*"; //go down
	[move[1]];
	[move[neg 1]]
	];
	};

start:{[]
	`.state.counter set 1;
	`.state.altitude set 2;
	`.state.lastdirup set 0b;
	
	`.state.universe set (
	SCREEN_WIDTH#"#";
	SCREEN_WIDTH#"         #";
	SCREEN_WIDTH#"         #";
	SCREEN_WIDTH#"         #";
	SCREEN_WIDTH#"     #    ";
	SCREEN_WIDTH#"     #    ";
	SCREEN_WIDTH#"     #    ";
	SCREEN_WIDTH#"#");
	
	system"S ",-5 sublist string `int$.z.t;
	system"t ",string INITIAL_SPEED;
	};

start[];