import(Module_Defines)
import(Module_PopScript)
import(Module_Commands)
import(Module_Game)
import(Module_Objects)
import(Module_Map)
import(Module_MapWho)
import(Module_Math)
import(Module_Helpers)

include("UtilPThings.lua")

_constants.MaxManaValue = 2500000
_constants.ShamenDeadManaPer256Gained = 16

wilds = {}
spell_delay = {0,0,0,0}
index = 1
availableNums = {5,7,2,3}
ms_used = 0
ms_delay = 720
in_used = 0
in_delay = 360
numthings = 16
should_i_check_for_flats = false
flats_to_use = 0
pink_base_coord = Coord2D.new()
map_xz_to_world_coord2d(234, 18, pink_base_coord)
tick_p_attack = _gsi.Counts.GameTurn + (1300 + G_RANDOM(800))
tick_p_defend = _gsi.Counts.GameTurn + (340 + G_RANDOM(400))
tick_o_flatten = _gsi.Counts.GameTurn + (1500 + G_RANDOM(400))
p_towers = {MAP_XZ_2_WORLD_XYZ(22, 246),
            MAP_XZ_2_WORLD_XYZ(12, 12),
            MAP_XZ_2_WORLD_XYZ(0, 34),
            MAP_XZ_2_WORLD_XYZ(222, 32),
            MAP_XZ_2_WORLD_XYZ(200, 20),
            MAP_XZ_2_WORLD_XYZ(210, 254),
            MAP_XZ_2_WORLD_XYZ(228, 248),
            MAP_XZ_2_WORLD_XYZ(248, 228),
            MAP_XZ_2_WORLD_XYZ(4, 230)
}
o_towers = {MAP_XZ_2_WORLD_XYZ(28, 190),
            MAP_XZ_2_WORLD_XYZ(96, 184),
            MAP_XZ_2_WORLD_XYZ(98, 218),
            MAP_XZ_2_WORLD_XYZ(60, 238),
            MAP_XZ_2_WORLD_XYZ(38, 128),
            MAP_XZ_2_WORLD_XYZ(50, 144),
            MAP_XZ_2_WORLD_XYZ(34, 152),
            MAP_XZ_2_WORLD_XYZ(26, 132),
            MAP_XZ_2_WORLD_XYZ(18, 150),
            MAP_XZ_2_WORLD_XYZ(16, 164),
            MAP_XZ_2_WORLD_XYZ(18, 182),
            MAP_XZ_2_WORLD_XYZ(30, 202),
            MAP_XZ_2_WORLD_XYZ(34, 216)
}
o_flat_pos = {MAP_XZ_2_WORLD_XYZ(14, 154),
              MAP_XZ_2_WORLD_XYZ(8, 154),
              MAP_XZ_2_WORLD_XYZ(2, 154),
              MAP_XZ_2_WORLD_XYZ(252, 154),
              MAP_XZ_2_WORLD_XYZ(246, 154),
              MAP_XZ_2_WORLD_XYZ(10, 170),
              MAP_XZ_2_WORLD_XYZ(4, 170),
              MAP_XZ_2_WORLD_XYZ(254, 170),
              MAP_XZ_2_WORLD_XYZ(248, 170),
              MAP_XZ_2_WORLD_XYZ(242, 170),
              MAP_XZ_2_WORLD_XYZ(16, 188),
              MAP_XZ_2_WORLD_XYZ(10, 188),
              MAP_XZ_2_WORLD_XYZ(4, 188),
              MAP_XZ_2_WORLD_XYZ(254, 188),
              MAP_XZ_2_WORLD_XYZ(248, 188),
              MAP_XZ_2_WORLD_XYZ(26, 206),
              MAP_XZ_2_WORLD_XYZ(20, 206),
              MAP_XZ_2_WORLD_XYZ(14, 206),
              MAP_XZ_2_WORLD_XYZ(8, 206),
              MAP_XZ_2_WORLD_XYZ(2, 206)
}
botSpells = {M_SPELL_CONVERT_WILD,
             M_SPELL_BLAST,
             M_SPELL_LAND_BRIDGE,
             M_SPELL_LIGHTNING_BOLT,
             M_SPELL_INSECT_PLAGUE,
             M_SPELL_INVISIBILITY,
             M_SPELL_GHOST_ARMY,
             M_SPELL_SWAMP,
             M_SPELL_HYPNOTISM,
             M_SPELL_WHIRLWIND,
             M_SPELL_EROSION,
             M_SPELL_EARTHQUAKE
}
botBldgs = {M_BUILDING_TEPEE,
            M_BUILDING_DRUM_TOWER,
            M_BUILDING_WARRIOR_TRAIN,
            M_BUILDING_TEMPLE,
            M_BUILDING_SUPER_TRAIN,
            M_BUILDING_BOAT_HUT_1,
            M_BUILDING_SPY_TRAIN,
            M_BUILDING_AIRSHIP_HUT_1
}

