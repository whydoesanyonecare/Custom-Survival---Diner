//PLUTONIUM v1

//TODO:
//disable avogadro -- not able to remodel back after custom round ends

//KNOWN BUGS:
//avogadro is screecher after custom round
//unlimited ammo/custom perk shaders are broken | find new shaders that work on plutonium

#include maps/mp/_utility;
#include common_scripts/utility;
#include maps/mp/gametypes_zm/_hud_util;
#include maps/mp/gametypes_zm/_hud_message;
#include maps/mp/zombies/_zm_stats;
#include maps/mp/zombies/_zm_utility;
#include maps/mp/gametypes_zm/_weapons;
#include maps/mp/zombies/_zm_weapons;
#include maps/mp/zombies/_zm;
#include maps/mp/zombies/_zm_magicbox;
#include codescripts/character;
#include maps/mp/zombies/_zm_spawner;
#include maps/mp/animscripts/zm_shared;
#include maps/mp/animscripts/zm_utility;
#include maps/mp/zombies/_zm_perks;
#include maps/mp/zombies/_zm_buildables;
#include maps/mp/zombies/_zm_game_module;
#include maps/mp/zombies/_zm_powerups;
#include maps/mp/zombies/_zm_score;
#include maps/mp/zm_transit_buildables;
#include maps/mp/_visionset_mgr;
#include maps/mp/zombies/_zm_ai_basic;
#include maps/mp/zombies/_zm_audio_announcer;
#include maps/mp/zombies/_zm_audio;
#include maps/mp/zm_transit;
init()
{
    level.avogadro_spawners = 0; //untested disable avogadro
    level.zombie_ai_limit_avogadro = 0; //untested
	level.unlimited_ammo_duration = 30;
	level thread drawZombiesCounter();
	level thread onPlayerConnect();
	level thread setDvars();
    level.zombie_last_stand = ::LastStand;
	level.callbackPlayerDamage = ::callbackPlayerDamage;
	level.player_out_of_playable_area_monitor = 0;
	level.custom_gunlist_upgraded = array("ak74u_upgraded_zm","mp5k_upgraded_zm","qcw05_upgraded_zm","m14_upgraded_zm","m16_upgraded_zm","saritch_upgraded_zm","xm8_upgraded_zm","type95_upgraded_zm","tar21_upgraded_zm","870mcs_upgraded_zm","rottweil72_upgraded_zm","saiga12_upgraded_zm","srm1216_upgraded_zm","galil_upgraded_zm","fnfal_upgraded_zm","rpd_upgraded_zm","hamr_upgraded_zm","dsr50_upgraded_zm","barretm82_upgraded_zm","m1911_upgraded_zm","python_upgraded_zm","judge_upgraded_zm","kard_upgraded_zm","fiveseven_upgraded_zm","beretta93r_upgraded_zm","fivesevendw_upgraded_zm","usrpg_upgraded_zm","m32_upgraded_zm","ray_gun_upgraded_zm","knife_ballistic_upgraded_zm","raygun_mark2_upgraded_zm");
	level.custom_gunlist = array("ak74u_zm","mp5k_zm","qcw05_zm","m14_zm","m16_zm","saritch_zm","xm8_zm","type95_zm","tar21_zm","870mcs_zm","rottweil72_zm","saiga12_zm","srm1216_zm","galil_zm","fnfal_zm","rpd_zm","hamr_zm","dsr50_zm","barretm82_zm","m1911_zm","python_zm","judge_zm","kard_zm","fiveseven_zm","beretta93r_zm","fivesevendw_zm","usrpg_zm","m32_zm","ray_gun_zm","knife_ballistic_zm","raygun_mark2_zm");

	level.perk_purchase_limit = 6;
	level.papprice = 5000;
	level.juggprice = 2500;
	level.doubletapcost = 2000;
	level.squickrevivecost = 500;
	level.tombcost = 2000;
	level.stupcost = 2000;
    level.phdcost = 2000;
    level.DDprice = 2500;
    level.VTprice = 2500;
    level.cherrycost = 2000;
	
	init_barriers_for_custom_maps();

	include_zombie_powerup("unlimited_ammo");
   	add_zombie_powerup("unlimited_ammo", "T6_WPN_AR_GALIL_WORLD", &"ZOMBIE_POWERUP_UNLIMITED_AMMO", ::func_should_always_drop, 0, 0, 0);
	powerup_set_can_pick_up_in_last_stand("unlimited_ammo", 1);

	include_zombie_powerup("zombie_cash"); //POWERUP_ONLY_AFFECTS_GRABBER not working on plutonium
   	add_zombie_powerup("zombie_cash", "zombie_z_money_icon", &"ZOMBIE_POWERUP_ZOMBIE_CASH", ::func_should_always_drop, 0, 0, 0); //
	powerup_set_can_pick_up_in_last_stand("zombie_cash", 1);

	precachemodel( "p6_zm_screecher_hole" );
    precachemodel( "p_cub_door01_wood_fullsize" );
    precachemodel( "p_rus_door_white_window_plain_left" );
	precachemodel( "zombie_vending_jugg_on" );
	precachemodel( "zombie_vending_revive_on" );
	precachemodel( "zombie_vending_sleight_on" );
	precachemodel( "zombie_vending_tombstone_on" );
	precachemodel( "zombie_vending_three_gun_on" );
	precacheshader( "zom_icon_minigun" );
	precacheshader( "hud_icon_colt" );
	precacheshader( "zm_hud_icon_hatch" );
	precacheshader( "hud_grenadeicon" );
	precacheshader( "menu_mp_weapons_1911" );
	precachemodel( "zombie_vending_marathon_on" );
	precachemodel( "zombie_vending_doubletap2_on" );
	precachemodel( "zombie_pickup_perk_bottle" );
	precachemodel( "zm_collision_perks1" );
	precachemodel( "p6_anim_zm_buildable_pap_on" );
	precachemodel( "collision_player_wall_512x512x10" );
	precachemodel( "collision_physics_512x512x10" );
	precachemodel( "collision_player_wall_256x256x10" );
	precacheshader( "damage_feedback" );
	precachemodel( "t5_foliage_tree_burnt03" );
	precachemodel( "collision_geo_256x256x10_standard" );
	precachemodel( "zombie_teddybear" );
	precachemodel( "zombie_perk_bottle_jugg" );
	precachemodel( "veh_t6_civ_bus_zombie" );
	precachemodel( "p6_zm_keycard" );
	precachemodel( "veh_t6_civ_bus_zombie_roof_hatch" );
	precachemodel( "zombie_z_money_icon" );
	precachemodel( "veh_t6_civ_movingtrk_cab_dead" );
}

setDvars()
{

	setdvar( "party_connectToOthers", "0" );
	setdvar( "partyMigrate_disabled", "1" );
	setdvar( "party_mergingEnabled", "0" );
	setdvar( "party_iamhost", "1" );
	setdvar( "party_host", "1" );
	setdvar( "allowAllNAT", "1" );
	setdvar( "magic_chest_movable", "0" );
	setDvar( "scr_screecher_ignore_player", 1 );
}

onPlayerConnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread onPlayerSpawned();														
        player thread visuals();
		setdvar( "ui_errorMessage", "^9Thank you for playing this Custom Survival Map");
		setdvar( "ui_errorTitle", "^1Diner" );

    }
}

visuals()
{
	self setClientDvar("r_fog", 0);
	self setClientDvar("r_dof_enable", 0);
	self setClientDvar("r_lodBiasRigid", -1000);
	self setClientDvar("r_lodBiasSkinned", -1000);
	self setClientDvar("r_lodScaleRigid", 1);
	self setClientDvar("r_lodScaleSkinned", 1);
	self useservervisionset(1);
	self setvisionsetforplayer("remote_mortar_enhanced", 0);
}

