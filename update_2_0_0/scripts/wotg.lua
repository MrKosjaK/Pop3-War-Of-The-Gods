import(Module_Defines)
import(Module_PopScript)
import(Module_Commands)
import(Module_Game)
import(Module_Objects)
import(Module_Map)
import(Module_MapWho)
import(Module_Math)
import(Module_Helpers)
import(Module_Person)
import(Module_System)

include("UtilPThings.lua")
include("UtilRefs.lua")
include("LibMap.lua")
include("LibCmd.lua")

local STurn = GetTurn()

wilds = {}
index = 1
spell_delay = {0,0,0,0,0,0}
availableNums = {2,3,4,5,6,7}
numthings = 16
lite_attack = {
  GetTurn() + (1280 + G_RANDOM(758)),
  GetTurn() + (1280 + G_RANDOM(758)),
  GetTurn() + (1280 + G_RANDOM(758)),
  GetTurn() + (1280 + G_RANDOM(758))
}
conv_center_pos = {
MAP_XZ_2_WORLD_XYZ(128, 184),
MAP_XZ_2_WORLD_XYZ(230, 192),
MAP_XZ_2_WORLD_XYZ(244, 94), 
MAP_XZ_2_WORLD_XYZ(56, 26),
MAP_XZ_2_WORLD_XYZ(150, 250),
MAP_XZ_2_WORLD_XYZ(46, 154)
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
             M_SPELL_EARTHQUAKE,
             M_SPELL_FIRESTORM,
             M_SPELL_SHIELD,
             M_SPELL_FLATTEN,
             M_SPELL_VOLCANO,
             M_SPELL_ANGEL_OF_DEATH
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

for i=2,7 do
  for j=2,7 do
    set_players_allied(i,j)
  end
end

for i = 2,7 do
  for u,v in ipairs(botSpells) do
    PThing.SpellSet(availableNums[i-1], v, TRUE, FALSE)
  end

  for y,v in ipairs(botBldgs) do
    PThing.BldgSet(availableNums[i-1], v, TRUE)
  end

  computer_init_player(_gsi.Players[availableNums[i-1]])

  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_EXPANSION, 24+G_RANDOM(16))
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_HOUSE_PERCENTAGE, 30+G_RANDOM(28))
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_MAX_BUILDINGS_ON_GO, 10+G_RANDOM(5))
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_PREF_WARRIOR_TRAINS, 0)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_PREF_WARRIOR_PEOPLE, 0)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_PREF_RELIGIOUS_TRAINS, 0)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_PREF_RELIGIOUS_PEOPLE, 0)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_PREF_SUPER_WARRIOR_TRAINS, 0)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_PREF_SUPER_WARRIOR_PEOPLE, 0)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_PREF_SPY_TRAINS, G_RANDOM(2))
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_PREF_SPY_PEOPLE, G_RANDOM(5)+2)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_AWAY_BRAVE, 5)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_AWAY_WARRIOR, 80)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_AWAY_RELIGIOUS, 69)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_AWAY_SUPER_WARRIOR, 47)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_AWAY_SPY, 5)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_AWAY_MEDICINE_MAN, 100)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_USE_PREACHER_FOR_DEFENCE, 1)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_DEFENSE_RAD_INCR, 4)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_MAX_DEFENSIVE_ACTIONS, 3)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_ATTACK_PERCENTAGE, 125)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_MAX_ATTACKS, 15)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_RETREAT_VALUE, 1+G_RANDOM(25))
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_BASE_UNDER_ATTACK_RETREAT, 0)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_RANDOM_BUILD_SIDE, 1)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_GROUP_OPTION, 0)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_PEOPLE_PER_BOAT, 7)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_PEOPLE_PER_BALLOON, 8)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_ENEMY_SPY_MAX_STAND, 255)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_SPY_CHECK_FREQUENCY, 128)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_SPY_DISCOVER_CHANCE, 30)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_MAX_TRAIN_AT_ONCE, 5)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_SHAMEN_BLAST, 8)

  STATE_SET(availableNums[i-1], TRUE, CP_AT_TYPE_FETCH_WOOD)
  STATE_SET(availableNums[i-1], TRUE, CP_AT_TYPE_CONSTRUCT_BUILDING)
  STATE_SET(availableNums[i-1], TRUE, CP_AT_TYPE_BUILD_OUTER_DEFENCES)
  STATE_SET(availableNums[i-1], TRUE, CP_AT_TYPE_DEFEND)
  STATE_SET(availableNums[i-1], TRUE, CP_AT_TYPE_DEFEND_BASE)
  STATE_SET(availableNums[i-1], TRUE, CP_AT_TYPE_PREACH)
  STATE_SET(availableNums[i-1], TRUE, CP_AT_TYPE_BRING_NEW_PEOPLE_BACK)
  STATE_SET(availableNums[i-1], TRUE, CP_AT_TYPE_SUPER_DEFEND)
  STATE_SET(availableNums[i-1], TRUE, CP_AT_TYPE_TRAIN_PEOPLE)
  STATE_SET(availableNums[i-1], TRUE, CP_AT_TYPE_AUTO_ATTACK)
  STATE_SET(availableNums[i-1], TRUE, CP_AT_TYPE_HOUSE_A_PERSON)
  STATE_SET(availableNums[i-1], TRUE, CP_AT_TYPE_POPULATE_DRUM_TOWER)
  STATE_SET(availableNums[i-1], TRUE, CP_AT_TYPE_FETCH_LOST_PEOPLE)
  STATE_SET(availableNums[i-1], TRUE, CP_AT_TYPE_MED_MAN_GET_WILD_PEEPS)

  SET_BUCKET_USAGE(availableNums[i-1], TRUE)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-1], M_SPELL_BLAST, 8)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-1], M_SPELL_CONVERT_WILD, 8)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-1], M_SPELL_GHOST_ARMY, 12)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-1], M_SPELL_INSECT_PLAGUE, 16)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-1], M_SPELL_LAND_BRIDGE, 32)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-1], M_SPELL_LIGHTNING_BOLT, 40)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-1], M_SPELL_INVISIBILITY, 28)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-1], M_SPELL_HYPNOTISM, 50)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-1], M_SPELL_WHIRLWIND, 80)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-1], M_SPELL_SWAMP, 100)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-1], M_SPELL_EARTHQUAKE, 175)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-1], M_SPELL_EROSION, 200)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-1], M_SPELL_FLATTEN, 125)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-1], M_SPELL_FIRESTORM, 275)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-1], M_SPELL_SHIELD, 28)

  SET_DEFENCE_RADIUS(availableNums[i-1], 7)
  SET_SPELL_ENTRY(availableNums[i-1], 0, M_SPELL_INSECT_PLAGUE, 25000, 64, 3, 0)
  SET_SPELL_ENTRY(availableNums[i-1], 1, M_SPELL_LIGHTNING_BOLT, 40000, 64, 2, 0)
  SET_SPELL_ENTRY(availableNums[i-1], 2, M_SPELL_INSECT_PLAGUE, 25000, 64, 3, 1)
  SET_SPELL_ENTRY(availableNums[i-1], 3, M_SPELL_LIGHTNING_BOLT, 40000, 64, 2, 1)