for i=0,1 do
  for j=0,1 do
    set_players_allied(i,j)
  end
end

for k,v in ipairs(availableNums) do
  for kk,vv in ipairs(availableNums) do
    set_players_allied(v,vv)
  end
end

for i = 4,5 do
  for u,v in ipairs(botSpells) do
    PThing.SpellSet(availableNums[i-3], v, TRUE, FALSE)
    PThing.SpellSet(TRIBE_ORANGE, M_SPELL_FLATTEN, TRUE, FALSE)
  end
  
  for y,v in ipairs(botBldgs) do
    PThing.BldgSet(availableNums[i-3], v, TRUE)
  end
  
  computer_init_player(_gsi.Players[availableNums[i-3]])
  
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_EXPANSION, 24+G_RANDOM(16))
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_HOUSE_PERCENTAGE, 50+G_RANDOM(48))
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_MAX_BUILDINGS_ON_GO, 6+G_RANDOM(5))
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_PREF_WARRIOR_TRAINS, 0)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_PREF_WARRIOR_PEOPLE, 0)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_PREF_RELIGIOUS_TRAINS, 0)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_PREF_RELIGIOUS_PEOPLE, 0)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_PREF_SUPER_WARRIOR_TRAINS, 0)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_PREF_SUPER_WARRIOR_PEOPLE, 0)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_PREF_SPY_TRAINS, G_RANDOM(2))
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_PREF_SPY_PEOPLE, G_RANDOM(5)+2)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_AWAY_BRAVE, 5)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_AWAY_WARRIOR, 80)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_AWAY_RELIGIOUS, 69)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_AWAY_SUPER_WARRIOR, 47)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_AWAY_SPY, 5)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_AWAY_MEDICINE_MAN, 100)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_USE_PREACHER_FOR_DEFENCE, 1)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_DEFENSE_RAD_INCR, 4)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_MAX_DEFENSIVE_ACTIONS, 3)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_ATTACK_PERCENTAGE, 125)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_MAX_ATTACKS, 15)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_RETREAT_VALUE, 1+G_RANDOM(25))
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_BASE_UNDER_ATTACK_RETREAT, 0)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_RANDOM_BUILD_SIDE, 1)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_GROUP_OPTION, 0)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_PEOPLE_PER_BOAT, 8)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_PEOPLE_PER_BALLOON, 7)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_ENEMY_SPY_MAX_STAND, 255)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_SPY_CHECK_FREQUENCY, 128)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_SPY_DISCOVER_CHANCE, 30)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_MAX_TRAIN_AT_ONCE, 5)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_SHAMEN_BLAST, 8)
  
  STATE_SET(availableNums[i-3], TRUE, CP_AT_TYPE_FETCH_WOOD)
  STATE_SET(availableNums[i-3], TRUE, CP_AT_TYPE_CONSTRUCT_BUILDING)
  STATE_SET(availableNums[i-3], TRUE, CP_AT_TYPE_BUILD_OUTER_DEFENCES)
  STATE_SET(availableNums[i-3], TRUE, CP_AT_TYPE_DEFEND)
  STATE_SET(availableNums[i-3], TRUE, CP_AT_TYPE_DEFEND_BASE)
  STATE_SET(availableNums[i-3], TRUE, CP_AT_TYPE_PREACH)
  STATE_SET(availableNums[i-3], TRUE, CP_AT_TYPE_BRING_NEW_PEOPLE_BACK)
  STATE_SET(availableNums[i-3], TRUE, CP_AT_TYPE_SUPER_DEFEND)
  STATE_SET(availableNums[i-3], TRUE, CP_AT_TYPE_TRAIN_PEOPLE)
  STATE_SET(availableNums[i-3], TRUE, CP_AT_TYPE_AUTO_ATTACK)
  STATE_SET(availableNums[i-3], TRUE, CP_AT_TYPE_HOUSE_A_PERSON)
  STATE_SET(availableNums[i-3], TRUE, CP_AT_TYPE_POPULATE_DRUM_TOWER)
  STATE_SET(availableNums[i-3], TRUE, CP_AT_TYPE_FETCH_LOST_PEOPLE)
  STATE_SET(availableNums[i-3], TRUE, CP_AT_TYPE_MED_MAN_GET_WILD_PEEPS)
  
  SET_BUCKET_USAGE(availableNums[i-3], TRUE)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-3], M_SPELL_BLAST, 8)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-3], M_SPELL_CONVERT_WILD, 8)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-3], M_SPELL_GHOST_ARMY, 12)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-3], M_SPELL_INSECT_PLAGUE, 16)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-3], M_SPELL_LAND_BRIDGE, 32)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-3], M_SPELL_LIGHTNING_BOLT, 40)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-3], M_SPELL_INVISIBILITY, 28)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-3], M_SPELL_HYPNOTISM, 70)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-3], M_SPELL_WHIRLWIND, 80)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-3], M_SPELL_SWAMP, 100)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-3], M_SPELL_EARTHQUAKE, 175)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-3], M_SPELL_EROSION, 200)
  
  SET_DEFENCE_RADIUS(availableNums[i-3], 7)
  SET_SPELL_ENTRY(availableNums[i-3], 0, M_SPELL_INSECT_PLAGUE, 25000, 64, 3, 0)
  SET_SPELL_ENTRY(availableNums[i-3], 1, M_SPELL_LIGHTNING_BOLT, 40000, 64, 2, 0)
  SET_SPELL_ENTRY(availableNums[i-3], 2, M_SPELL_HYPNOTISM, 70000, 64, 6, 0)
  SET_SPELL_ENTRY(availableNums[i-3], 3, M_SPELL_INSECT_PLAGUE, 25000, 64, 3, 1)
  SET_SPELL_ENTRY(availableNums[i-3], 4, M_SPELL_LIGHTNING_BOLT, 40000, 64, 2, 1)
  SET_SPELL_ENTRY(availableNums[i-3], 5, M_SPELL_HYPNOTISM, 70000, 64, 6, 1)