onPlayerSpawned()
{
	self endon( "disconnect" );
	level endon( "game_ended" );
	for(;;)
	{
		self waittill( "spawned_player" );
		if( getdvar( "mapname" ) == "zm_transit" && getdvar ( "g_gametype")  == "zclassic" )
		{
			if(self.isFirstSpawn==true)
			{
				self.is_custom_round = 0;
				self.isFirstSpawn = false;
                self thread removeperkshader();
				if(self isHost())
				{
					self thread welcome_message();
					self thread playfx(); 
					self thread busmaxspeed(); //
					self thread map();
                    if(isDefined(level._zombiemode_powerup_grab))
                    {
        			    level.original_zombiemode_powerup_grab = level._zombiemode_powerup_grab;
                    }
				    level._zombiemode_powerup_grab = ::custom_powerup_grab;

				}
				self thread damagehitmarker();
				level thread OnGameEndedHint( self );
				self.score = 1000000;
    			level thread turnonpower();
				self thread printorigin();
				self thread test_the_powerup();
				self thread custom_round_monitor();
			}
			self thread SpawnPoint();
			self thread enable_aim_assist();
            //self thread tNoclip();
        self giveperk("PHD_FLOPPER");

		}
		else 
		{
			flag_wait( "start_zombie_round_logic" );
			wait 1;
			self iprintln( "^1Error! Please play in Tranzit Normal Mode." );
		}
	}
}

printorigin()
{
	self endon( "stoporigin" );
	for(;;)
	{
	wait 1;
	self iprintlnbold( self.origin );
	}

}

callbackPlayerDamage( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime, boneindex )
{
	if(self.is_custom_round) 
	{
		if(level.round_number > 6)
		{
  			if( isDefined( eAttacker.is_zombie ) && eAttacker.is_zombie )
			{
				maps\mp\_visionset_mgr::vsmgr_activate("overlay", "zm_ai_avogadro_electrified", self, 1, 1);
				self shellshock( "electrocution", 1 );
				self playsoundtoplayer( "zmb_avogadro_electrified", self );
				self dodamage( 10, self.origin);
			}
		}
		else
		{
			if( isDefined( eAttacker.is_zombie ) && eAttacker.is_zombie )
			{
				maps\mp\_visionset_mgr::vsmgr_activate("overlay", "zm_ai_avogadro_electrified", self, 1, 1);
				self shellshock( "electrocution", 1 );
				self playsoundtoplayer( "zmb_avogadro_electrified", self );
				//self dodamage( 5, self.origin); might be too much damage in early custom rounds because no one has jugg
			}
		}
	}
	if ( isDefined( eattacker ) && isplayer( eattacker ) && eattacker.sessionteam == self.sessionteam && !eattacker hasperk( "specialty_noname" ) && isDefined( self.is_zombie ) && !self.is_zombie )
	{
		self process_friendly_fire_callbacks( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime, boneindex );
		if ( self != eattacker )
		{
			return;
		}
		else if ( smeansofdeath != "MOD_GRENADE_SPLASH" && smeansofdeath != "MOD_GRENADE" && smeansofdeath != "MOD_EXPLOSIVE" && smeansofdeath != "MOD_PROJECTILE" && smeansofdeath != "MOD_PROJECTILE_SPLASH" && smeansofdeath != "MOD_BURNED" && smeansofdeath != "MOD_SUICIDE" )
		{
			return;
		}
	}
	if ( is_true( level.pers_upgrade_insta_kill ) )
	{
		self maps/mp/zombies/_zm_pers_upgrades_functions::pers_insta_kill_melee_swipe( smeansofdeath, eattacker );
	}
	if ( isDefined( self.overrideplayerdamage ) )
	{
		idamage = self [[ self.overrideplayerdamage ]]( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime );
	}
	else if ( isDefined( level.overrideplayerdamage ) )
	{
		idamage = self [[ level.overrideplayerdamage ]]( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime );
	}
	if ( is_true( self.magic_bullet_shield ) )
	{
		maxhealth = self.maxhealth;
		self.health += idamage;
		self.maxhealth = maxhealth;
	}
	if ( isDefined( self.divetoprone ) && self.divetoprone == 1 )
	{
		if ( smeansofdeath == "MOD_GRENADE_SPLASH" )
		{
			dist = distance2d( vpoint, self.origin );
			if ( dist > 32 )
			{
				dot_product = vectordot( anglesToForward( self.angles ), vdir );
				if ( dot_product > 0 )
				{
					idamage = int( idamage * 0.5 );
				}
			}
		}
	}
	if ( isDefined( level.prevent_player_damage ) )
	{
		if ( self [[ level.prevent_player_damage ]]( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime ) )
		{
			return;
		}
	}
	idflags |= level.idflags_no_knockback;
	if ( idamage > 0 && shitloc == "riotshield" )
	{
		shitloc = "torso_upper";
	}
	self finishplayerdamagewrapper( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime, boneindex );
}

finishplayerdamagewrapper( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime, boneindex ) 
{
	self finishplayerdamage( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime, boneindex );
}

//----------CUSTOM_ROUNDS-------------------------------------------------------------------------------------------------------------------------------------------------

/*kill_crawlers() //unable to see minion crawlers most of the time so we have to kill them
{
	self endon( "disconnect" );
	self endon("custom_round_over");
	for(;;)
	{
		wait 5;
		foreach( zombie in getaiarray( level.zombie_team ) )
		{
			if( zombie.has_legs == 0 )
			{
				//self dodamage( self.maxhealth * 9, self.origin, (0, 0, 0) self, self, "none", "MOD_SUICIDE" );
				iprintlnbold("NO LEGS");
			}
		}
		wait 0.1;
	}
}*/

/*kill_outsiders() //some may get stuck outside windows kill them to end round faster
{
	self endon( "disconnect" );
	self endon("custom_round_over");
    wait 10;
	for(;;)
	{
		zomb = getaiarray( level.zombie_team );
		if( zomb.size < 3 )
		{
			//self dodamage( self.maxhealth * 9, self.origin, (0, 0, 0) self, self, "none", "MOD_SUICIDE" );
        }
	wait 0.1;
	}
}*/

custom_round_monitor()
{
	self endon("disconnect");
	self endon("game_ended");
	customround = level.round_number + 4; //randomintrange( 4, 6 );
	for(;;)
	{
		if( level.round_number == customround ) 
		{
			self.is_custom_round = 1;
			self thread voice(); 
			self thread remodel_zombie();
			self thread speed();
			self thread powerupdrop();
			wait 10;
			//self thread kill_crawlers(); untested
            //self thread kill_outsiders(); untested
			break;
		}
	wait 0.5;
	}
}

voice()
{
	wait 12;
	self thread playleaderdialogonplayer( "dogstart", self.team, 5 );
}

remodel_zombie()
{
	self endon("disconnect");
	self endon("custom_round_over");
	while(1)
	{
		foreach( zombie in getAiArray(level.zombie_team) )
		if(!isDefined(zombie.remodeled)) 
		{
			zombie setModel( "c_zom_screecher_fb" );
		}
	wait 0.01;
	}
}

speed() 
{
	self endon("disconnect");
	self endon("custom_round_over");
	while(1)
	{
		zombies = getAiArray(level.zombie_team);
		foreach(zombie in zombies)
		zombie maps/mp/zombies/_zm_utility::set_zombie_run_cycle( "super_sprint" ); //"walk" "run" "sprint" "super_sprint"
	wait 0.5;
	}
}

powerupdrop()
{
	self endon("disconnect");
	self endon("custom_round_over");
	wait 20;
	for(;;)
	{	
		zomb = getaiarray( level.zombie_team );
		if( zomb.size == 1 )
		{
			
			zomb specific_powerup_drop("full_ammo", self.origin);
			self thread endcustom();
			break;
		}	
	wait 1;
	}
}

endcustom()
{
	flag_wait( "start_zombie_round_logic" );
	self notify("custom_round_over");
	self.is_custom_round = 0;
	wait 2;
	self thread custom_round_monitor();
}

//--END-----CUSTOM_ROUNDS-------------------------------------------------------------------------------------------------------------------------------------------------

damagehitmarker()
{
	self thread waitdamage();
	hitmarker = newDamageIndicatorHudElem(self);
	hitmarker.horzAlign = "center";
	hitmarker.vertAlign = "middle";
	hitmarker.x = -12;
	hitmarker.y = -12;
	hitmarker.alpha = 0;
	hitmarker setShader("damage_feedback", 24, 48);
	while(level._hitmarkers)
	{	
		self waittill("HitTarget_hma");
		hitmarker.alpha = 1;
		hitmarker fadeOverTime(1);
		hitmarker.alpha = 0;
	}
	hitmarker destroy();
}

