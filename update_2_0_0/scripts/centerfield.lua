import(Module_Defines)
import(Module_PopScript)
import(Module_Commands)
import(Module_Game)
import(Module_Objects)
import(Module_Map)
import(Module_MapWho)
import(Module_Math)
import(Module_Helpers)
import(Module_System)

include("UtilPThings.lua")
include("UtilRefs.lua")

local STurn = GetTurn()

_c.MaxManaValue = 2500000
_c.ShamenDeadManaPer256Gained = 16

wilds = {}
spell_delay = {0,0,0,0,0,0}
spell_ms_delay = {720,720,720,720,720,720}
spell_ms_used = {5,5,5,5,5,5}
spell_ms_radius = 3
spell_ms_max_use = 5
spell_ms_charge_time = 720
prayer = nil
index = 1
availableNums = {4,5,6,2,3}
numthings = 16
pray_tick_all = GetTurn() + (256 + G_RANDOM(1024))
land_bridge = {
  GetTurn() + (2000 + G_RANDOM(3000)),
  GetTurn() + (2000 + G_RANDOM(3000)),
  GetTurn() + (2000 + G_RANDOM(3000))
}
lite_attack = {
  GetTurn() + (1280 + G_RANDOM(768)),
  GetTurn() + (1280 + G_RANDOM(768)),
  GetTurn() + (1280 + G_RANDOM(768)),
}
shaman_attack = {
  GetTurn() + (1536 + G_RANDOM(2560)),
  GetTurn() + (1536 + G_RANDOM(2560)),
  GetTurn() + (1536 + G_RANDOM(2560))
}
stone_head_pos = MAP_XZ_2_WORLD_XYZ(4, 146)
conv_center_pos = {
MAP_XZ_2_WORLD_XYZ(4, 146),
MAP_XZ_2_WORLD_XYZ(4, 146),
MAP_XZ_2_WORLD_XYZ(4, 146),
MAP_XZ_2_WORLD_XYZ(4, 146),
MAP_XZ_2_WORLD_XYZ(4, 146)
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
             M_SPELL_FLATTEN
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

for i=2,3 do
  for j=2,3 do
    set_players_allied(i,j)
  end
end

for i=4,5 do
  for j=4,5 do
    set_players_allied(i,j)
  end
end

for i = 4,6 do
  for u,v in ipairs(botSpells) do
    PThing.SpellSet(availableNums[i-3], v, TRUE, FALSE)
  end

  for y,v in ipairs(botBldgs) do
    PThing.BldgSet(availableNums[i-3], v, TRUE)
  end

  computer_init_player(_gsi.Players[availableNums[i-3]])

  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_EXPANSION, 24+G_RANDOM(16))
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_HOUSE_PERCENTAGE, 30+G_RANDOM(28))
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
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_PEOPLE_PER_BOAT, 7)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_PEOPLE_PER_BALLOON, 8)
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
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-3], M_SPELL_FLATTEN, 125)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-3], M_SPELL_FIRESTORM, 275)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-3], M_SPELL_SHIELD, 28)

  SET_DEFENCE_RADIUS(availableNums[i-3], 7)
  SET_SPELL_ENTRY(availableNums[i-3], 0, M_SPELL_INSECT_PLAGUE, 25000, 64, 3, 0)
  SET_SPELL_ENTRY(availableNums[i-3], 1, M_SPELL_LIGHTNING_BOLT, 40000, 64, 2, 0)
  SET_SPELL_ENTRY(availableNums[i-3], 2, M_SPELL_HYPNOTISM, 70000, 64, 6, 0)
  SET_SPELL_ENTRY(availableNums[i-3], 3, M_SPELL_INSECT_PLAGUE, 25000, 64, 3, 1)
  SET_SPELL_ENTRY(availableNums[i-3], 4, M_SPELL_LIGHTNING_BOLT, 40000, 64, 2, 1)
  SET_SPELL_ENTRY(availableNums[i-3], 5, M_SPELL_HYPNOTISM, 70000, 64, 6, 1)
end

SHAMAN_DEFEND(TRIBE_CYAN, 216, 204, TRUE)
SHAMAN_DEFEND(TRIBE_PINK, 194, 188, TRUE)
SHAMAN_DEFEND(TRIBE_BLACK, 78, 84, TRUE)
SET_DRUM_TOWER_POS(TRIBE_CYAN, 216, 204)
SET_DRUM_TOWER_POS(TRIBE_PINK, 194, 188)
SET_DRUM_TOWER_POS(TRIBE_BLACK, 78, 84)
SET_MARKER_ENTRY(TRIBE_CYAN,0,44,45,0,2,2,2)
SET_MARKER_ENTRY(TRIBE_CYAN,1,43,42,0,0,4,0)
SET_MARKER_ENTRY(TRIBE_CYAN,2,39,40,0,2,2,2)
SET_MARKER_ENTRY(TRIBE_PINK,0,48,49,0,2,2,2)
SET_MARKER_ENTRY(TRIBE_PINK,1,47,46,0,0,4,0)
SET_MARKER_ENTRY(TRIBE_PINK,2,39,41,0,2,2,2)
SET_MARKER_ENTRY(TRIBE_BLACK,0,34,35,0,2,2,2)
SET_MARKER_ENTRY(TRIBE_BLACK,1,36,37,0,2,2,2)
SET_MARKER_ENTRY(TRIBE_BLACK,2,37,38,0,2,2,2)