end

SHAMAN_DEFEND(TRIBE_PINK, 234, 18, TRUE)
SHAMAN_DEFEND(TRIBE_ORANGE, 62, 182, TRUE)
SET_DRUM_TOWER_POS(TRIBE_PINK, 234, 18)
SET_DRUM_TOWER_POS(TRIBE_ORANGE, 62, 182)

function OnTurn()
  if (_gsi.Counts.GameTurn > 1) then
    if (_gsi.Counts.GameTurn > tick_p_attack) then
      tick_p_attack = _gsi.Counts.GameTurn + (1300 + G_RANDOM(800))
      if (FREE_ENTRIES(TRIBE_PINK) > 2 and IS_SHAMAN_AVAILABLE_FOR_ATTACK(TRIBE_PINK) > 0) then
        if (count_troops(TRIBE_PINK) > 7 and _gsi.Players[TRIBE_PINK].Mana > 250000) then
          local enemy = G_RANDOM(2)
          local tries = 16
          
          while tries > 0 do
            tries = tries-1
            if (_gsi.Players[enemy].NumPeople == 0) then
              enemy = G_RANDOM(2)
            else
              break
            end
          end
          
          WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_RELIGIOUS, G_RANDOM(100))
          WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_SPY, 0)
          WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_WARRIOR, G_RANDOM(100))
          WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_SUPER_WARRIOR, G_RANDOM(100))
          WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_MEDICINE_MAN, 1)
          
          ATTACK(TRIBE_PINK, enemy, 8+G_RANDOM(16), 1, -1, 850, 4, 4, 14, ATTACK_NORMAL, 0, 11, -1, -1)
        end
      end
    end
    
    if (_gsi.Counts.GameTurn > tick_p_defend) then
      if (FREE_ENTRIES(TRIBE_PINK) > 2) then
        if (count_people(pink_base_coord,8) > 8) then
          local enemy = G_RANDOM(2)
          local tries = 16
          
          while tries > 0 do
            tries = tries-1
            if (_gsi.Players[enemy].NumPeople == 0) then
              enemy = G_RANDOM(2)
            else
              break
            end
          end
          
          GIVE_ONE_SHOT(TRIBE_PINK, M_SPELL_HYPNOTISM)
          GIVE_ONE_SHOT(TRIBE_PINK, M_SPELL_HYPNOTISM)
          GIVE_ONE_SHOT(TRIBE_PINK, M_SPELL_HYPNOTISM)
          
          WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_DONT_GROUP_AT_DT, 1)
          WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_RELIGIOUS, 80)
          WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_SPY, 0)
          WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_WARRIOR, 80)
          WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_SUPER_WARRIOR, 80)
          WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_MEDICINE_MAN, 1)
          
          ATTACK(TRIBE_PINK, enemy, (_gsi.Players[TRIBE_PINK].NumPeople/3), 0, 10, 999, 7, 7, 7, ATTACK_NORMAL, 0, -1, -1, -1)
          tick_p_defend = _gsi.Counts.GameTurn + (340 + G_RANDOM(400))
        end
      end
    end
    
    if (_gsi.Counts.GameTurn > tick_o_flatten) then
      tick_o_flatten = _gsi.Counts.GameTurn + (1800 + G_RANDOM(1000))
      if (IS_SHAMAN_AVAILABLE_FOR_ATTACK(TRIBE_ORANGE) > 0 and FREE_ENTRIES(TRIBE_ORANGE) > 2) then
        if (_gsi.Players[TRIBE_ORANGE].Mana > 280000) then
          if (tablelength(o_flat_pos) > 0) then
            if (o_flat_pos[1] ~= nil) then
              if (point_altitude(o_flat_pos[1].Xpos,o_flat_pos[1].Zpos) > 600 and not should_i_check_for_flats) then
                should_i_check_for_flats = true
                flats_to_use = 3
              else
                table.remove(o_flat_pos,1)
              end
            end
          end
        end
      end
    end

    if (EVERY_2POW_TURNS(10)) then
      if (tablelength(p_towers) > 0) then
        local t_idx = tablelength(p_towers)
        local t_rnd = G_RANDOM(t_idx)+1
        if (p_towers[t_rnd] ~= nil and FREE_ENTRIES(TRIBE_PINK) > 4) then
          local map_idx = MapPosXZ.new()
          map_idx.Pos = world_coord3d_to_map_idx(p_towers[t_rnd])
          BUILD_DRUM_TOWER(TRIBE_PINK, map_idx.XZ.X, map_idx.XZ.Z)
          table.remove(p_towers, t_rnd)
        end
      end
      
      if (tablelength(o_towers) > 0) then
        local t_idx = tablelength(o_towers)
        local t_rnd = G_RANDOM(t_idx)+1
        if (o_towers[t_rnd] ~= nil and FREE_ENTRIES(TRIBE_ORANGE) > 4) then
          local map_idx = MapPosXZ.new()
          map_idx.Pos = world_coord3d_to_map_idx(o_towers[t_rnd])
          BUILD_DRUM_TOWER(TRIBE_ORANGE, map_idx.XZ.X, map_idx.XZ.Z)
          table.remove(o_towers, t_rnd)
        end
      end
    end
    
    if (EVERY_2POW_TURNS(9)) then
      for i = 4,7 do
        if (PLAYERS_PEOPLE_OF_TYPE(i, M_PERSON_BRAVE) > 15 and _gsi.Players[i].NumPeople > 25) then
          WRITE_CP_ATTRIB(i, ATTR_PREF_WARRIOR_TRAINS, 1)
          WRITE_CP_ATTRIB(i, ATTR_PREF_WARRIOR_PEOPLE, 18+G_RANDOM(15))
          WRITE_CP_ATTRIB(i, ATTR_PREF_RELIGIOUS_TRAINS, 1)
          WRITE_CP_ATTRIB(i, ATTR_PREF_RELIGIOUS_PEOPLE, 15+G_RANDOM(13))
          WRITE_CP_ATTRIB(i, ATTR_PREF_SUPER_WARRIOR_TRAINS, 1)
          WRITE_CP_ATTRIB(i, ATTR_PREF_SUPER_WARRIOR_PEOPLE, 16+G_RANDOM(13))
          STATE_SET(i, FALSE, CP_AT_TYPE_MED_MAN_GET_WILD_PEEPS)
        else
          WRITE_CP_ATTRIB(i, ATTR_PREF_WARRIOR_TRAINS, 0)
          WRITE_CP_ATTRIB(i, ATTR_PREF_WARRIOR_PEOPLE, 5)
          WRITE_CP_ATTRIB(i, ATTR_PREF_RELIGIOUS_TRAINS, 0)
          WRITE_CP_ATTRIB(i, ATTR_PREF_RELIGIOUS_PEOPLE, 5)
          WRITE_CP_ATTRIB(i, ATTR_PREF_SUPER_WARRIOR_TRAINS, 0)
          WRITE_CP_ATTRIB(i, ATTR_PREF_SUPER_WARRIOR_PEOPLE, 5)
          STATE_SET(i, TRUE, CP_AT_TYPE_MED_MAN_GET_WILD_PEEPS)
        end
      end
      
      ProcessGlobalTypeList(T_BUILDING, function(t)
        if (t.Model < 4 and t.Owner > 1) then
          if (t.u.Bldg.SproggingCount < 2000) then
            t.u.Bldg.SproggingCount = t.u.Bldg.SproggingCount + 1400
          end
        end
        
        if (t.Model < 3 and t.Owner > 1) then
          if (t.u.Bldg.UpgradeCount < 825) then
            t.u.Bldg.UpgradeCount = t.u.Bldg.UpgradeCount + 235
          end
        end
        
        return true
      end)
    end
    
    if (EVERY_2POW_TURNS(5)) then
      local shaman = getShaman(TRIBE_YELLOW)
      if (shaman ~= nil) then
        SearchMapCells(CIRCULAR, 0, 0, 2, world_coord2d_to_map_idx(shaman.Pos.D2), function(me)
          local count = 0
          me.MapWhoList:processList(function(t)
            if (count < 6) then
              count = count+1
              if (t.Type == T_PERSON) then
                if (t.Model > 2 and t.Model < 6 and t.Owner == shaman.Owner and not isFlagEnabled(t.Flags3, TF3_SHIELD_ACTIVE)) then
                  if (count > 1 and ms_used < 5) then
                    createThing(T_SPELL,M_SPELL_SHIELD,shaman.Owner,t.Pos.D3,false,false)
                    ms_used = ms_used+1
                    return false
                  end
                end
              end
              return true
            else
              return false
            end
          end)
          return true
        end)
      end
      local shaman2 = getShaman(TRIBE_GREEN)
      if (shaman2 ~= nil) then
        SearchMapCells(CIRCULAR, 0, 0, 2, world_coord2d_to_map_idx(shaman2.Pos.D2), function(me)
          local count = 0
          me.MapWhoList:processList(function(t)
            if (count < 6) then
              count = count+1
              if (t.Type == T_PERSON) then
                if (t.Model > 2 and t.Model < 6 and t.Owner == shaman2.Owner and not isFlagEnabled(t.Flags2, TF2_THING_IS_AN_INVISIBLE_PERSON)) then
                  if (count > 1 and in_used < 5) then
                    createThing(T_SPELL,M_SPELL_INVISIBILITY,shaman2.Owner,t.Pos.D3,false,false)
                    in_used = in_used+1
                    return false
                  end
                end
              end
              return true
            else
              return false
            end
          end)
          return true
        end)
      end
    end
    
    if (EVERY_2POW_TURNS(4)) then
      if (should_i_check_for_flats) then
        if (flats_to_use > 0) then
          local s = getShaman(TRIBE_ORANGE)
          if (s ~= nil and o_flat_pos[1] ~= nil) then
            if (get_thing_curr_cmd_list_ptr(s) == nil) then
              local c2d = Coord2D.new()
              coord3D_to_coord2D(o_flat_pos[1],c2d)
              command_person_go_to_coord2d(s,c2d)
            end
            
            if (get_world_dist_xyz(s.Pos.D3,o_flat_pos[1]) < (4096 + s.Pos.D3.Ypos*3)) then
              createThing(T_SPELL,M_SPELL_FLATTEN,s.Owner,o_flat_pos[1],false,false)
              table.remove(o_flat_pos, 1)
              flats_to_use = flats_to_use-1
            end
          end
        else
          should_i_check_for_flats = false
        end
      end
    end
    
    if (EVERY_2POW_TURNS(2)) then
      for i=1,tablelength(availableNums) do
        local shaman = getShaman(availableNums[i])
        if (shaman ~= nil) then
          if (shaman.State == S_PERSON_DROWNING) then
            SearchMapCells(CIRCULAR, 0, 0, 6, world_coord2d_to_map_idx(shaman.Pos.D2), function(me)
              if (is_map_elem_coast(me) > 0 and spell_delay[i] == 0) then
                local c2d = Coord2D.new()
                map_ptr_to_world_coord2d(me, c2d)
                local c3d = Coord3D.new()
                coord2D_to_coord3D(c2d, c3d)
                createThing(T_SPELL, M_SPELL_LAND_BRIDGE, shaman.Owner, c3d, false, false)
                spell_delay[i] = 792
                return false
              end
              
              return true
            end)
          end
        end
      end
    end
    
    if (EVERY_2POW_TURNS(3)) then
      if (_gsi.Players[TRIBE_ORANGE].NumPeople +
          _gsi.Players[TRIBE_YELLOW].NumPeople +
          _gsi.Players[TRIBE_GREEN].NumPeople +
          _gsi.Players[TRIBE_PINK].NumPeople < 255 and
          _gsi.Counts.GameTurn < (12*60)*4 and
          _gsi.Counts.GameTurn > (12*10)) then
        process(numthings)
      end
    end
    
    for i,v in ipairs(spell_delay) do
      if (v > 0) then
        spell_delay[i] = v-1
      end
    end
    
    if (ms_delay > 0) then
      ms_delay = ms_delay-1
    elseif (ms_delay == 0 and ms_used > 0) then
      ms_used = ms_used-1
      ms_delay = 720
    end
    
    if (in_delay > 0) then
      in_delay = in_delay-1
    elseif (in_delay == 0 and in_used > 0) then
      in_used = in_used-1
      in_delay = 360
    end
  end