waitdamage()
{
	while(level.hitmarkers)
	{
		foreach( zombie in getAiArray(level.zombie_team))
			if(!isDefined(zombie.waitingfordamage))
				zombie thread recap();
		wait .25;
	}
}

recap()
{
	self.waitingfordamage = true;
	while(level.hitmarkers && isAlive(self))
	{
		self waittill( "damage", amount, attacker, dir, point, mod );
		if(isPlayer(attacker))
			attacker notify("HitTarget_hma");
	}
}

welcome_message()
{
	flag_wait( "start_zombie_round_logic" );
	wait 1;
	self iprintln( "^7Diner - Survival" );
}

SpawnPoint()
{
	player = level.players;
	if( player[ 0] == self )
	{
		player[ 0] setorigin( ( -4963.28, -7402, -62.5062 ) );
	}
	if( player[ 1] == self )
	{
		player[ 1] setorigin( ( -4993.28, -7402, -62.5062 ) );
	}
	if( player[ 2] == self )
	{
		player[ 2] setorigin( ( -4933.28, -7402, -62.5062 ) );
	}
	if( player[ 3] == self )
	{
		player[ 3] setorigin( ( -4903.28, -7402, -62.5062 ) );
	}

}

/*giveweapons2( weap )
{
	self giveweapon( weap );
	self switchtoweapon( weap );
    self givemaxammo( weap );

}*/

turnonpower()
{
	self maps\mp\zombies\_zm_game_module::turn_power_on_and_open_doors();
}

busmaxspeed()
{
	wait 10;
	foreach( d in level.the_bus.destinations )
	{
		d.busspeedleaving = 2500;
	}
	level.the_bus setvehmaxspeed( 2500 );
	level.the_bus setspeed( 2500, 15 );
	level.the_bus.targetspeed = 2500;
	self thread removebus();
	self thread entityremover();

}

removebus()
{
	self endon( "Stopendbuss" );
	while( 1 )
	{
		bus = getent( "the_bus", "targetname" );
		if( IsDefined( level.the_bus.ismoving ) && IsDefined( bus ) )
		{
			bus.disabled_by_emp = 1;
			bus notify( "power_off" );
			bus.pre_disabled_by_emp = 1;
			bus notify( "pre_power_off" );
			bus.ismoving = 0;
			bus.isstopping = 0;
			bus.exceed_chase_speed = 0;
			bus notify( "stopping" );
			bus.targetspeed = 0;
			bus delete();
			self notify( "Stopendbuss" );
		}
		wait 0.2;
	}

}

entityremover()
{
	
	wait 10;
	ents = getentarray();
	model = strtok( "veh_t6_civ_bus_zombie_cow_catcher,veh_t6_civ_bus_zombie_roof_hatch", "," );
	index = 0; 
	while( index < ents.size )
	{
		foreach( x in model )
		{
			if( IsDefined( ents[ index] ) && x == ents[ index].model )
			{
				ents[ index] delete();
			}
		}
		index++;
	}
	wait 5;
}

setSafeText( text )
{
	level.result = level.result + 1;
	self settext( text );
	level notify( "textset" );

}

ZombieCount()
{
Zombies=getAIArray("axis");
return Zombies.size-1;
}
drawZombiesCounter()
{
    level endon("disconnect");
    level.zombiesCountDisplay = createServerFontString("Objective" , 1.7);
    level.zombiesCountDisplay setPoint("RIGHT", "TOP", 315, "RIGHT");
    level.zombiesCountDisplay setSafeText("^9Zombies: " + ZombieCount());

    oldZombiesCount = ZombieCount();
    while(true)
    {
        if(oldZombiesCount !=  ZombieCount())
        {
            level.zombiesCountDisplay setSafeText("^9Zombies: " + ZombieCount());
        }
        wait 0.05;
    }
}

shootable(origin, angles)
{
	shotable = spawn( "script_model", origin );
	shotable setmodel( "zombie_teddybear" );
	shotable.angles = ( angles );
	shotable.health = 5;
	shotable setcandamage( 1 );
	shotable thread teddys();
}

teddys()
{
	self endon( "shot" );
	level.teddysNeeded = 10;
	level.teddysCollected = 0;
	while( 1 )
	{
		self waittill( "damage", idamage, attacker, idflags, vpoint, type, victim, vdir, shitloc, psoffsettime, sweapon );
		if( self.health <= 0 )
		{
			level.teddysCollected++;
			iprintlnbold("Teddys [" + level.teddysCollected + "/10]");
			self playsound("mus_raygun_stinger");
			self delete();
			if (level.teddysCollected >= level.teddysNeeded)
			{
				self thread maps/mp/zombies/_zm_audio_announcer::leaderdialog( "boxmove" );
				wait 2;
				iprintlnbold("^9Rooftop Opened");
                buildbuildable( "dinerhatch", 1 );

                //add something to roof
                collision( "script_model", ( -5825.36, -7894.4, 224.628 ), "zombie_vending_tombstone_on", ( 0, 90, 0 ), "PHD" );
                collision( "script_model", ( -6156.36, -7852.4, 224.628 ), "zombie_vending_tombstone_on", ( 0, 180, 0 ), "DD" );
                collision( "script_model", ( -6354.36, -7800.4, 227.628 ), "zombie_vending_tombstone_on", ( 0, 180, 0 ), "VT" );
			}
			self notify( "shot" );

		}
		wait 0.1;
	}

}

map()
{
	collision( "script_model", ( -4590.28, -7539, -62.5062 ), "zombie_vending_jugg_on", ( 0, 270, 0 ), "jugg" ); 
	collision( "script_model", ( -4173.1, -7750.29, -62.5062 ), "zombie_vending_doubletap2_on", ( 0, 270, 0 ), "DTP" );
	collision( "script_model", ( -5050.28, -7788, -62.5062 ), "zombie_vending_revive_on", ( 0, 180, 0 ), "revive" );
	collision( "script_model", ( -6500.28, -7930, 0.5062 ), "zombie_vending_marathon_on", ( 0, 90, 0 ), "marathon" );
	collision( "script_model", ( -3810.1, -7220, -59.5062 ), "zombie_vending_tombstone_on", ( 0, 270, 0 ), "tomb" );
	noncollision( "script_model", ( -6415.28, -6850, 5.5062 ), "veh_t6_civ_movingtrk_cab_dead", ( 0, 280, 0 ), "truck" );
    collision( "script_model", ( -5151.1, -5410, -63.875 ), "zombie_vending_tombstone_on", ( 0, -45, 0 ), "cherry" );

	spawnpap( ( 0, 315, 0 ) );
	pile_of_emp( "emp_grenade_zm", ( -4758.28, -7777.5, -18.062 ), ( 0, 15, 90 ));
	wallweapons( "emp_grenade_zm", ( -4758.28, -7782, -16.162 ), ( 0, 45, 0 ), 750 );
	wallweapons( "cymbal_monkey_zm", ( -4760.28, -7860, -20.162 ), ( 0, 290, 0 ), 750 );
	wallweapons( "claymore_zm", ( -5150.28, -7808, -11.162 ), ( 90, 45, 0 ), 1000 );
    wallweapons2( "bowie_knife_zm", ( -5439.01, -7773, -13.002 ), ( 0, 225, 0 ), 3000 );

    shootable( ( -4690.28, -7282, -63.5062 ), (0, 180, 0) );
    shootable( ( -5305.28, -6550, -35.5062 ), (0, -35, 0) ); 
    shootable( ( -5371.28, -7379, 300 ), (0, 80, 0) );
    shootable( ( -4180.28, -7904, -12), (0, 180, 0) );
    shootable( ( -6248.28, -7748, 148 ), (0, 0, 0) );
    shootable( ( -5582.28, -5334, 79.125 ), (0, 20, 0) );
    shootable( ( -4268.28, -6250, -41.1398 ), (0, 90, 0) );
    shootable( ( -3732.28, -7473, -58.875 ), (0, 60, 0) );
    shootable( ( -6338.28, -7590, 221.915 ), (0, 60, 0) );
    shootable( ( -3810.28, -7443, 98.915 ), (0, 180, 0) );
}