end

SET_DRUM_TOWER_POS(TRIBE_YELLOW, 128, 184)
SET_DRUM_TOWER_POS(TRIBE_GREEN, 230, 192)
SET_DRUM_TOWER_POS(TRIBE_CYAN, 244, 94)
SET_DRUM_TOWER_POS(TRIBE_PINK, 56, 26)
SET_DRUM_TOWER_POS(TRIBE_BLACK, 150, 250)
SET_DRUM_TOWER_POS(TRIBE_ORANGE, 46, 154)

local function amt_of_building_type(pn,model)
  local count = 0
  ProcessGlobalSpecialList(pn,BUILDINGLIST,function(t)
    if (t.Model == model) then
      count=count+1
    end
    
    return true
  end)
  
  return count
end

function OnTurn()
  if (GetTurn() > STurn + 1) then
    if (every2Pow(9)) then
      local rand = G_RANDOM(2)
      for c = 0,32 do
        rand = G_RANDOM(2)
        if (_gsi.Players[rand].DeadCount == 0) then
          break
        end
      end
      
      if (rand >= 0) then
        local pCont = getPlayerContainer(rand)
        local pList = pCont.PlayerLists[BUILDINGLIST]
        local pCount = pList:count()
        local cnt_factor = math.floor(_gsi.Counts.GameTurn/2000)
        if (pCount > 0) then
          local target = pList:getNth(G_RANDOM(pCount))
          if (target ~= nil) then
            for idx,value in ipairs(availableNums) do
              if (_gsi.Players[value].DeadCount == 0) then
                if (G_RANDOM(3) == 0) then
                  local cnt = 1+G_RANDOM(3+cnt_factor)
                  local attackers = get_enough_troops(value,cnt)
                  for i,thing in ipairs(attackers) do
                    remove_all_persons_commands(thing)
                    thing.Flags = thing.Flags | TF_RESET_STATE
                    add_persons_command(thing,cmd_attack_thing(target),0)
                  end
                end
              end
            end
          end
        end
      end
    end
    
    if (every2Pow(10) then
      for i,pn in ipairs(availableNums) do
        if (FREE_ENTRIES(pn) > 18) then
          if (GetPlayerPeople(pn) > 40 and amt_of_building_type(pn,M_BUILDING_DRUM_TOWER) < 24) then
            local degrees = G_RANDOM(360)
            if (degrees > 180) then
              degrees=degrees-360
            end
            local rotation = (degrees * 3.14) / 180
            local c3d_pos = Coord3D.new()
            local xz_pos = MapPosXZ.new()
            c3d_pos.Zpos = math.ceil(conv_center_pos[i].Zpos + math.sin(rotation) * (512*(14+G_RANDOM(6))))
            c3d_pos.Xpos = math.ceil(conv_center_pos[i].Xpos + math.cos(rotation) * (512*(14+G_RANDOM(6))))
            xz_pos.Pos = world_coord3d_to_map_idx(c3d_pos)
            BUILD_DRUM_TOWER(pn,xz_pos.XZ.X,xz_pos.XZ.Z)
          end
        end
      end
    end
    
    if (every2Pow(9)) then
      for i = 2,7 do
        if (PLAYERS_PEOPLE_OF_TYPE(i, M_PERSON_BRAVE) > 15 and _gsi.Players[i].NumPeople > 25) then
          WRITE_CP_ATTRIB(i, ATTR_PREF_WARRIOR_TRAINS, 1)
          WRITE_CP_ATTRIB(i, ATTR_PREF_WARRIOR_PEOPLE, 18+G_RANDOM(17))
          WRITE_CP_ATTRIB(i, ATTR_PREF_RELIGIOUS_TRAINS, 1)
          WRITE_CP_ATTRIB(i, ATTR_PREF_RELIGIOUS_PEOPLE, 15+G_RANDOM(15))
          WRITE_CP_ATTRIB(i, ATTR_PREF_SUPER_WARRIOR_TRAINS, 1)
          WRITE_CP_ATTRIB(i, ATTR_PREF_SUPER_WARRIOR_PEOPLE, 16+G_RANDOM(15))
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

        if (READ_CP_ATTRIB(i,ATTR_HOUSE_PERCENTAGE) < 242 and GetPlayerPeople(i) > READ_CP_ATTRIB(i,ATTR_HOUSE_PERCENTAGE)-12) then
          WRITE_CP_ATTRIB(i,ATTR_HOUSE_PERCENTAGE,READ_CP_ATTRIB(i,ATTR_HOUSE_PERCENTAGE)+2)
        end
      end

      ProcessGlobalTypeList(T_BUILDING, function(t)
        if (t.Model < 4 and t.Owner > 1) then
          if (t.u.Bldg.SproggingCount < 2000) then
            t.u.Bldg.SproggingCount = t.u.Bldg.SproggingCount + 1500
          end
        end

        if (t.Model < 3 and t.Owner > 1) then
          if (t.u.Bldg.UpgradeCount < 1825) then
            t.u.Bldg.UpgradeCount = t.u.Bldg.UpgradeCount + 350
          end
        end

        return true
      end)
    end

    if (every2Pow(3)) then
      if (_gsi.Players[TRIBE_YELLOW].NumPeople +
          _gsi.Players[TRIBE_GREEN].NumPeople +
          _gsi.Players[TRIBE_PINK].NumPeople +
          _gsi.Players[TRIBE_CYAN].NumPeople +
          _gsi.Players[TRIBE_ORANGE].NumPeople +
          _gsi.Players[TRIBE_BLACK].NumPeople < 500 and
          GetTurn() < STurn + (12*60)*6 and
          GetTurn() > STurn + (12*10)) then
        process(numthings)
      end
    end
    
    for i,v in ipairs(spell_delay) do
      if (v > 0) then
        spell_delay[i] = v-1
      end
    end
  end
end

ProcessGlobalTypeList(T_PERSON, function(t)
  if (t.Model == M_PERSON_WILD) then
    table.insert(wilds, t)
  end
  return true
end)

function get_enough_troops(pn,count)
  local pers_table = {}
  local num = 0
  ProcessGlobalSpecialList(pn,PEOPLELIST,function(t)
    if (num < count) then
      if (t.Model == M_PERSON_WARRIOR or t.Model == M_PERSON_RELIGIOUS or t.Model == M_PERSON_SUPER_WARRIOR) then
        --local this_cmd = get_thing_curr_cmd_list_ptr(t)
        if (is_person_currently_attacking_a_building(t) == 0) then
          log("Person is not fighting!")
          table.insert(pers_table,t)
          num=num+1
        end
      end
    end
    
    return true
  end)
  return pers_table
end

local function area_check_for_bldg(elem,r)
  local mapXZ = MapPosXZ.new()
  mapXZ.Pos = MAP_ELEM_PTR_2_IDX(elem)
  mapXZ.XZ.X = mapXZ.XZ.X-r+1
  mapXZ.XZ.Z = mapXZ.XZ.Z-r+1
  local x = 0
  local z = 0
  local count = 0
  for i=0,r do
    x = mapXZ.XZ.X + i*2
    for i=0,r do
      z = mapXZ.XZ.Z + i*2
      local me = xz_to_me(x,z)
      me.MapWhoList:processList(function(t)
        if (t.Type == T_BUILDING) then
          if (t.Owner > 1) then
            count=count+1
          end
        end
        
        return true
      end)
    end
  end
  
  return count
end

local spell_effects = {
  1,
  78,
  17,
  20,
  21,
  1,
  16,
  22,
  12,
  23,
  18,
  1,
  19,
  26,
  1,
  15,
  1,
  1,
  1,
  1,
  1
}

local function process_god_spell(caster,spell_model)
  local p_c = getPlayerContainer(caster)
  local p_c_list = p_c.PlayerLists[BUILDINGLIST]
  local p_c_count = p_c.PlayerLists[BUILDINGLIST]:count()
  if (p_c_count ~= 0) then
    local target = p_c_list:getNth(G_RANDOM(p_c_count))
    local who_to_cast = availableNums[G_RANDOM(#availableNums)+1]
    createThing(T_SPELL,spell_model,who_to_cast,target.Pos.D3,false,false)
    createThing(T_EFFECT,spell_effects[spell_model],who_to_cast,target.Pos.D3,false,false)
  else
    local p_c_p_list = p_c.PlayerLists[PEOPLELIST]
    local p_c_p_count = p_c.PlayerLists[PEOPLELIST]:count()
    if (p_c_p_count ~= 0) then
      local target = p_c_p_list:getNth(G_RANDOM(p_c_p_count))
      if (target.Model ~= 8) then
        local who_to_cast = availableNums[G_RANDOM(#availableNums)+1]
        createThing(T_SPELL,spell_model,who_to_cast,target.Pos.D3,false,false)
        createThing(T_EFFECT,spell_effects[spell_model],who_to_cast,target.Pos.D3,false,false)
      end
    end
  end
end

function OnCreateThing(t)
  if (t.Type == T_PERSON and t.Model == M_PERSON_WILD) then
    table.insert(wilds, t)
  end
  if (t.Type == T_SPELL) then
    if (t.Owner < 2) then
      local bldgs = area_check_for_bldg(world_coord3d_to_map_ptr(t.Pos.D3),16)
      if (bldgs > 0) then
        process_god_spell(t.Owner,t.Model)
      end
    end
  end
end

function process(n)
  for i = 0,n do
    if (index < tablelength(wilds)) then
      local t = GetThing(wilds[index].ThingNum)
      if (t ~= nil and t.Type == T_PERSON and t.Model == M_PERSON_WILD) then
        local idx = G_RANDOM(tablelength(availableNums))+1
        if(get_world_dist_xyz(t.Pos.D3, conv_center_pos[idx]) < (512*32) and spell_delay[idx] == 0) then
          --createThing(T_SPELL, M_SPELL_CONVERT_WILD, availableNums[idx], t.Pos.D3, false, false)
          createThing(T_EFFECT, M_EFFECT_CONVERT_WILD, availableNums[idx], t.Pos.D3, false, false)
          spell_delay[idx] = 12 + G_RANDOM(40)
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

function decide_an_enemy_to_attack(myself)
  local i = myself
  local tries = 16
  while (tries > 0) do
    tries=tries-1
    i = G_RANDOM(MAX_NUM_REAL_PLAYERS)
    if (i ~= myself and are_players_allied(i,myself) == 0) then
      if (GetPlayerPeople(i) > 0) then
        if (NAV_CHECK(myself,i,ATTACK_BUILDING,0,0) == 1) then
          break
        end
      end
    end
  end
  return i
end

function decide_an_enemy_to_attack_with_vehicle(myself)
  local i = myself
  local tries = 16
  while (tries > 0) do
    tries=tries-1
    i = G_RANDOM(MAX_NUM_REAL_PLAYERS)
    if (i ~= myself and are_players_allied(i,myself) == 0) then
      if (GetPlayerPeople(i) > 0) then
        break
      end
    end
  end
  return i
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