function OnTurn()
  if (GetTurn() > STurn + 1) then
    if every2Pow(1) then
      for index,turn in ipairs(lite_attack) do
        if (GetTurn() > turn) then
          lite_attack[index] = GetTurn() + (1280 + G_RANDOM(768))
          if (FREE_ENTRIES(index+3) > 2) then
            local troops = count_troops(index+3)
            if (troops > 5) then
              WRITE_CP_ATTRIB(index+3,ATTR_AWAY_MEDICINE_MAN,0)
              local enemy = decide_an_enemy_to_attack(index+3)
              ATTACK(index+3,enemy,math.ceil(troops/4),1,0,200,0,0,0,ATTACK_NORMAL,0,-1,-1,-1)
            end
          end
        end
      end
    end

    if every2Pow(3) then
      for index,turn in ipairs(land_bridge) do
        if (GetTurn() > turn) then
          land_bridge[index] = GetTurn() + (2000 + G_RANDOM(4000))
          if (FREE_ENTRIES(index+3) > 2) then
            if (IS_SHAMAN_AVAILABLE_FOR_ATTACK(index+3) == 1) then
              if (MANA(index+3) > 100000) then
                local marker = -1
                local stand_marker = -1
                if (index == 1) then
                  marker = 15
                  stand_marker = 16
                elseif (index == 2) then
                  marker = 27
                  stand_marker = 28
                elseif (index == 3) then
                  if (G_RANDOM(2) == 1) then
                    marker = 18
                    stand_marker = 19
                  else
                    marker = 21
                    stand_marker = 22
                  end
                end
                if (GET_HEIGHT_AT_POS(marker) == 0) then
                  WRITE_CP_ATTRIB(index+3,ATTR_AWAY_MEDICINE_MAN,1)
                  local fakeenemy = decide_an_enemy_to_attack(index+3)
                  ATTACK(index+3,fakeenemy,0,1,0,0,12,0,0,ATTACK_NORMAL,0,stand_marker,marker-1,-1)
                end
              end
            end
          end
        end
      end
    end

    if every2Pow(2) then
      for index,turn in ipairs(shaman_attack) do
        if (GetTurn() > turn) then
          shaman_attack[index] = GetTurn() + (1536 + G_RANDOM(2560))
          if (FREE_ENTRIES(index+3) > 2) then
            if (IS_SHAMAN_AVAILABLE_FOR_ATTACK(index+3) == 1 and MANA(index+3) > 300000) then
              WRITE_CP_ATTRIB(index+3,ATTR_AWAY_MEDICINE_MAN,1)
              local enemy = decide_an_enemy_to_attack(index+3)
              if (GET_NUM_ONE_OFF_SPELLS(index+3,M_SPELL_ARMAGEDDON) == 0) then
                ATTACK(index+3,enemy,0,1,0,999,7,7,7,ATTACK_NORMAL,0,-1,-1,-1)
              else
                SPELL_ATTACK(index+3,M_SPELL_ARMAGEDDON,29,0)
              end
            end
          end
        end
      end
    end

    if (GetTurn() > pray_tick_all) then
      pray_tick_all = GetTurn() + (300 + G_RANDOM(1024))
      for i=2,6 do
        if (_gsi.Players[i].PlayerType == COMPUTER_PLAYER) then
          if (GetPlayerPeople(i) > 40) then
            local people_near_stone = count_people(i,stone_head_pos,3)
            if (people_near_stone < 6) then
              if (i == GetPopLeader()) then
                if (GET_HEAD_TRIGGER_COUNT(4,146) > 0) then
                  PRAY_AT_HEAD(i,6,29)
                  prayer = i
                end
              end
            else
              if (count_troops(i) > 4) then
                WRITE_CP_ATTRIB(i,ATTR_AWAY_MEDICINE_MAN,0)
                ATTACK(i,prayer,6,0,30,999,0,0,0,ATTACK_NORMAL,0,-1,-1,-1)
              end
            end
          end
        end
      end
    end

    if (every2Pow(9)) then
      for i = 4,7 do
        if (PLAYERS_PEOPLE_OF_TYPE(i, M_PERSON_BRAVE) > 20 and _gsi.Players[i].NumPeople > 35) then
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

        if (READ_CP_ATTRIB(i,ATTR_HOUSE_PERCENTAGE) < 160 and GetPlayerPeople(i) > READ_CP_ATTRIB(i,ATTR_HOUSE_PERCENTAGE)) then
          WRITE_CP_ATTRIB(i,ATTR_HOUSE_PERCENTAGE,READ_CP_ATTRIB(i,ATTR_HOUSE_PERCENTAGE)+2)
        end

        if (count_troops(i) > 10) then
          MARKER_ENTRIES(i,0,1,2,-1)
        end
      end

      ProcessGlobalTypeList(T_BUILDING, function(t)
        if (t.Model < 4 and t.Owner > 1) then
          if (t.u.Bldg.SproggingCount < 2000) then
            t.u.Bldg.SproggingCount = t.u.Bldg.SproggingCount + 1500
          end
        end

        if (t.Model < 3 and t.Owner > 1) then
          if (t.u.Bldg.UpgradeCount < 825) then
            t.u.Bldg.UpgradeCount = t.u.Bldg.UpgradeCount + 250
          end
        end

        return true
      end)
    end

    if (every2Pow(2)) then
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

    if (every2Pow(3)) then
      if (_gsi.Players[TRIBE_CYAN].NumPeople +
          _gsi.Players[TRIBE_YELLOW].NumPeople +
          _gsi.Players[TRIBE_GREEN].NumPeople +
          _gsi.Players[TRIBE_PINK].NumPeople +
          _gsi.Players[TRIBE_BLACK].NumPeople < 300 and
          GetTurn() < STurn + (12*60)*4 and
          GetTurn() > STurn + (12*10)) then
        process(numthings)
      end
    end

    if (every2Pow(5)) then
      for i,v in ipairs(availableNums) do
        if (spell_ms_used[i] < spell_ms_max_use) then
          local s = getShaman(v)
          if (s ~= nil and is_thing_on_ground(s) == 1) then
            local last_thing = nil
            local total_count = 0
            SearchMapCells(SQUARE,0,0,spell_ms_radius,world_coord2d_to_map_idx(s.Pos.D2),function(me)
              local count = 0
              me.MapWhoList:processList(function(t)
                if (count < 6) then
                  if (t.Type == T_PERSON) then
                    if (t.Model > 2 and t.Model < 7 and t.Owner == s.Owner and not isFlagEnabled(t.Flags3, TF3_SHIELD_ACTIVE)) then
                      count=count+1
                      if (count > 0) then
                       last_thing = t
                       total_count=total_count+1
                      end
                    end
                  end
                  return true
                else return false
                end
              end)
              return true
            end)

            if (last_thing ~= nil and total_count > 2) then
              local thing_s = M_SPELL_SHIELD
              if (GET_NUM_ONE_OFF_SPELLS(s.Owner,M_SPELL_BLOODLUST) > 0) then
                thing_s = M_SPELL_BLOODLUST
                PThing.GiveShot(s.Owner,M_SPELL_BLOODLUST,-1)
              end
              createThing(T_SPELL,thing_s,s.Owner,last_thing.Pos.D3,false,false)
              spell_ms_used[i]=spell_ms_used[i]+1
              if (spell_ms_delay[i] == 0) then
                spell_ms_delay[i]=calc_limit(v)
              end
            end
          end
        end
      end
    end

    for i,v in ipairs(spell_ms_delay) do
      if (spell_ms_delay[i] > 0 and spell_ms_used[i] > 0) then
        spell_ms_delay[i]=v-1
      elseif(spell_ms_delay[i] == 0 and spell_ms_used[i] > 0) then
        spell_ms_delay[i]=calc_limit(i)
        spell_ms_used[i]=spell_ms_used[i]-1
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
            spell_delay[idx] = 48
          elseif(get_world_dist_xyz(t.Pos.D3, conv_center_pos[idx]) < 512*16 and get_thing_curr_cmd_list_ptr(s) == nil) then
            command_person_go_to_coord2d(s, t.Pos.D2)
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

function calc_limit(pn)
  if (_gsi.Players[pn].NumPeople > spell_ms_charge_time) then
    return 1 else return spell_ms_charge_time-_gsi.Players[pn].NumPeople
  end
end

function count_enemy_bldgs_around(myself,x,z,radiii)
  local count = 0
  local c3d = MAP_XZ_2_WORLD_XYZ(x,z)
  SearchMapCells(SQUARE,0,0,radiii,world_coord3d_to_map_idx(c3d),function(me)
    me.MapWhoList:processList(function(t)
      if (t.Type == T_BUILDING) then
        if (t.Owner ~= myself and are_players_allied(t.Owner,myself) == 0) then
          count=count+1
        end
      end
      return true
    end)
    return true
  end)
  return count
end

function count_people(myself,coord2,radii)
  local count = 0
  SearchMapCells(CIRCULAR, 0, 0, radii, world_coord3d_to_map_idx(coord2), function(me)
    me.MapWhoList:processList(function (t)
      if (t.Type == T_PERSON) then
        if (t.Owner ~= myself and are_players_allied(myself,t.Owner) == 0) then
          count = count+1
        end
      end
      return true
    end)
    return true
  end)

  return count
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