init_barriers_for_custom_maps()
{
	dinerclip2 = spawn("script_model", (-3890.1, -6650, -59.5062));
	dinerclip2 setModel("collision_player_wall_512x512x10");
	dinerclip2 rotateTo((0, 280, 0), .1);

	dinerclip3 = spawn("script_model", (-6315.28, -7040, -50.5062 ));
	dinerclip3 setModel("collision_player_wall_512x512x10");
	dinerclip3 rotateTo((0, 280, 0), .1);

	dinerclip4 = spawn("script_model", (-3870.1, -7050, -50.5062));
	dinerclip4 setModel("t5_foliage_tree_burnt03");
	dinerclip4 rotateTo((-75, 270, 0), .1);
	x = spawn("script_model", (-3870.1, -7050, -50.5062));
	x setmodel( "zm_collision_perks1" );
	x rotateTo((-75, 270, 0), .1);
}

playfx()
{
	playfx(loadfx( "misc/fx_zombie_cola_jugg_on"), ( -4590.28, -7539, -62.5062 ), anglestoforward( ( 0, 270, 0 ) ) );
	playfx(loadfx( "misc/fx_zombie_cola_dtap_on"), ( -4173.1, -7750.29, -62.5062 ), anglestoforward( ( 0, 270, 0 ) ) );
	playfx(loadfx( "misc/fx_zombie_cola_revive_on"), ( -5050.28, -7788, -62.5062 ), anglestoforward( ( 0, 180, 0 ) ) ); 
	playfx(loadfx( "maps/zombie/fx_zmb_cola_staminup_on"), ( -6500.28, -7930, 0.5062 ), anglestoforward( ( 0, 90, 0 ) ) );
	playfx(loadfx( "maps/zombie/fx_zmb_wall_buy_claymore"), ( -5150.28, -7808, -15.892 ), anglestoforward( ( 0, 0, 0  ) ) );
	playfx(loadfx( "maps/zombie/fx_zmb_wall_buy_claymore"), ( -4762, -7782.5, -30.062 ), anglestoforward( ( 0, -45, 0  ) ) );
	playfx(loadfx( "maps/zombie/fx_zmb_wall_buy_claymore"), ( -4755.28, -7860, -31.162 ), anglestoforward( ( 0, -90, 0  ) ) );
	playfx(loadfx( "maps/zombie/fx_zmb_wall_buy_bowie"), ( -5439.01, -7781, -13.5062 ), anglestoforward( ( 0, 270, 0 ) ) );
}

collision( script, pos, model, angles, type )
{
	col = spawn( script, pos );
	col setmodel( model );
	col.angles = angles;
	x = spawn( script, pos );
	x setmodel( "zm_collision_perks1" );
	x.angles = angles;
	if( type == "DTP" )
	{
		col thread perksdtp();
	}
	if( type == "jugg" )
	{
		col thread perksjuggernog();
	}
	if( type == "revive" )
	{
		col thread perksquickr();
	}
	if( type == "marathon")
	{
		col thread perksmarathon();
	}
	if( type == "tomb" )
	{
		col thread perkstomb();
	}
    if( type == "PHD" )
    {
        col thread PHD_Flopper();
    }
    if( type == "DD" )
	{
		col thread DownersD();
	}
    if( type == "VT" )
	{
		col thread VictoriousT();
	}
    if( type == "cherry" )
	{
		col thread echerry();
	}
}

buildbuildable( buildable, craft ) //credit to Jbleezy for this function
{
	if ( !isDefined( craft ) )
	{
		craft = 0;
	}
	player = get_players()[ 0 ];
	foreach ( stub in level.buildable_stubs )
	{
		if ( !isDefined( buildable ) || stub.equipname == buildable )
		{
			if ( isDefined( buildable ) || stub.persistent != 3 )
			{
				if (craft)
				{
					stub maps/mp/zombies/_zm_buildables::buildablestub_finish_build( player );
					stub maps/mp/zombies/_zm_buildables::buildablestub_remove();
					stub.model notsolid();
					stub.model show();
				}

				i = 0;
				foreach ( piece in stub.buildablezone.pieces )
				{
					piece maps/mp/zombies/_zm_buildables::piece_unspawn();
					if ( !craft && i > 0 )
					{
						stub.buildablezone maps/mp/zombies/_zm_buildables::buildable_set_piece_built( piece );
					}
					i++;
				}
				return;
			}
		}
	}
}

noncollision( script, pos, model, angles, type )
{
	noncol = spawn( "script_model", pos );
	noncol setmodel( model );
	noncol.angles = angles;
	
}

perksdtp()
{
	while( 1 )
	{
		foreach( player in level.players )
		{
			if( !(level.in_use) )
			{
				if( distance( self.origin, player.origin ) <= 60 ) 
				{
					player thread machine_hint("Hold [{+usereload}] For Douple Tap [Cost : 2000] ");
										
					if( player usebuttonpressed() && !(player hasperk( "specialty_rof" )) && (player.score >= level.doubletapcost) && !(self.lock))
					{
						level.in_use = 1;
						self.lock = 1;
						player playsound( "zmb_cha_ching" );
						player.score -= level.doubletapcost;
						player playsound ( "mus_perks_doubletap_sting" );
						player thread DoGivePerk("specialty_rof");
						wait 3;
						self.lock = 0;
						level.in_use = 0;
					}
					else if(player usebuttonpressed() && player.score < level.doubletapcost)
					{
						player maps/mp/zombies/_zm_audio::create_and_play_dialog( "general", "perk_deny", undefined, 0 );
					}
				}
			}
		}
		wait 0.1;
	}

}

perksjuggernog()
{
	while( 1 )
	{
		foreach( player in level.players )
		{
			if( !(level.in_use) )
			{
				if( distance( self.origin, player.origin ) <= 60 ) 
				{
					player thread machine_hint("Hold [{+usereload}] For Jugger-Nog [Cost : 2500] ");
					
					if( player usebuttonpressed() && !(player hasperk( "specialty_armorvest" )) && ( player.score >= level.juggprice ) && !(self.lock ))
					{
						level.in_use = 1;
						self.lock = 1;
						player playsound( "zmb_cha_ching" );
						player.score -= level.juggprice;
						player playsound ( "mus_perks_jugganog_sting" );
						player thread DoGivePerk("specialty_armorvest");
						wait 3;
						self.lock = 0;
						level.in_use = 0;
					}
					else if(player usebuttonpressed() && player.score < level.juggprice)
					{
						player maps/mp/zombies/_zm_audio::create_and_play_dialog( "general", "perk_deny", undefined, 0 );
					}
				}
			}
		}
		wait 0.1;
	}

}

perksquickr()
{
	while( 1 )
	{
		foreach( player in level.players )
		{
			if( !(level.in_use) )
			{
				if( distance( self.origin, player.origin ) <= 60 ) 
				{
					player thread machine_hint( "Hold [{+usereload}] For Quick Revive [Cost : 500] " );

					if( player usebuttonpressed() && !(player hasperk( "specialty_quickrevive" )) && (player.score >= level.squickrevivecost) && !(self.lock )) 
					{
						level.in_use = 1;
						self.lock = 1;
						player playsound( "zmb_cha_ching" );
						player.score -= level.squickrevivecost;
						player playsound ( "mus_perks_revive_sting" );
						player thread DoGivePerk("specialty_quickrevive");
						wait 3;
						self.lock = 0;
						level.in_use = 0;
					}
					else if(player usebuttonpressed() && player.score < level.squickrevivecost)
					{
						player maps/mp/zombies/_zm_audio::create_and_play_dialog( "general", "perk_deny", undefined, 0 );
					}
				}

			}
		}
		wait 0.1;
	}

}

