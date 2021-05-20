//PLUTONIUM - Diner v1

//Huge thanks to 2 Millimeter Nahkampfwächter who helped with the project.

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
	level.unlimited_ammo_duration = 30;
	level thread drawZombiesCounter();
	level thread onPlayerConnect();
    level thread turnonpower();
	level thread setdvars();

	level.zombie_last_stand = ::LastStand;
	level.custom_vending_precaching = ::default_vending_precaching;
	register_player_damage_callback( ::playerdamagelastcheck );
	level.effect_WebFX = loadfx("misc/fx_zombie_powerup_solo_grab");
	replaceFunc("_zm_ai_avogadro", ::precache, ::stop_spawning);

    if(isDefined(level._zombiemode_powerup_grab))
    {
        level.original_zombiemode_powerup_grab = level._zombiemode_powerup_grab;
    }
	level._zombiemode_powerup_grab = ::custom_powerup_grab;

	level.player_out_of_playable_area_monitor = 0;
	level.custom_gunlist_upgraded = array("ak74u_upgraded_zm","mp5k_upgraded_zm","qcw05_upgraded_zm","m14_upgraded_zm","m16_upgraded_zm","saritch_upgraded_zm","xm8_upgraded_zm","type95_upgraded_zm","tar21_upgraded_zm","870mcs_upgraded_zm","rottweil72_upgraded_zm","saiga12_upgraded_zm","srm1216_upgraded_zm","galil_upgraded_zm","fnfal_upgraded_zm","rpd_upgraded_zm","hamr_upgraded_zm","dsr50_upgraded_zm","barretm82_upgraded_zm","m1911_upgraded_zm","python_upgraded_zm","judge_upgraded_zm","kard_upgraded_zm","fiveseven_upgraded_zm","beretta93r_upgraded_zm","fivesevendw_upgraded_zm","usrpg_upgraded_zm","m32_upgraded_zm","ray_gun_upgraded_zm","knife_ballistic_upgraded_zm","raygun_mark2_upgraded_zm","knife_ballistic_bowie_upgraded_zm");
	level.custom_gunlist = array("ak74u_zm","mp5k_zm","qcw05_zm","m14_zm","m16_zm","saritch_zm","xm8_zm","type95_zm","tar21_zm","870mcs_zm","rottweil72_zm","saiga12_zm","srm1216_zm","galil_zm","fnfal_zm","rpd_zm","hamr_zm","dsr50_zm","barretm82_zm","m1911_zm","python_zm","judge_zm","kard_zm","fiveseven_zm","beretta93r_zm","fivesevendw_zm","usrpg_zm","m32_zm","ray_gun_zm","knife_ballistic_zm","raygun_mark2_zm","knife_ballistic_bowie_zm");

	level.perk_purchase_limit = 20;
	level.papprice = 5000;
	level.juggprice = 2500;
	level.doubletapcost = 2000;
	level.squickrevivecost = 500;
    level.mquickrevivecost = 1500;
	level.tombcost = 2000;
	level.stupcost = 2000;
    level.phdcost = 2000;
    level.DDprice = 2500;
    level.VTprice = 2500;
    level.cherrycost = 2000;
	level.wwcost = 4000;
    level.ERprice = 4000;
    level.t3guncost = 4000;

	init_custom_map();

	include_zombie_powerup("death_machine");
   	add_zombie_powerup("death_machine", "zombie_teddybear", &"ZOMBIE_POWERUP_DEATH_MACHINE", ::func_should_always_drop, 1, 0, 0);
	powerup_set_can_pick_up_in_last_stand("death_machine", 1);

	include_zombie_powerup("unlimited_ammo");
   	add_zombie_powerup("unlimited_ammo", "T6_WPN_AR_GALIL_WORLD", &"ZOMBIE_POWERUP_UNLIMITED_AMMO", ::func_should_always_drop, 0, 0, 0);
	powerup_set_can_pick_up_in_last_stand("unlimited_ammo", 1);

	include_zombie_powerup("zombie_cash");
   	add_zombie_powerup("zombie_cash", "zombie_z_money_icon", &"ZOMBIE_POWERUP_ZOMBIE_CASH", ::func_should_always_drop, 1, 0, 0); 
	powerup_set_can_pick_up_in_last_stand("zombie_cash", 1);

	precachemodel( "p6_zm_screecher_hole" );
    precachemodel( "p_cub_door01_wood_fullsize" );
    precachemodel( "p_rus_door_white_window_plain_left" );
	precachemodel( "zombie_vending_jugg_on" );
	precachemodel( "zombie_vending_revive_on" );
	precachemodel( "zombie_vending_sleight_on" );
	precachemodel( "zombie_vending_tombstone_on" );
	precachemodel( "zombie_vending_three_gun_on" );
	precacheshader( "zombies_rank_1" );
	precacheshader( "zombies_rank_3" );
	precacheshader( "zombies_rank_2" );
	precacheshader( "zombies_rank_4" );
	precacheshader( "menu_mp_weapons_xm8" );
	precacheshader( "killiconheadshot" );
	precacheshader( "zombies_rank_5" );
	precacheshader( "hud_icon_sticky_grenade" );
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
	precachemodel( "veh_t6_civ_bus_zombie" );
	precachemodel( "veh_t6_civ_bus_zombie_roof_hatch" );
	precachemodel( "zombie_z_money_icon" );
	precachemodel( "veh_t6_civ_movingtrk_cab_dead" );
}

setdvars()
{
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
			if(self.is_First_Spawn)
			{
				self.is_custom_round = 0;
				self.perk_reminder = 0;
        		self.perk_count = 0;
        		self.num_perks = 0;
        		self.has_dd = 0;
        		self.has_mule = 0;
        		self.has_phd = 0;
        		self.has_tortoise = 0;
        		self.has_cherry = 0; 
        		self.has_wine = 0;
        		self.has_razor = 0;
				self thread stopbus(); 
				self thread removeperkshader();
                self thread welcome_message();
                self thread playfx();
				self thread damagehitmarker();
				self thread custom_round_monitor();
				self thread enable_aim_assist();
				level thread OnGameEndedHint(self);
				self thread displayScore();
				self.is_First_Spawn = 0;
			}
			self thread perkboughtcheck();
			self thread SpawnPoint();
            wait 1;
            self thread entityremover();
		}
		else 
		{
			flag_wait( "start_zombie_round_logic" );
			wait 1;
			self iprintln( "^1Error! Please play in Tranzit Normal Mode." );
		}
	}
}

