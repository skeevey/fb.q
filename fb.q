//FLAPPY BIRDS

//UP - u/w [ENTER] or just [ENTER}
//DOWN - d/s [ENTER]
//EXIT - x [ENTER]

INITIAL_SPEED:1000;
DIFFICULTY_CURVE:0.03;
LEVEL_LENGTH:30;
MIN_TIME_INTERVAL:1;
SCREEN_WIDTH:50;
SCREEN_HEIGHT:9;
INDENT:2;
COLLISION_DETECTION_ON:1b; //change to turn off collision detection
GRAVITY:1;
CLS:@[system;$[`w32~.z.o;"cls";"clear"];""];

bernoulli:{x > rand 1.0};

clear:{-1@CLS};

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

print_world:{clear[];
	sprite:"VA" .state.counter mod 2;
	-1@"\n" sv .[.state.universe;(.state.altitude;INDENT);:;sprite];};

bad_position:{[]"#"=.state.universe[.state.altitude;INDENT]};

move:{`.state.altitude set (SCREEN_HEIGHT - 1) & 0 | .state.altitude + x};

.z.ts:{
	`.state.counter set .state.counter + 1;
	move GRAVITY;
	update_world[];
	print_world[];
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
	x like "[xX]*";   [exit 0];
	x like "[uUwW]*"; [move[neg 1]];
	x like "[dDsS]*"; [move[1]];
	[move[neg 1]]
	];
	};

start:{[]
	`.state.counter set 1;
	`.state.altitude set 2;
	`.state.lastdirup set 0b;
	
	t:(SCREEN_HEIGHT - 2) div 2;
	b:(SCREEN_HEIGHT - 2) - t;
	`.state.universe set (
		enlist[SCREEN_WIDTH#"#"],
		(t#enlist SCREEN_WIDTH#"         #"),
		(b#enlist SCREEN_WIDTH#"    #     "),
		enlist[SCREEN_WIDTH#"#"]);
	
	system"S ",-5 sublist string `int$.z.t;
	system"t ",string INITIAL_SPEED;
	};

start[];