perksmarathon()
{
	while( 1 )
	{
		foreach( player in level.players )
		{
			if( !(level.in_use) )
			{
				if( distance( self.origin, player.origin ) <= 60 ) 
				{
					player thread machine_hint("Hold [{+usereload}] For Stamina-Up [Cost : 2000] ");
										
					if( player usebuttonpressed() && !(player hasperk( "specialty_longersprint" )) && ( player.score >= level.stupcost ) && !(self.lock) )
					{
						level.in_use = 1;
						self.lock = 1;
						player playsound( "zmb_cha_ching" );
						player.score -= level.stupcost;
						player playsound ( "mus_perks_stamin_jingle" );
						player thread DoGivePerk("specialty_longersprint");
						wait 3;
						self.lock = 0;
						level.in_use = 0;
					}
					else if(player usebuttonpressed() && player.score < level.stupcost)
					{
						player maps/mp/zombies/_zm_audio::create_and_play_dialog( "general", "perk_deny", undefined, 0 );
					}
				}
			}
		}
		wait 0.1;
	}

}

perkstomb()
{
	while( 1 )
	{
		foreach( player in level.players )
		{
			if( !(level.in_use) )
			{
				if( distance( self.origin, player.origin ) <= 60 )
				{	
					player thread machine_hint("Hold [{+usereload}] For Tombstone [Cost : 2000] ");
					if( player usebuttonpressed() && !(player hasperk( "specialty_scavenger" )) && ( player.score >= level.tombcost ) && !(self.lock) ) 
					{
						level.in_use = 1;
						self.lock = 1;
						player playsound( "zmb_cha_ching" );
						player.score -= level.tombcost;
						player playsound ( "mus_perks_tombstone_sting" );
						player thread DoGivePerk("specialty_scavenger");
						wait 3;
						self.lock = 0;
						level.in_use = 0;
						player notify("tomb");
					}
					else if(player usebuttonpressed() && player.score < level.tombcost)
					{
						player maps/mp/zombies/_zm_audio::create_and_play_dialog( "general", "perk_deny", undefined, 0 );
					}
				}
			}
		}
		wait 0.1;
	}

}

PHD_Flopper()
{
	while( 1 )
	{
		foreach( player in level.players )
		{
			if( !(level.in_use) )
			{
				if( distance( self.origin, player.origin ) <= 60 ) 
				{
					player thread machine_hint( "Hold [{+usereload}] For PHD Flopper [Cost : 2000] " );

					if( player usebuttonpressed() && !(player.hasphd) && ( player.score >= level.phdcost ) && !(self.lock))
					{
						player.hasphd = 1;
						level.in_use = 1;
						self.lock = 1;
						player playsound( "zmb_cha_ching" );
						player.score -= level.phdcost;
						player playsound ( "mus_perks_packa_sting" );
						player thread giveperk("PHD_FLOPPER");
						wait 3;
						self.lock = 0;
						level.in_use = 0;
					}
					else if(player usebuttonpressed() && player.score < level.phdcost)
					{
						player maps/mp/zombies/_zm_audio::create_and_play_dialog( "general", "perk_deny", undefined, 0 );
					}
				}
			}
		}
		wait 0.1;
	}

}

DownersD()
{
	while( 1 )
	{
		foreach( player in level.players )
		{
			if( !(level.in_use) )
			{
				if( distance( self.origin, player.origin ) <= 60 ) 
				{
					player thread machine_hint( "Hold [{+usereload}] For Downer's Delight [Cost : 2500] " );

					if( player usebuttonpressed() && !(player.hasDD) && ( player.score >= level.DDprice ) && !(self.lock))
					{
						player.hasDD = 1;
						level.in_use = 1;
						self.lock = 1;
						player playsound( "zmb_cha_ching" );
						player.score -= level.DDprice;
						player playsound ( "mus_perks_doubletap_sting" ); 
						player thread giveperk( "Downers_Delight" );
						wait 3;
						self.lock = 0;
						level.in_use = 0;
					}
					else if(player usebuttonpressed() && player.score < level.DDprice)
					{
						player maps/mp/zombies/_zm_audio::create_and_play_dialog( "general", "perk_deny", undefined, 0 );
					}
				}
			}
		}
		wait 0.1;
	}
}

VictoriousT()
{
	while( 1 )
	{
		foreach( player in level.players )
		{
			if( !(level.in_use) )
			{
				if( distance( self.origin, player.origin ) <= 60 ) 
				{
					player thread machine_hint( "Hold [{+usereload}] For Victorious Tortoise [Cost : 2500] " );

					if( player usebuttonpressed() && !(player.hasVT) && ( player.score >= level.VTprice ) && !(self.lock))
					{
						player.hasVT = 1;
						level.in_use = 1;
						self.lock = 1;
						player playsound( "zmb_cha_ching" );
						player.score -= level.VTprice;
						player playsound ( "mus_perks_doubletap_sting" ); 
						player thread giveperk( "Victorious_Tortoise" );
						wait 3;
						self.lock = 0;
						level.in_use = 0;
					}
					else if(player usebuttonpressed() && player.score < level.VTprice)
					{
						player maps/mp/zombies/_zm_audio::create_and_play_dialog( "general", "perk_deny", undefined, 0 );
					}
				}
			}
		}
		wait 0.1;
	}

}

echerry()
{
	while( 1 )
	{
		foreach( player in level.players )
		{
			if( !(level.in_use) )
			{
				if( distance( self.origin, player.origin ) <= 60 ) 
				{
					player thread machine_hint( "Hold [{+usereload}] For Electric Cherry [Cost : 2000] " );

					if( player usebuttonpressed() && !(player.hascherry) && ( player.score >= level.cherrycost ) && !(self.lock))
					{
						player.hascherry = 1;
						level.in_use = 1;
						self.lock = 1;
						player playsound( "zmb_cha_ching" );
						player.score -= level.cherrycost;
						player playsound ( "mus_perks_packa_sting" );
						player thread giveperk("ELECTRIC_CHERRY");
						wait 3;
						self.lock = 0;
						level.in_use = 0;
					}
					else if(player usebuttonpressed() && player.score < level.cherrycost)
					{
						player maps/mp/zombies/_zm_audio::create_and_play_dialog( "general", "perk_deny", undefined, 0 );
					}
				}
			}
		}
		wait 0.1;
	}

}

removeperkshader()
{
	self thread removeallperksondeath();
	for(;;)
	{
		result = self waittill_any_return( "fake_death", "death", "player_downed" );
		if( result == "player_downed" || result == "death" || result == "fake_death" )
		{
			self.icon1 destroy();
			self.icon1 = undefined;
			self.icon2 destroy();
			self.icon2 = undefined;
			self.icon3 destroy();
			self.icon3 = undefined;
			self.icon4 destroy();
			self.icon4 = undefined;
			self.icon5 destroy();
			self.icon5 = undefined;
			self.icon6 destroy();
			self.icon6 = undefined;
			self.icon7 destroy();
			self.icon7 = undefined;
			self.icon8 destroy();
			self.icon8 = undefined;
			self.icon9 destroy();
			self.icon9 = undefined;
			self.icon10 destroy();
			self.icon10 = undefined;
			self.icon11 destroy();
			self.icon11 = undefined;
			self.icon12 destroy();
			self.icon12 = undefined;
			self notify( "stopcustomperk" );
			self.hasphd = 0;
			self.hasmulekick = 0;
			self.hasww = 0;
			self.hascherry = 0;
			self.hasdeadshot = 0;
			self.hasVT = 0;
			self.hasDD = 0;
			self.hasER = 0;
			setDvar("player_lastStandBleedoutTime", 30);
			self.allmpperk = 0;
		}
	wait 0.01;
	}

}

removeallperksondeath()
{
	self endon( "disconnect" );
	while( 1 )
	{
		result = self waittill_any_return( "player_revived", "spawned_player", "disconnect", "death" );
		if( result == "death" || result == "spawned_player" || result == "player_revived" || !(isalive( self )) )
		{
			self.allmpperk = 0;
			self thread removeperksondeath( 0 );
		}
		wait 0.01;
	}

}

removeperksondeath( give )
{
	perks = strtok( "specialty_additionalprimaryweapon,specialty_delayexplosive,specialty_detectexplosive,specialty_disarmexplosive,specialty_earnmoremomentum,specialty_explosivedamage,specialty_flakjacket,specialty_flashprotection,specialty_gpsjammer,specialty_grenadepulldeath", "," ); 
	self notify("stopcustomperk");
	foreach( perk in perks )
	{
		self unsetperk( perk );
	}

}