displayScore()
{
    self endon( "disconnect" );
    level endon( "end_game" );
    self.scoreText = CreateFontString("Objective", 1.5);
    self.scoretext setPoint("CENTER", "RIGHT", "CENTER", "RIGHT");
    self.scoreText.label = &"^2Score: ^7";
    self.scoretext.alpha = 0;
    while(true)
    {
        self.scoretext SetValue(self.score);
        if(getplayers().size >= 5 && self.scoretext.alpha == 0)
        {
            self.scoretext FadeOverTime( 1 );
            self.scoretext.alpha = 1;
        }
        else if(getplayers().size < 5 && self.scoretext.alpha >= 0)
        {
            self.scoretext FadeOverTime( 1 );
            self.scoretext.alpha = 0;
        }
        wait 0.1;
    }
}

ww_points( player )
{
    for(i = 0; i < 3; i++)
    {
		self maps/mp/zombies/_zm_utility::set_zombie_run_cycle("walk");
        player maps/mp/zombies/_zm_score::add_to_player_score( 10 );
        PlayFXOnTag(level.effect_WebFX,self,"j_spineupper");
        self doDamage(150, (0, 0, 0));
        wait 1;
    }
}

ww_nade_explosion()// made by 2 Millimeter Nahkampfwächter 
{
    wait 2;
    if( self maps/mp/zm_transit_lava::object_touching_lava())
	{
        self delete();
        return 0;
    }
    zombies = getaiarray(level.zombie_team);
    foreach( zombie in zombies )
	{
        if( distance( zombie.origin, self.origin ) < 250 )
		{
            zombie thread ww_points( self );
        }
    }
    self delete();
}

ww_nades() // made by 2 Millimeter Nahkampfwächter 
{
    level endon("end_game");
    self endon("disconnect");
    self endon("stopcustomperk");
    for(;;)
	{
        self waittill( "grenade_fire", grenade, weapname );
        if( weapname == "sticky_grenade_zm" )
		{
            ww_nade = spawnsm( grenade.origin, "zombie_bomb" );
            ww_nade hide();
            ww_nade linkto( grenade );
            ww_nade thread ww_nade_explosion();
        }
    }
}

playerdamagelastcheck( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime )
{
    if(self.has_wine)
	{
          if(isDefined( eAttacker.is_zombie ) && eattacker.is_zombie )
		  {
            zombies = getaiarray(level.zombie_team);
            grenades = self get_player_lethal_grenade();
            grenade_count = self getweaponammoclip(grenades);
            if(grenade_count > 0)
			{
                self setweaponammoclip(grenades, (grenade_count - 1));
                foreach(zombie in zombies)
				{
                    if(distance(zombie.origin, self.origin) < 150)
					{
                        zombie thread ww_points( self );
                        self PlaySound("zmb_elec_jib_zombie");
                        //find zombie motion slowdown
                    }
                }
            }
        }
    }
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
			}
		}
	}
    return idamage;
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
				//zombie dodamage( self.maxhealth * 9, self.origin, self, self, "none", "MOD_SUICIDE" );
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
		if( zomb.size < 4 )
		{
			wait 10;
			//zomb dodamage( self.maxhealth * 9, self.origin, self, self, "none", "MOD_SUICIDE" );
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
			self thread remodel_and_speed();
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
	self thread hint_text_string("Fetch me their souls!");
	self thread playleaderdialogonplayer( "dogstart", self.team, 5 );
}

remodel_and_speed() 
{
	self endon("disconnect");
	self endon("custom_round_over");
	while(1)
	{
		foreach( zombie in getAiArray(level.zombie_team) )
		if(!isDefined(zombie.remodeled) && !zombie.is_avogadro) 
		{
			zombie setModel( "c_zom_screecher_fb" );
			zombie maps/mp/zombies/_zm_utility::set_zombie_run_cycle( "super_sprint" ); 
		}
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
	self thread startwaiting();
	self.hitmarker = newdamageindicatorhudelem( self );
	self.hitmarker.horzalign = "center";
	self.hitmarker.vertalign = "middle";
	self.hitmarker.x = -12;
	self.hitmarker.y = -12;
	self.hitmarker.alpha = 0;
	self.hitmarker setshader( "damage_feedback", 24, 48 );

}

startwaiting()
{
	while( 1 )
	{
		foreach( zombie in getaiarray( level.zombie_team ) )
		{
			if( !(IsDefined( zombie.waitingfordamage )) )
			{
				zombie thread hitmark();
			}
		}
		wait 0.25;
	}

}

hitmark()
{
	self endon( "killed" );
	self.waitingfordamage = 1;
	while( 1 )
	{
		self waittill( "damage", amount, attacker, dir, point, mod );
		attacker.hitmarker.alpha = 0;
		if( isplayer( attacker ) )
		{
			if( isalive( self ) )
			{
				attacker.hitmarker.color = ( 1, 1, 1 );
				attacker.hitmarker.alpha = 1;
				attacker.hitmarker fadeovertime( 1 );
				attacker.hitmarker.alpha = 0;
			}
			else
			{
				attacker.hitmarker.color = ( 1, 0, 0 );
				attacker.hitmarker.alpha = 1;
				attacker.hitmarker fadeovertime( 1 );
				attacker.hitmarker.alpha = 0;
				self notify( "killed" );
			}
		}
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
	if( player[ 4] == self )
	{
		player[ 4] setorigin( ( -4903.28, -7402, -62.5062 ) );
	}
	if( player[ 5] == self )
	{
		player[ 5] setorigin( ( -5010.28, -7402, -62.5062 ) );
	}
	if( player[ 6] == self )
	{
		player[ 6] setorigin( ( -5000.28, -7402, -62.5062 ) );
	}
	if( player[ 7] == self )
	{
		player[ 7] setorigin( ( -4950.28, -7402, -62.5062 ) );
	}

}

turnonpower()
{
	level maps\mp\zombies\_zm_game_module::turn_power_on_and_open_doors();
}


stopbus()
{
	wait 10;
	self endon( "disconnect" );
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
		}
		wait 2;
	}

}