end

ProcessGlobalTypeList(T_PERSON, function(t)
  if (t.Model == M_PERSON_WILD) then 
    table.insert(wilds, t)
  end 
  return true
end)

function OnCreateThing(t)
  if (t.Type == T_PERSON and t.Model == M_PERSON_WILD) then
    table.insert(wilds, t)
  end
end

function process(n)
  for i = 0,n do
    if (index < tablelength(wilds)) then
      local t = GetThing(wilds[index].ThingNum)
      if (t ~= nil and t.Type == T_PERSON and t.Model == M_PERSON_WILD) then
        local idx = G_RANDOM(tablelength(availableNums))+1
        local s = getShaman(availableNums[idx])
        if (s ~= nil) then
          if(get_world_dist_xyz(t.Pos.D3, s.Pos.D3) < (8192 + s.Pos.D3.Ypos*3) and spell_delay[idx] == 0) then
            createThing(T_SPELL, M_SPELL_CONVERT_WILD, s.Owner, t.Pos.D3, false, false)
            spell_delay[idx] = 16
          end
        end
      else
        table.remove(wilds, index)
      end
      index = index+1
    else
      index = 1
    end
  end
end

function count_people(coord2,radii)
  local count = 0
  SearchMapCells(CIRCULAR, 0, 0, radii, world_coord2d_to_map_idx(coord2), function(me)
    me.MapWhoList:processList(function (t)
      if (t.Type == T_PERSON) then
        if (t.Owner == TRIBE_BLUE or t.Owner == TRIBE_RED) then
          count = count+1
        end
      end
      return true
    end)
    return true
  end)
  
  return count
end

function count_troops(pn)
  local count = 0
  ProcessGlobalTypeList(T_PERSON, function(t)
    if (t.Owner == pn) then
      if (t.Model == M_PERSON_WARRIOR) then
        count=count+1
      end
      if (t.Model == M_PERSON_RELIGIOUS) then
        count=count+1
      end
      if (t.Model == M_PERSON_SUPER_WARRIOR) then
        count=count+1
      end
    end
    return true
  end)
  
  return count
end

function tablelength(te)
  local count = 0
  for _ in pairs(te) do count = count + 1 end
  return count
end