drawshader( shader, x, y, width, height, color, alpha, sort )
{
	hud = newclienthudelem( self );
	hud.elemtype = "icon";
	hud.color = color;
	hud.alpha = alpha;
	hud.sort = sort;
	hud.children = [];
	hud setparent( level.uiparent );
	hud setshader( shader, width, height );
	hud.x = x;
	hud.y = y;
	return hud;

}

drawcustomperkhud( perk, x, color )
{
	if( !(IsDefined( self.icon1 )) )
	{
		x = -345; 
		self.icon1 = self drawshader( perk, x, 280, 24, 25, color, 100, 0 );
	}
	else
	{
		if( !(IsDefined( self.icon2 )) )
		{
			x = -315; 
			self.icon2 = self drawshader( perk, x, 280, 24, 25, color, 100, 0 );
		}
		else
		{
			if( !(IsDefined( self.icon3 )) )
			{
				x = -285;
				self.icon3 = self drawshader( perk, x, 280, 24, 25, color, 100, 0 );
			}
			else
			{
				if( !(IsDefined( self.icon4 )) )
				{
					x = -255;
					self.icon4 = self drawshader( perk, x, 280, 24, 25, color, 100, 0 );
				}
				else
				{
					if( !(IsDefined( self.icon5 )) )
					{
						x = -225;
						self.icon5 = self drawshader( perk, x, 280, 24, 25, color, 100, 0 );
					}
					else
					{
						if( !(IsDefined( self.icon6 )) )
						{
							x = -195;
							self.icon6 = self drawshader( perk, x, 280, 24, 25, color, 100, 0 );
						}
						else
						{
							if( !(IsDefined( self.icon7 )) )
							{
								x = -345;
								self.icon7 = self drawshader( perk, x, 250, 24, 25, color, 100, 0 );
							}
							else
							{
								if( !(IsDefined( self.icon8 )) )
								{
									x = -315;
									self.icon8 = self drawshader( perk, x, 250, 24, 25, color, 100, 0 );
								}
								else
								{
									if( !(IsDefined( self.icon9 )) )
									{
										x = -285;
										self.icon8 = self drawshader( perk, x, 250, 24, 25, color, 100, 0 );
									}
									else
									{
										if( !(IsDefined( self.icon10 )) )
										{
											x = -255;
											self.icon10 = self drawshader( perk, x, 250, 24, 25, color, 100, 0 );
										}
										else
										{
											if( !(IsDefined( self.icon11 )) )
											{
												x = -225;
												self.icon11 = self drawshader( perk, x, 250, 24, 25, color, 100, 0 );
											}
											else
											{
												if( !(IsDefined( self.icon12 )) )
												{
													x = -195;
													self.icon12 = self drawshader( perk, x, 250, 24, 25, color, 100, 0 );
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
}

giveperk( perk )
{
	self disableoffhandweapons();
	self disableweaponcycling();
	weapona = self getcurrentweapon();
	weaponb = "zombie_perk_bottle_tombstone";
	self giveweapon( weaponb );
	self switchtoweapon( weaponb );
	self waittill( "weapon_change_complete" );
	self enableoffhandweapons();
	self enableweaponcycling();
	self takeweapon( weaponb );
	self switchtoweapon( weapona );
	self maps/mp/zombies/_zm_audio::playerexert( "burp" );
	self setblur( 4, 0.1 );
	wait 0.1;
	self setblur( 0, 0.1 );
	if( perk == "PHD_FLOPPER" )
	{
		a = strtok( "specialty_delayexplosive,specialty_detectexplosive,specialty_disarmexplosive,specialty_earnmoremomentum,specialty_explosivedamage,specialty_flakjacket,specialty_flashprotection,specialty_gpsjammer,specialty_grenadepulldeath", "," );
		foreach( b in a )
		{
			self setperk( b );
		}
		//self thread drawcustomperkhud( "hud_grenadeicon", 0, ( 1, 0, 1 ) ); //find shader
		self thread phddive(); 
	}
    else
	{
	    if( perk == "Downers_Delight" )
		{
		    //self thread drawcustomperkhud( "menu_lobby_icon_facebook", 0, ( 0, 1, 1 ) );  //find shader
		}
        else
		{
			if( perk == "Victorious_Tortoise" )
			{
				self thread start_vt();
            	//self thread drawcustomperkhud( "menu_lobby_icon_twitter", 0, ( 0, 1, 0 ) );  //find shader
			}
            else
			{
				if( perk == "ELECTRIC_CHERRY" )
				{
					self thread start_ec(); //add zombie slowdown with less damage dealt
					//self thread drawcustomperkhud( "menu_mp_lobby_icon_film", 0, ( 0, 1, 1 ) ); //find shader
				}
            }
        }
    }
}

phddive()
{
	self endon( "disconnect" );
	level endon( "end_game" );
	self endon( "stopcustomperk" );
	for(;;)
	{
		if( self.divetoprone && IsDefined( self.divetoprone ) )
		{
			if( IsDefined( self.hasphd ) && self isonground() )
			{
				self playsound( "zmb_phdflop_explo" );
				playfx(loadfx("explosions/fx_default_explosion"), self.origin, anglestoforward( ( 0, 45, 55  ) ) ); 

				self damagezombiesinrange( 300, self, "kill" ); 
				wait 0.3;
			}
		}
	wait 0.05;
	}
}

damagezombiesinrange( range, what, amount )
{
	enemy = getaiarray( level.zombie_team );
	foreach( zombie in enemy )
	{
		if( distance( zombie.origin, what.origin ) < range )
		{
			x = randomintrange( 1000, 5000 );
			if( amount == "kill" )
			{
				zombie dodamage( x, zombie.origin, self );
			}
			else
			{
				zombie dodamage( amount, zombie.origin, self );
			}
		}
	}

}

LastStand()
{
    if(self.hasDD)
	{
        self.customlaststandweapon = self getcurrentweapon();
		self switchtoweapon( self.customlaststandweapon );
		self setweaponammoclip( self.customlaststandweapon, 150 );
		setDvar("player_lastStandBleedoutTime", 40); 
    } 
	else 
	{
        self maps/mp/zombies/_zm::last_stand_pistol_swap();
    }
}

start_vt()
{
	level endon("end_game");
	self endon("disconnect");
	self endon("stopcustomperk");
	for(;;)
	{
		if (self getcurrentweapon() == "riotshield_zm" )
		{
			self enableInvulnerability();
		}
		else
		{
			self disableInvulnerability();
		}
		wait 0.1;
	}
}

start_ec()
{
	level endon("end_game");
	self endon("disconnect");
	self endon("stopcustomperk");
	for(;;)
	{
		self waittill( "reload_start" );
        playfxontag( level._effect[ "poltergeist"], self, "J_SpineUpper" );
		self EnableInvulnerability();
		RadiusDamage(self.origin, 90, 190, 90, self);
		self DisableInvulnerability();
		self playsound( "zmb_turbine_explo" );
		wait 1;
	}
}

doGivePerk(perk)
{
	
    self endon("disconnect");
    self endon("death");
    level endon("game_ended");
    self endon("perk_abort_drinking");
    if (!(self hasperk(perk) || (self maps/mp/zombies/_zm_perks::has_perk_paused(perk))))
    {
        gun = self maps/mp/zombies/_zm_perks::perk_give_bottle_begin(perk);
        evt = self waittill_any_return("fake_death", "death", "player_downed", "weapon_change_complete");
        if (evt == "weapon_change_complete")
            self thread maps/mp/zombies/_zm_perks::wait_give_perk(perk, 1);
        self maps/mp/zombies/_zm_perks::perk_give_bottle_end(gun, perk);
        if (self maps/mp/zombies/_zm_laststand::player_is_in_laststand() || isDefined(self.intermission) && self.intermission)
            return;
        self notify("burp");
    }
}

spawnpap( angles )
{
	col = spawn( "script_model", ( -3545.1, -7220, -59.5062 ) );
	col setmodel( "p6_anim_zm_buildable_pap_on" );
	col.angles = angles;
	x = spawn( "script_model", ( -3545.1, -7220, -59.5062 ) );
	x setmodel( "zm_collision_perks1" );
	col thread papweapons( angles );

}

papweapons( angles ) // made by 2 Millimeter Nahkampfwächter 
{
    while( 1 )
    {
        foreach( player in level.players )
        {
            if( !(level.in_use) )
            {
                if( distance( self.origin, player.origin ) <= 60 ) 
                {
                    player thread machine_hint("Hold [{+usereload}] For Upgrade Weapon [Cost : 5000] ");
                    if(player usebuttonpressed() && player.score >= level.papprice && !player maps/mp/zombies/_zm_laststand::player_is_in_laststand())
					{
        				noactivate = 1;
        				currgun = player getcurrentweapon();
        				for(i = 0; i < level.custom_gunlist.size; i++)
						{
            				if(currgun == level.custom_gunlist[i])
							{
                                player takeweapon(currgun);
                                gun = player maps/mp/zombies/_zm_weapons::get_upgrade_weapon( currgun, 0 );
                                player giveweapon(player maps/mp/zombies/_zm_weapons::get_upgrade_weapon( currgun, 0 ), 0, player maps/mp/zombies/_zm_weapons::get_pack_a_punch_weapon_options(level.custom_gunlist_upgraded[i]));
                                player switchToWeapon(gun);
								noactivate = 0;
            				}
    					}
						if(noactivate)
						{
							break;
						}
						level.in_use = 1;
        				player playsound( "zmb_perks_packa_upgrade" );
						playfx(loadfx( "maps/zombie/fx_zombie_packapunch"), ( -3545.1, -7220, -48.5062 ), anglestoforward( ( 0, 45, 55  ) ) ); 
        				player.score -= level.papprice;
        				wait 3;
        				level.in_use = 0;
               		}
					else if(player usebuttonpressed() && player.score < level.papprice)
					{
						player maps/mp/zombies/_zm_audio::create_and_play_dialog( "general", "perk_deny", undefined, 0 );
					}
            	}
        	}
		}
        wait 0.1;
    }
}

wallweapons( weapon, origin, angles, cost )
{
	wallweaponx = spawnentity( "script_model", getweaponmodel( weapon ), origin, angles + ( 0, 50, 0 ) );
	wallweaponx thread wallweaponmonitorbox( weapon, cost );

}

wallweapons2( weapon, origin, angles, cost )
{
	wallweaponx = spawnentity( "script_model", getweaponmodel( weapon ), origin, angles + ( 0, 50, 0 ) );
	wallweaponx thread wallweaponmonitorbox2( weapon, cost );

}


pile_of_emp( weapon, origin, angles, cost )
{
	wallweaponx = spawnentity( "script_model", getweaponmodel( weapon ), origin, angles + ( 0, 50, 0 ) );
}

spawnentity( class, model, origin, angle )
{
	entity = spawn( class, origin );
	entity.angles = angle;
	entity setmodel( model );
	return entity;

}

wallweaponmonitorbox( weapon, cost )
{
	self endon( "game_ended" );
	self.curweap = weapon;
	self.weapx = get_weapon_display_name( self.curweap );
	self.cost = cost;
	self.lockedweap = 0;
	while( 1 )
	{
		if( self.lockedweap == 1 )
		{
			wait 3;
			self.lockedweap = 0;
		}
		foreach( player in level.players )
		{
			if( distance( self.origin, player.origin ) <= 60 )
			{
				player thread machine_hint("Hold [{+usereload}] For Buy " + ( self.weapx + ( " [Cost: " + ( self.cost + "]") ) ) );
				wait 0.3;
				if( player usebuttonpressed() && !(self.lockedweap) && player.score >= self.cost )
				{
					player playsound( "zmb_cha_ching" );
					self.lockedweap = 1;
					player.score -= self.cost;
					player thread weapon_give( self.curweap, 0, 1 );
					player iprintln( "^2" + ( self.weapx + " Buy" ) );
				}
				else
				{
					if( player usebuttonpressed() && player.score < self.cost )
					{
						player maps/mp/zombies/_zm_audio::create_and_play_dialog( "general", "no_money_weapon" );
					}
				}
			}
		}
		wait 0.1;
	}

}

wallweaponmonitorbox2( weapon, cost )
{
	self endon( "game_ended" );
	self.curweap = weapon;
	self.weapx = get_weapon_display_name( self.curweap );
	self.cost = cost;
	self.lockedweap = 0;
	while( 1 )
	{
		if( self.lockedweap == 1 )
		{
			wait 3;
			self.lockedweap = 0;
		}
		foreach( player in level.players )
		{
			if( distance( self.origin, player.origin ) <= 55 )
			{
				player thread machine_hint("Hold [{+usereload}] For Buy " + ( self.weapx + ( " [Cost: " + ( self.cost + "]") ) ) );
				wait 0.3;
				if( player usebuttonpressed() && !(self.lockedweap) && !(player.hasweapon) && player.score >= self.cost )
				{
					player.hasweapon = 1;
					player playsound( "zmb_cha_ching" );
					self.lockedweap = 1;
					player.score -= self.cost;
					player thread weapon_give( self.curweap, 0, 1 );
					player iprintln( "^2" + ( self.weapx + "Buy" ) );
				}
				else
				{
					if( player usebuttonpressed() && player.score < self.cost )
					{
						player maps/mp/zombies/_zm_audio::create_and_play_dialog( "general", "no_money_weapon" );
					}
				}
			}
		}
		wait 0.1;
	}

}

custom_powerup_grab(s_powerup, e_player)
{
	if (s_powerup.powerup_name == "zombie_cash")
	{
		level thread zombie_money();
	}
	if (s_powerup.powerup_name == "unlimited_ammo")
	{
		level thread unlimited_ammo_powerup();
	}
	else if (isDefined(level.original_zombiemode_powerup_grab))
		level thread [[level.original_zombiemode_powerup_grab]](s_powerup, e_player);
}

zombie_money()
{
	foreach( player in level.players )
	{
		iprintlnbold("Zombie Cash!");
		x = randomInt(9);
		if(x==1)
			player.score += 50;
		else if(x==2)
			player.score -= 50;
		else if(x==3)
			player.score -= 150;
		else if(x==4)
			player.score += 500;
		else if(x==5)
			player.score += 250;
		else if(x==6)
			player.score += 1000;
		else if(x==7)
			player.score += 1250;
		else if(x==8)
			player.score += 2000;
		else if(x==9)
			player.score -= 200;
		else
			player.score += 300;
	}
}

unlimited_ammo_powerup( origin, angles )
{
	foreach(player in level.players)
	{
		player notify("end_unlimited_ammo");
		player playsound("zmb_cha_ching");
		player thread startammo();
		player thread unlimited_ammo_on_hud();
		player thread endammo();
	}
}

machine_hint( text )
{
	self endon("disconnect");
	machine_hud_string = newclienthudelem(self);
	machine_hud_string.elemtype = "font";
	machine_hud_string.font = "objective";
	machine_hud_string.fontscale = 1.3;
	machine_hud_string.x = 0;
	machine_hud_string.y = 0;
	machine_hud_string.width = 0;
	machine_hud_string.height = int( level.fontheight * 2 );
	machine_hud_string.xoffset = 0;
	machine_hud_string.yoffset = 0;
	machine_hud_string.children = [];
	machine_hud_string setparent(level.uiparent);
	machine_hud_string.hidden = 0;
	machine_hud_string maps/mp/gametypes_zm/_hud_util::setpoint("TOP", undefined, 0, level.zombie_vars["zombie_timer_offset"] - (level.zombie_vars["zombie_timer_offset_interval"] * 2));
	machine_hud_string.sort = .5;
	machine_hud_string.alpha = 0;
	machine_hud_string fadeovertime(.5);
	machine_hud_string.alpha = 1;
	machine_hud_string setText( text ); 
	machine_hud_string thread machine_string();
}

machine_string()
{
	wait .5;
	self fadeovertime(0.25);
	wait 0.25;
	self destroy();
}

unlimited_ammo_on_hud()
{
	self endon("disconnect");
	unlimited_ammo_hud_string = newclienthudelem(self);
	unlimited_ammo_hud_string.elemtype = "font";
	unlimited_ammo_hud_string.font = "objective";
	unlimited_ammo_hud_string.fontscale = 2;
	unlimited_ammo_hud_string.x = 0;
	unlimited_ammo_hud_string.y = 0;
	unlimited_ammo_hud_string.width = 0;
	unlimited_ammo_hud_string.height = int( level.fontheight * 2 );
	unlimited_ammo_hud_string.xoffset = 0;
	unlimited_ammo_hud_string.yoffset = 0;
	unlimited_ammo_hud_string.children = [];
	unlimited_ammo_hud_string setparent(level.uiparent);
	unlimited_ammo_hud_string.hidden = 0;
	unlimited_ammo_hud_string maps/mp/gametypes_zm/_hud_util::setpoint("TOP", undefined, 0, level.zombie_vars["zombie_timer_offset"] - (level.zombie_vars["zombie_timer_offset_interval"] * 2));
	unlimited_ammo_hud_string.sort = .5;
	unlimited_ammo_hud_string.alpha = 0;
	unlimited_ammo_hud_string fadeovertime(.5);
	unlimited_ammo_hud_string.alpha = 1;
	unlimited_ammo_hud_string setText("Infinite Ammo!");
	unlimited_ammo_hud_string thread unlimited_ammo_hud_string_move();
	
	unlimited_ammo_hud_icon = newclienthudelem(self);
	unlimited_ammo_hud_icon.horzalign = "center";
	unlimited_ammo_hud_icon.vertalign = "bottom";
	unlimited_ammo_hud_icon.x = -75;
	unlimited_ammo_hud_icon.y = 0;
	unlimited_ammo_hud_icon.alpha = 1;
	unlimited_ammo_hud_icon.hidewheninmenu = true;   
	unlimited_ammo_hud_icon setshader("zom_icon_minigun", 30, 30);
	self thread unlimited_ammo_hud_icon_blink(unlimited_ammo_hud_icon);
	self thread destroy_unlimited_ammo_icon_hud(unlimited_ammo_hud_icon);
}

unlimited_ammo_hud_string_move()
{
	wait .5;
	self fadeovertime(1.5);
	self moveovertime(1.5);
	self.y = 270;
	self.alpha = 0;
	wait 1.5;
	self destroy();
}

unlimited_ammo_hud_icon_blink(elem)
{
	level endon("disconnect");
	self endon("disconnect");
	self endon("end_unlimited_ammo");
	time_left = level.unlimited_ammo_duration;
	for(;;)
	{
		if(time_left <= 5)
			time = .1;
		else if(time_left <= 10)
			time = .2;
		else
		{
			wait .05;
			time_left -= .05;
			continue;
		}
		elem fadeovertime(time);
		elem.alpha = 0;
		wait time;
		elem fadeovertime(time);
		elem.alpha = 1;
		wait time;
		time_left -= time * 2;
	}
}

destroy_unlimited_ammo_icon_hud(elem)
{
	level endon("game_ended");
	self waittill_any_timeout(level.unlimited_ammo_duration+1, "disconnect", "end_unlimited_ammo");
	elem destroy();
}

endammo()
{
	level endon("game_ended");
	self endon("disonnect");
	self endon("end_unlimited_ammo");
	wait 30;
	self playsound("zmb_insta_kill");
	self notify("end_unlimited_ammo");
}

startammo()
{
	level endon("game_ended");
	self endon("disonnect");
	self endon("end_unlimited_ammo");
	for(;;)
	{
	wait 0.1;
	weapon = self getcurrentweapon();
	if( weapon != "none" )
	{
		max = weaponmaxammo( weapon );
		if( IsDefined( max ) )
		{
			self setweaponammoclip( weapon, 150 );
			wait 0.02;
		}
	}
	}

}

OnGameEndedHint( player )
{
	level waittill("end_game");
	hud = player createFontString("objective", 2);
    hud setText("Thank you for playing.");
    hud.x = 0;
	hud.y = 0;
	bar.alignx = "center";
	bar.aligny = "center";
	bar.horzalign = "fullscreen";
	bar.vertalign = "fullscreen";
	hud.color = (1,1,1);
	hud.alpha = 1;
	hud.glowColor = (1,1,1);
	hud.glowAlpha = 0;
	hud.sort = 5;
	hud.archived = false;
	hud.foreground = true;
}

test_the_powerup()
{
	self endon("death");
	self endon("disconnected");
	level endon("game_ended");
	wait 15;
	self iprintlnbold("^7Press ^1[{+smoke}] ^7to test power up.");
	for(;;)
	{
		if(self secondaryoffhandbuttonpressed())
		{
			level specific_powerup_drop("zombie_cash", self.origin + VectorScale(AnglesToForward(self.angles), 70));
			return;
		}
		wait .05;
	}
}

enable_aim_assist()
{
	self endon("disconnected");
	level endon("game_ended");
	flag_wait( "start_zombie_round_logic" );
	wait 5;
	iprintlnbold("^7press ^1[{+smoke}] ^7and ^1[{+frag}] ^7to Enable/Disable controller aim assist ");
	for(;;)
	{
		if( !self.aim_on && self secondaryoffhandbuttonpressed() && self FragButtonPressed())
		{
			self.aim_on = 1;
			self setclientfieldtoplayer( "deadshot_perk", 1 );
			iprintln("^2Controller aim assist Enabled");
			wait 2;
		}
		if(self.aim_on && self secondaryoffhandbuttonpressed() && self FragButtonPressed())
		{
			self setclientfieldtoplayer( "deadshot_perk", 0 );
			iprintln("^1Controller aim assist Disabled");
			self.aim_on = 0;
			wait 2;
		}
	wait 0.05;
	}
}
//--NO CLIP-----------------------------------------------------------------------------------

tNoclip()
{
	flag_wait( "start_zombie_round_logic" );

	while(1)
	{
		self thread NoClip();
		self waittill("rechain");
		self notify("stop_noclip");
		self EnableInvulnerability();

		wait 0.1;
	}
}
_zm_arena_intersection_override(player)
{
	self waittill("forever");
	return true;
}
Noclip()
{
    self endon("stop_noclip"); 
    self.first=true; 
	normalized = undefined;
	scaled = undefined;
	originpos = undefined;
    while( 1 )
    {
        if( self fragbuttonpressed())
        {
        	if(self.first){
        	self.originObj = spawn( "script_origin", self.origin, 1 );
    		self.originObj.angles = self.angles;
        	self disableweapons();
        	self playerlinkto( self.originObj, undefined );
        	self.first=false;
        	}
            normalized = anglesToForward( self getPlayerAngles() );
            scaled = vectorScale( normalized, 50 );
            originpos = self.origin + scaled;
            self.originObj.origin = originpos;
        }
        else if(self meleeButtonPressed()&&!self.first)
        {
            self unlink();
            self enableweapons();
            self.originObj delete();
            self notify("rechain"); 
        }  
        wait .05;
    }   
}

ANoclipBind()
{
	self iprintln("^2Press [{+frag}] ^3to ^2Toggle No Clip");
	normalized = undefined;
	scaled = undefined;
	originpos = undefined;
	self unlink();
	self.originObj delete();
	while(1)
	{
		if( self fragbuttonpressed())
		{
			self.originObj = spawn( "script_origin", self.origin, 1 );
    		self.originObj.angles = self.angles;
			self playerlinkto( self.originObj, undefined );
			while( self fragbuttonpressed() )
				wait .1;
			self enableweapons();
			while( 1 )
			{
				if( self fragbuttonpressed() )
					break;
				if( self SprintButtonPressed() )
				{
					normalized = anglesToForward( self getPlayerAngles() );
					scaled = vectorScale( normalized, 60 );
					originpos = self.origin + scaled;
					self.originObj.origin = originpos;
				}
				wait .05;
			}
			self unlink();
			self.originObj delete();
			while( self fragbuttonpressed() )
				wait .1;
		}
		wait .1;
	}
}
 //-- NO-CLIP----------------------------------------------------------------------------------