entityremover()
{
    flag_wait( "start_zombie_round_logic" );
    wait 3;
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
}

setSafeText( text )
{
	level.result = level.result + 1;
	self settext( text );
	level notify( "textset" );

}

drawZombiesCounter()
{
    level.zombiesCounter = createServerFontString("hudsmall" , 1.9);
    level.zombiesCounter setPoint("RIGHT", "TOP", 315, "RIGHT");
    while(true)
    {
        enemies = get_round_enemy_array().size + level.zombie_total;
        level.zombiesCounter.label = &"Zombies: ^1";
        level.zombiesCounter setValue( enemies );
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
			self delete();
			if (level.teddysCollected >= level.teddysNeeded)
			{
				self thread maps/mp/zombies/_zm_audio_announcer::leaderdialog( "boxmove" );
				wait 2;
				iprintlnbold("^2Rooftop Opened");
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

init_custom_map()
{
	noncollision( "script_model", (-3890.1, -6650, -59.5062), "collision_player_wall_512x512x10", ( 0, 270, 0 ), "wall" ); 
	noncollision( "script_model", (-6315.28, -7040, -50.5062 ), "collision_player_wall_512x512x10", ( 0, 270, 0 ), "wall2" ); 
	noncollision( "script_model", ( -6415.28, -6850, 5.5062 ), "veh_t6_civ_movingtrk_cab_dead", ( 0, 280, 0 ), "truck" );
	collision( "script_model", (-3870.1, -7050, -50.5062), "t5_foliage_tree_burnt03", (-75, 270, 0), "tree" ); 
	collision( "script_model", ( -4590.28, -7539, -62.5062 ), "zombie_vending_jugg_on", ( 0, 270, 0 ), "jugg" ); 
	collision( "script_model", ( -4173.1, -7750.29, -62.5062 ), "zombie_vending_doubletap2_on", ( 0, 270, 0 ), "DTP" );
	collision( "script_model", ( -5050.28, -7788, -62.5062 ), "zombie_vending_revive_on", ( 0, 180, 0 ), "revive" );
	collision( "script_model", ( -6500.28, -7930, 0.5062 ), "zombie_vending_marathon_on", ( 0, 90, 0 ), "marathon" );
	collision( "script_model", ( -3810.1, -7220, -59.5062 ), "zombie_vending_tombstone_on", ( 0, 270, 0 ), "tomb" ); 
    collision( "script_model", ( -5151.1, -5410, -63.875 ), "zombie_vending_tombstone_on", ( 0, -45, 0 ), "cherry" );
    collision( "script_model", ( -5440.1, -7884, -59.875 ), "zombie_vending_tombstone_on", ( 0, 90, 0 ), "widowswine" );
    collision( "script_model", ( -5912.1, -7355, -63.875 ), "zombie_vending_tombstone_on", ( 0, 180, 0 ), "ER" );
    collision( "script_model", ( -4204.1, -5885, -69.34 ), "zombie_vending_tombstone_on", ( 0, -35, 0 ), "3gun" );
    collision( "script_model", ( -3545.1, -7220, -59.5062 ), "p6_anim_zm_buildable_pap_on", ( 0, 315, 0 ), "pap" );
	pile_of_emp( "emp_grenade_zm", ( -4758.28, -7777.5, -18.062 ), ( 0, 15, 90 ));
	wallweapons( "emp_grenade_zm", ( -4758.28, -7782, -16.162 ), ( 0, 45, 0 ), 1000 );
	wallweapons( "cymbal_monkey_zm", ( -4760.28, -7860, -20.162 ), ( 0, 290, 0 ), 4000 );
	wallweapons( "claymore_zm", ( -5150.28, -7808, -11.162 ), ( 90, 45, 0 ), 1000 );
    wallweapons( "bowie_knife_zm", ( -5439.01, -7773, -13.002 ), ( 0, 225, 0 ), 3000 );
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

defaulth_vending_precaching()
{
	level._effect[ "sleight_light" ] = loadfx( "misc/fx_zombie_cola_on" );
	level._effect[ "tombstone_light" ] = loadfx( "misc/fx_zombie_cola_on" );
	level._effect[ "revive_light" ] = loadfx( "misc/fx_zombie_cola_revive_on" );
	level._effect[ "marathon_light" ] = loadfx( "maps/zombie/fx_zmb_cola_staminup_on" );
	level._effect[ "jugger_light" ] = loadfx( "misc/fx_zombie_cola_jugg_on" );
	level._effect[ "doubletap_light" ] = loadfx( "misc/fx_zombie_cola_dtap_on" );
	level._effect[ "deadshot_light" ] = loadfx( "misc/fx_zombie_cola_dtap_on" );
	level._effect[ "additionalprimaryweapon_light" ] = loadfx( "misc/fx_zombie_cola_arsenal_on" );
	level._effect[ "packapunch_fx" ] = loadfx( "maps/zombie/fx_zombie_packapunch" );
	level._effect[ "wall_m16" ] = loadfx( "maps/zombie/fx_zmb_wall_buy_m16" );
	level._effect[ "wall_claymore" ] = loadfx( "maps/zombie/fx_zmb_wall_buy_claymore" );
	level._effect[ "wall_taseknuck" ] = loadfx( "maps/zombie/fx_zmb_wall_buy_taseknuck" );
}

play_fx( fx )
{
	playfxontag( level._effect[ fx ], self, "tag_origin" );
}

playfx()
{
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
		col thread play_fx( "doubletap_light" );
	}
	if( type == "jugg" )
	{
		col thread perksjuggernog();
		col thread play_fx( "jugger_light" );
	}
	if( type == "revive" )
	{
		col thread perksquickr();
		col thread play_fx( "revive_light" );
	}
	if( type == "marathon")
	{
		col thread perksmarathon();
		col thread play_fx( "marathon_light" );
	}
	if( type == "tomb" )
	{
		col thread perkstomb();
		col thread play_fx( "tombstone_light" );
	}
    if( type == "PHD" )
    {
        col thread PHD_Flopper();
		col thread play_fx( "tombstone_light" );
    }
    if( type == "DD" )
	{
		col thread DownersD();
		col thread play_fx( "tombstone_light" );
	}
    if( type == "VT" )
	{
		col thread VictoriousT();
		col thread play_fx( "tombstone_light" );
	}
    if( type == "cherry" )
	{
		col thread echerry();
		col thread play_fx( "tombstone_light" );
	}
    if( type == "widowswine" )
	{
		col thread wwine();
		col thread play_fx( "tombstone_light" );
	}
    if( type == "ER" )
	{
		col thread Ethereal_Razor();
		col thread play_fx( "tombstone_light" );
	}
    if( type == "3gun" )
	{
		col thread mulekick();
		col thread play_fx( "tombstone_light" );
	}
	if(type == "pap")
	{
		col thread papweapons();
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
										
					if( player usebuttonpressed() && !(player hasperk( "specialty_rof" )) && (player.score >= level.doubletapcost) && !(self.lock) && !player maps/mp/zombies/_zm_laststand::player_is_in_laststand())
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
					
					if( player usebuttonpressed() && !(player hasperk( "specialty_armorvest" )) && ( player.score >= level.juggprice ) && !(self.lock ) && !player maps/mp/zombies/_zm_laststand::player_is_in_laststand())
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
    level.solo_revives = 0;
    level.max_solo_revives = 3;
	while( 1 )
	{
        players = get_players();
		foreach( player in level.players )
		{
			if( !(level.in_use) )
			{
				if( distance( self.origin, player.origin ) <= 60 ) 
				{
                    if(players.size > 1)
                    {
                        player thread machine_hint( "Hold [{+usereload}] For Quick Revive [Cost : 1500] " );
                    }
                    else
                    {
					    player thread machine_hint( "Hold [{+usereload}] For Quick Revive [Cost : 500] " );
                    }
					if((players.size > 1) && player usebuttonpressed() && !(player hasperk( "specialty_quickrevive" )) && (player.score >= level.mquickrevivecost) && !(self.lock ) && !player maps/mp/zombies/_zm_laststand::player_is_in_laststand()) 
					{
						level.in_use = 1;
						self.lock = 1;
                        level.solo_revives = 0;
						player playsound( "zmb_cha_ching" );
						player.score -= level.mquickrevivecost;
						player playsound ( "mus_perks_revive_sting" );
						player thread DoGivePerk("specialty_quickrevive");
						wait 3;
						self.lock = 0;
						level.in_use = 0;
					}
                    if(!level.max_revives && (players.size <= 1) && player usebuttonpressed() && !(player hasperk( "specialty_quickrevive" )) && (player.score >= level.squickrevivecost) && !(self.lock ) && !player maps/mp/zombies/_zm_laststand::player_is_in_laststand()) 
					{
						level.in_use = 1;
						self.lock = 1;
                        level.solo_revives++;
						player playsound( "zmb_cha_ching" );
						player.score -= level.squickrevivecost;
						player playsound ( "mus_perks_revive_sting" );
						player thread DoGivePerk("specialty_quickrevive");
						wait 3;
						self.lock = 0;
						level.in_use = 0;
					}
                    if(level.max_revives && (players.size <= 1) && player usebuttonpressed() && (player.score >= level.squickrevivecost) && !(self.lock ) && !player maps/mp/zombies/_zm_laststand::player_is_in_laststand()) 
					{
                        player maps/mp/zombies/_zm_audio::create_and_play_dialog( "general", "oh_shit" );
                        wait 3;
                    }
                    if(level.solo_revives >= level.max_solo_revives)
                    {
                        level.max_revives = 1;
                    }
					else 
                    {
                        if((players.size == 1) && player usebuttonpressed() && player.score < level.squickrevivecost)
					    {
						    player maps/mp/zombies/_zm_audio::create_and_play_dialog( "general", "perk_deny", undefined, 0 );
					    }
                        if((players.size > 1) && player usebuttonpressed() && player.score < level.mquickrevivecost)
					    {
						    player maps/mp/zombies/_zm_audio::create_and_play_dialog( "general", "perk_deny", undefined, 0 );
					    }
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
										
					if( player usebuttonpressed() && !(player hasperk( "specialty_longersprint" )) && ( player.score >= level.stupcost ) && !(self.lock) && !player maps/mp/zombies/_zm_laststand::player_is_in_laststand())
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
					if( player usebuttonpressed() && !(player hasperk( "specialty_scavenger" )) && ( player.score >= level.tombcost ) && !(self.lock) && !player maps/mp/zombies/_zm_laststand::player_is_in_laststand()) 
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
                    player thread machine_lower_hint( "Explosion and fall damage ignored also player creates explosion when dive to prone." );
					if( player usebuttonpressed() && !(player.has_phd) && ( player.score >= level.phdcost ) && !(self.lock) && !player maps/mp/zombies/_zm_laststand::player_is_in_laststand())
					{
						player.has_phd = 1;
						level.in_use = 1;
						self.lock = 1;
						player playsound( "zmb_cha_ching" );
						player.score -= level.phdcost;
						player playsound ( "mus_perks_packa_sting" );
						player thread drawshader_and_shadermove("PHD_FLOPPER", 1);
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
                    player thread machine_lower_hint( "Players bleedout time increased 10 seconds and current weapons used in laststand");
					if( player usebuttonpressed() && !(player.has_DD) && ( player.score >= level.DDprice ) && !(self.lock) && !player maps/mp/zombies/_zm_laststand::player_is_in_laststand())
					{
						player.has_DD = 1;
						level.in_use = 1;
						self.lock = 1;
						player playsound( "zmb_cha_ching" );
						player.score -= level.DDprice;
						player playsound ( "mus_perks_doubletap_sting" ); 
						player thread drawshader_and_shadermove( "Downers_Delight", 1 );
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
                    player thread machine_lower_hint( "Players shield block damage from all directions when in use.");
					if( player usebuttonpressed() && !(player.has_tortoise) && ( player.score >= level.VTprice ) && !(self.lock) && !player maps/mp/zombies/_zm_laststand::player_is_in_laststand())
					{
						player.has_tortoise = 1;
						level.in_use = 1;
						self.lock = 1;
						player playsound( "zmb_cha_ching" );
						player.score -= level.VTprice;
						player playsound ( "mus_perks_doubletap_sting" ); 
						player thread drawshader_and_shadermove( "Victorious_Tortoise", 1 );
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
                    player thread machine_lower_hint( "It creates an electric shockwave around the player whenever they reload" );
					if( player usebuttonpressed() && !(player.has_cherry) && ( player.score >= level.cherrycost ) && !(self.lock) && !player maps/mp/zombies/_zm_laststand::player_is_in_laststand())
					{
						player.has_cherry = 1;
						level.in_use = 1;
						self.lock = 1;
						player playsound( "zmb_cha_ching" );
						player.score -= level.cherrycost;
						player playsound ( "mus_perks_packa_sting" );
						player thread drawshader_and_shadermove("ELECTRIC_CHERRY", 1);
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

wwine()
{
	while( 1 )
	{
		foreach( player in level.players )
		{
			if( !(level.in_use) )
			{
				if( distance( self.origin, player.origin ) <= 60 ) 
				{
					player thread machine_hint( "Hold [{+usereload}] For Widow's Wine [Cost : 4000] " );
                    player thread machine_lower_hint( "Damages zombies around player when touched and grenades are upgraded" );
					if( player usebuttonpressed() && !(player.has_wine) && ( player.score >= level.wwcost ) && !(self.lock) && !player maps/mp/zombies/_zm_laststand::player_is_in_laststand())
					{
						player.has_wine = 1;
						level.in_use = 1;
						self.lock = 1;
						player playsound( "zmb_cha_ching" );
						player.score -= level.wwcost;
						player playsound ( "mus_perks_mulekick_sting" );
						player thread drawshader_and_shadermove("WIDOWS_WINE", 1);
						wait 3;
						self.lock = 0;
						level.in_use = 0;
					}
					else if(player usebuttonpressed() && player.score < level.wwcost)
					{
						player maps/mp/zombies/_zm_audio::create_and_play_dialog( "general", "perk_deny", undefined, 0 );
					}
				}
			}
		}
		wait 0.1;
	}

}

Ethereal_Razor()
{
	while( 1 )
	{
		foreach( player in level.players )
		{
			if( !(level.in_use) )
			{
				if( distance( self.origin, player.origin ) <= 60 ) 
				{
					player thread machine_hint( "Hold [{+usereload}] For Ethereal Razor [Cost : 4000] " );
                    player thread machine_lower_hint( "Players melee attacks does extra damage and restore a small amount of health.");
					if( player usebuttonpressed() && !(player.has_razor) && ( player.score >= level.ERprice ) && !(self.lock) && !player maps/mp/zombies/_zm_laststand::player_is_in_laststand())
					{
						player.has_razor = 1;
						level.in_use = 1;
						self.lock = 1;
						player playsound( "zmb_cha_ching" );
						player.score -= level.ERprice;
						player playsound ( "mus_perks_doubletap_sting" ); 
						player thread drawshader_and_shadermove( "Ethereal_Razor", 1 );
						wait 3;
						self.lock = 0;
						level.in_use = 0;
					}
					else if(player usebuttonpressed() && player.score < level.ERprice)
					{
						player maps/mp/zombies/_zm_audio::create_and_play_dialog( "general", "perk_deny", undefined, 0 );
					}
				}
			}
		}
		wait 0.1;
	}
}

mulekick()
{
	while( 1 )
	{
		foreach( player in level.players )
		{
			if( !(level.in_use) )
			{
				if( distance( self.origin, player.origin ) <= 60 ) 
				{
					player thread machine_hint( "Hold [{+usereload}] For Mule Kick [Cost : 4000] " );
                    player thread machine_lower_hint( "Enables additional primary weapon slot for player " );

					if( player usebuttonpressed() && !(player hasperk( "specialty_additionalprimaryweapon" )) && ( player.score >= level.t3guncost ) && !(self.lock) && !player maps/mp/zombies/_zm_laststand::player_is_in_laststand())
					{
						player.hasmulekick = 1;
						level.in_use = 1;
						self.lock = 1;
						player playsound( "zmb_cha_ching" );
						player.score -= level.t3guncost;
						player playsound ( "mus_perks_mulekick_sting" );
						player thread drawshader_and_shadermove("specialty_additionalprimaryweapon", 1);
						wait 3;
						self.lock = 0;
						level.in_use = 0;
					}
					else if(player usebuttonpressed() && player.score < level.t3guncost)
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
	for(;;)
	{
    	self waittill_any_return( "fake_death", "player_downed", "player_revived", "spawned_player", "disconnect", "death" );
        self removeperksondeath( 0 );
			self.num_perks = 0;
    		self.perk_reminder = 0;
    		self.perk_count = 0;
    		self.has_dd = 0;
    		self.has_mule = 0;
    		self.has_phd = 0;
    		self.has_tortoise = 0;
    		self.has_cherry = 0; 
    		self.has_wine = 0;
    		self.has_razor = 0;
    		self.perk1back destroy();
			self.perk1back = undefined;
    		self.perk1front destroy();
			self.perk1front = undefined;
    		self.perk2back destroy();
			self.perk2back = undefined;
			self.perk2front destroy();
			self.perk2front = undefined;
    		self.perk3back destroy();
			self.perk3back = undefined;
			self.perk3front destroy();
			self.perk3front = undefined;
    		self.perk4back destroy();
			self.perk4back = undefined;
    		self.perk4front destroy();
			self.perk4front = undefined;
    		self.perk5back destroy();
			self.perk5back = undefined;
    		self.perk5front destroy();
			self.perk5front = undefined;
    		self.perk6back destroy();
			self.perk6back = undefined;
    		self.perk6front destroy();
			self.perk6front = undefined;
    		self.perk7back destroy();
			self.perk7back = undefined;
    		self.perk7front destroy();
			self.perk7front = undefined;
			self notify( "stopcustomperk" );
			self.bleedout_time = 30;
			perk_array = maps/mp/zombies/_zm_perks::get_perk_array( 1 );
            for ( i = 0; i < perk_array.size; i++ )
            {
                perk = perk_array[ i ];
                self unsetperk( perk );
                self.num_perks--;
                self set_perk_clientfield( perk, 0 );
            }
	wait 0.01;
	}

}

removeperksondeath( give )
{
	perks = strtok( "specialty_delayexplosive,specialty_detectexplosive,specialty_disarmexplosive,specialty_earnmoremomentum,specialty_explosivedamage,specialty_flakjacket,specialty_flashprotection,specialty_gpsjammer,specialty_grenadepulldeath", "," ); 
	self notify("stopcustomperk");
	foreach( perk in perks )
	{
		self unsetperk( perk );
	}
    self waittill_any_return( "player_revived", "spawned_player" );
    self unsetperk( "specialty_additionalprimaryweapon" );

}

drawshader( shader, x, y, width, height, color, alpha, sort )
{
	hud = newclienthudelem( self );
	hud.elemtype = "icon";
	hud.color = color;
	hud.alpha = alpha;
	hud.sort = sort;
	hud.children = [];
	hud.hidewheninmenu = 1;
	hud setparent( level.uiparent );
	hud setshader( shader, width, height );
	hud.x = x;
	hud.y = y;
	return hud;

}

perkboughtcheck()
{
    self endon("death");
    self endon("disconnect");
    for(;;)
	{
        self.perk_reminder = self.num_perks;
        self waittill("perk_acquired");
        if(!(self.num_perks - 1) == self.perk_reminder)
		{
            self.num_perks = (self.perk_reminder + 1);
        }
        self.perk_reminder = self.num_perks;
        self.perk_count++;
        self drawshader_and_shadermove("none", 0);
    }
}

drawshader_and_shadermove(perk, custom) // made by 2 Millimeter Nahkampfwächter 
{
    if(custom)
	{
        self allowProne(false);
        self allowSprint(false);
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
        self allowProne(true);
        self allowSprint(true);
        self.num_perks++;
        self.perk_reminder = self.num_perks;
    }
    x = -408 + (self.perk_count * 30);
    if(self.has_dd) 
	{
        self.perk1back.x = self.perk1back.x + 30;
        self.perk1front.x = self.perk1front.x + 30;
    }
    if(self.has_mule)
	{
        self.perk2back.x = self.perk2back.x + 30;
        self.perk2front.x = self.perk2front.x + 30;
    }
    if(self.has_phd)
	{
        self.perk3back.x = self.perk3back.x + 30;
        self.perk3front.x = self.perk3front.x + 30;
    }
    if(self.has_tortoise)
	{
        self.perk4back.x = self.perk4back.x + 30;
        self.perk4front.x = self.perk4front.x + 30;
    }
    if(self.has_cherry)
	{
        self.perk5back.x = self.perk5back.x + 30;
        self.perk5front.x = self.perk5front.x + 30;
    }
    if(self.has_wine)
	{
        self.perk6back.x = self.perk6back.x + 30;
        self.perk6front.x = self.perk6front.x + 30;
    }
    if(self.has_razor)
	{
        self.perk7back.x = self.perk7back.x + 30;
        self.perk7front.x = self.perk7front.x + 30;
    }
    switch(perk)
	{
        case "Downers_Delight":
            self.perk1back = self drawshader( "specialty_marathon_zombies", x, 350, 24, 24, ( 0, 0, 0 ), 100, 0 ); 
            self.perk1front = self drawshader( "waypoint_revive", x, 350, 23, 23, (  0, 1, 1 ), 100, 0 );
            self.has_dd = 1;
			self thread DDown();
            break;
        case "specialty_additionalprimaryweapon":
            self.perk2back = self drawshader( "specialty_marathon_zombies", x, 350, 24, 24, ( 0, 0, 0 ), 100, 0 );
            self.perk2front = self drawshader( "menu_mp_weapons_1911", x, 350, 22, 22, ( 0, 1, 0  ), 100, 0 );
            self.has_mule = 1;
			self setperk( perk );
            break;
        case "PHD_FLOPPER":
            self.perk3back = self drawshader( "specialty_marathon_zombies", x, 350, 24, 24, ( 0, 0, 0 ), 100, 0 );
            self.perk3front = self drawshader( "hud_icon_sticky_grenade", x, 350, 23, 23, (1, 0, 1 ), 100, 0 );
            self.has_phd = 1;
			a = strtok( "specialty_delayexplosive,specialty_detectexplosive,specialty_disarmexplosive,specialty_earnmoremomentum,specialty_explosivedamage,specialty_flakjacket,specialty_flashprotection,specialty_gpsjammer,specialty_grenadepulldeath", "," );
			foreach( b in a )
			{
				self setperk( b );
			}
			self thread phddive(); 
            break;
        case "Victorious_Tortoise":
            self.perk4back = self drawshader( "specialty_marathon_zombies", x, 350, 24, 24, ( 0, 200, 0 ), 100, 0 );
            self.perk4front = self drawshader( "zombies_rank_2", x, 350, 23, 23, ( 1, 1, 1 ), 100, 0 );
            self.has_tortoise = 1;
			self thread start_vt();
            break;
        case "ELECTRIC_CHERRY":
            self.perk5back = self drawshader( "specialty_marathon_zombies", x, 350, 24, 24, ( 0, 0, 200 ), 100, 0 );
            self.perk5front = self drawshader( "zombies_rank_5", x, 350, 23, 23, ( 1, 1, 1 ), 100, 0 );
            self.has_cherry = 1;
			self thread start_ec(); 
            break;
        case "WIDOWS_WINE":
            self.perk6back = self drawshader( "specialty_marathon_zombies", x, 350, 24, 24, ( 0, 0, 0 ), 100, 0 );
            self.perk6front = self drawshader( "zombies_rank_3", x, 350, 23, 23, ( 1, 1, 1 ), 100, 0 );
            self.has_wine = 1;
			self takeweapon( self get_player_lethal_grenade() );
			self set_player_lethal_grenade( "sticky_grenade_zm" );
			self giveweapon("sticky_grenade_zm");
			self thread ww_nades();
            break;
        case "Ethereal_Razor":
            self.perk7back = self drawshader( "specialty_marathon_zombies", x, 350, 24, 24, ( 200, 0, 0 ), 100, 0 );
            self.perk7front = self drawshader( "zombies_rank_4", x, 350, 23, 23, ( 1, 1, 1 ), 100, 0 );
            self.has_razor = 1;
			self thread start_er();
            break;
        default:
            break;
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
			if( IsDefined( self.has_phd ) && self isonground() )
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
    if(self.has_dd)
	{
        self.customlaststandweapon = self getcurrentweapon();
		self switchtoweapon( self.customlaststandweapon );
		self setweaponammoclip( self.customlaststandweapon, 150 );
		self.bleedout_time = 40;
    } 
	else 
	{
        self maps/mp/zombies/_zm::last_stand_pistol_swap();
    }
}

DDown() 
{
	self endon( "disconnect" );
	level endon( "end_game" );
	self endon( "stopcustomperk" );
	for(;;)
	{
		self waittill("player_downed");
		self playsound( "zmb_phdflop_explo" );
		playfx(loadfx("explosions/fx_default_explosion"), self.origin, anglestoforward( ( 0, 45, 55  ) ) ); 
		RadiusDamage(self.origin, 100, 200, 100, self);
		wait 0.1;
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
			self.shielddamagetaken += 100;
            wait 0.9;
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
        self playsound( "zmb_turbine_explo" );
		self EnableInvulnerability();
		RadiusDamage(self.origin, 90, 190, 90, self);
		self DisableInvulnerability();
		wait 1;
    }
}

start_er()
{
    level endon("end_game");
    self endon("disconnect");
    self endon("stopcustomperk");
    for(;;)
    {
        if (self.has_razor && self ismeleeing())
        {
            zombies = getaiarray( level.zombie_team );
            foreach( zombie in zombies )
			{
                if( distance( self.origin, zombie.origin ) <= 90 )
				{
                    zombie dodamage(400, (0, 0, 0));
                    if(zombie.health <= 0)
					{
                        self maps/mp/zombies/_zm_score::add_to_player_score( 100 );
                    } 
					else 
					{
                        self maps/mp/zombies/_zm_score::add_to_player_score( 10 );
                    }
                } 
            }
            self.health += 10;
            if(self.health > self.maxhealth){
                self.health = self.maxhealth;
            }
            while(self ismeleeing()){
                wait 0.1;
            }
        }
        wait 0.05;
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

papweapons() // made by 2 Millimeter Nahkampfwächter 
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
    while( 1 )
    {
        foreach( player in level.players )
        {
            if( distance( self.origin, player.origin ) <= 55 )
            {
                player thread machine_hint("Hold [{+usereload}] For Buy " + ( self.weapx + ( " [Cost: " + ( self.cost + "]") ) ) );
                if( player usebuttonpressed() && !(player hasWeapon(self.curweap)) && player.score >= self.cost && !player maps/mp/zombies/_zm_laststand::player_is_in_laststand())
                {
                    player playsound( "zmb_cha_ching" );
                    player.score -= self.cost;
                    player thread weapon_give( self.curweap, 0, 1 );
                    player iprintln( "^2" + ( self.weapx + " Buy" ) );
                    wait 3;
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
	if (s_powerup.powerup_name == "zombie_cash") // made by 2 Millimeter Nahkampfwächter 
	{
        foreach( player in level.players )
        {
    		player thread hint_text_string( "Zombie Cash!" );
            player.score += (100 * randomIntRange(-11, 21));
            if(player.score < 0)
			{
                player.score = 0;
            }
        }
    }
	if (s_powerup.powerup_name == "unlimited_ammo")
	{
		level thread unlimited_ammo_powerup();
	}
	if (s_powerup.powerup_name == "death_machine")
	{
		e_player notify("Death_Machine");
		e_player thread Death_Machine();
	}
	else if (isDefined(level.original_zombiemode_powerup_grab))
		level thread [[level.original_zombiemode_powerup_grab]](s_powerup, e_player);
}

Death_Machine() //made by 2 Millimeter Nahkampfwächter 
{
    self endon("Death_Machine");
    self thread No_Overheat();
    weap = "jetgun_zm";
    self giveweapon( weap, 0, self get_pack_a_punch_weapon_options( weap ) );
    self switchtoweapon( weap );
    self thread power_up_hud("menu_mp_weapons_xm8", "Death Machine!" );
    wait 31;
    self notify("Death_Machine_Stop");
    self takeweapon("jetgun_zm");
}

No_Overheat()
{
    self endon("Death_Machine_Stop");
    for(;;)
	{
        self setweaponoverheating( 0, 0 );
        wait 0.1;
    }
}

unlimited_ammo_powerup( origin, angles )
{
	foreach(player in level.players)
	{
		player notify("end_unlimited_ammo");
		player playsound("zmb_cha_ching");
		player thread startammo();
		player thread power_up_hud("menu_mp_weapons_xm8", "Infinite Ammo!");
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
	machine_hud_string.alpha = 1;
	machine_hud_string setText( text ); 
	machine_hud_string thread machine_string();
}

machine_lower_hint( text )
{
	self endon("disconnect");
	machine_lower_hint_string = newclienthudelem(self);
	machine_lower_hint_string.elemtype = "font";
	machine_lower_hint_string.font = "objective";
	machine_lower_hint_string.fontscale = 1.3;
	machine_lower_hint_string.x = 175;
	machine_lower_hint_string.y = 350;
	machine_lower_hint_string.width = 0;
	machine_lower_hint_string.height = int( level.fontheight * 2 );
	machine_lower_hint_string.xoffset = 0;
	machine_lower_hint_string.yoffset = 0;
	machine_lower_hint_string.children = [];
	machine_lower_hint_string.hidden = 0;
	machine_lower_hint_string.sort = .5;
	machine_lower_hint_string.alpha = 0;
	machine_lower_hint_string.alpha = 1;
	machine_lower_hint_string setText( text ); 
	machine_lower_hint_string thread machine_string();
}

machine_string()
{
	wait 0.25;
	self destroy();
}

hint_text_string(text)
{
	self endon("disconnect");
	move_text_string = newclienthudelem(self);
	move_text_string.elemtype = "font";
	move_text_string.font = "objective";
	move_text_string.fontscale = 2;
	move_text_string.x = 0;
	move_text_string.y = 0;
	move_text_string.width = 0;
	move_text_string.height = int( level.fontheight * 2 );
	move_text_string.xoffset = 0;
	move_text_string.yoffset = 0;
	move_text_string.children = [];
	move_text_string setparent(level.uiparent);
	move_text_string.hidden = 0;
	move_text_string maps/mp/gametypes_zm/_hud_util::setpoint("TOP", undefined, 0, level.zombie_vars["zombie_timer_offset"] - (level.zombie_vars["zombie_timer_offset_interval"] * 2));
	move_text_string.sort = .5;
	move_text_string.alpha = 0;
	move_text_string fadeovertime(.5);
	move_text_string.alpha = 1;
	move_text_string setText(text);
	move_text_string thread string_move();
}

power_up_hud(shader, text)
{
	self endon("disconnect");
	power_up_hud_string = newclienthudelem(self);
	power_up_hud_string.elemtype = "font";
	power_up_hud_string.font = "objective";
	power_up_hud_string.fontscale = 2;
	power_up_hud_string.x = 0;
	power_up_hud_string.y = 0;
	power_up_hud_string.width = 0;
	power_up_hud_string.height = int( level.fontheight * 2 );
	power_up_hud_string.xoffset = 0;
	power_up_hud_string.yoffset = 0;
	power_up_hud_string.children = [];
	power_up_hud_string setparent(level.uiparent);
	power_up_hud_string.hidden = 0;
	power_up_hud_string maps/mp/gametypes_zm/_hud_util::setpoint("TOP", undefined, 0, level.zombie_vars["zombie_timer_offset"] - (level.zombie_vars["zombie_timer_offset_interval"] * 2));
	power_up_hud_string.sort = .5;
	power_up_hud_string.alpha = 0;
	power_up_hud_string fadeovertime(.5);
	power_up_hud_string.alpha = 1;
	power_up_hud_string setText(text);
	power_up_hud_string thread string_move();
	
	power_up_hud_icon = newclienthudelem(self);
	power_up_hud_icon.horzalign = "center";
	power_up_hud_icon.vertalign = "bottom";
	power_up_hud_icon.x = -75;
	power_up_hud_icon.y = 0;
	power_up_hud_icon.alpha = 1;
	power_up_hud_icon.hidewheninmenu = true;   
	power_up_hud_icon setshader( shader, 30, 30);

	self thread power_up_hud_icon_blink(power_up_hud_icon);
	self thread destroy_unlimited_ammo_icon_hud(power_up_hud_icon);
}

string_move()
{
	wait .5;
	self fadeovertime(1.5);
	self moveovertime(1.5);
	self.y = 270;
	self.alpha = 0;
	wait 1.5;
	self destroy();
}

power_up_hud_icon_blink(elem)
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
		if( weapon != "none" && weapon != "claymore_zm" )
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

enable_aim_assist()
{
	self endon("disconnected");
	level endon("game_ended");
	flag_wait( "start_zombie_round_logic" );
	wait 5;
	self iprintln("^7press ^1[{+smoke}] ^7and ^1[{+frag}] ^7to Enable/Disable controller aim assist ");
	for(;;)
	{
		if(!self.aim_assist_on && self secondaryoffhandbuttonpressed() && self FragButtonPressed())
		{
			self.aim_assist_on = 1;
			self setclientfieldtoplayer( "deadshot_perk", 1 );
			x = 240;
        	self.aim_assist_back_icon = self drawshader( "specialty_marathon_zombies", x, 400, 25, 25, (0, 0, 0), 100, 0 );
			self.aim_assist_front_icon = self drawshader( "killiconheadshot", x, 400, 24, 24, (1, 1, 1), 100, 0 );
			self iprintln("Controller aim assist: ^2Enabled");
			wait 3;
		}
		if(self.aim_assist_on && self secondaryoffhandbuttonpressed() && self FragButtonPressed())
		{
			self setclientfieldtoplayer( "deadshot_perk", 0 );
			self.aim_assist_back_icon destroy();
			self.aim_assist_back_icon = undefined;
    		self.aim_assist_front_icon destroy();
			self.aim_assist_front_icon = undefined;
			self iprintln("Controller aim assist: ^1Disabled");
			self.aim_assist_on = 0;
			wait 3;
		}
	wait 0.05;
	}
}

stop_spawning()
{
}

spawnsm( origin, model, angles )
{
    ent = spawn( "script_model", origin );
    ent setmodel( model );
    if( IsDefined( angles ) )
    {
        ent.angles = angles;
    }
    return ent;
    
}
