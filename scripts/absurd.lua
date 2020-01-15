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

spell_delay = {0,0,0,0,0,0}
spell_ms_delay = {720,720,720,720,720,720}
spell_ms_used = {5,5,5,5,5,5}
spell_ms_radius = 3
spell_ms_max_use = 5
spell_ms_charge_time = 720
availableNums = {6}
big_attack = GetTurn() + (3072 + G_RANDOM(2048))
medium_attack = GetTurn() + (2048 + G_RANDOM(1024))
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

for i=0,3 do
  for j=0,3 do
    set_players_allied(i,j)
  end
end

for i = 4,4 do
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

SHAMAN_DEFEND(TRIBE_BLACK, 226, 76, TRUE)
SET_DRUM_TOWER_POS(TRIBE_BLACK, 226, 76)

function OnTurn()
  if (GetTurn() > STurn + 1) then
    if (GetTurn() > big_attack) then
      big_attack = GetTurn() + (3072 + G_RANDOM(2048))
      if (FREE_ENTRIES(TRIBE_BLACK) > 2) then
        if (MANA(TRIBE_BLACK) > 250000 and IS_SHAMAN_AVAILABLE_FOR_ATTACK(TRIBE_BLACK) > 0) then
          if (GET_HEIGHT_AT_POS(7) > 512) then
            WRITE_CP_ATTRIB(TRIBE_BLACK,ATTR_AWAY_MEDICINE_MAN,1)
            ATTACK(TRIBE_BLACK,TRIBE_GREEN,20,1,0,999,M_SPELL_EROSION,7,7,ATTACK_NORMAL,0,6,7,-1)
          else
            WRITE_CP_ATTRIB(TRIBE_BLACK,ATTR_AWAY_MEDICINE_MAN,1)
            ATTACK(TRIBE_BLACK,TRIBE_GREEN,10+G_RANDOM(30),1,0,999,7,7,7,ATTACK_NORMAL,0,6,-1,-1)
          end
        end
      end
    end

    if (GetTurn() > STurn + 5000) then
      if (GetTurn() > medium_attack) then
        medium_attack = GetTurn() + (2048 + G_RANDOM(1024))
        if (FREE_ENTRIES(TRIBE_BLACK) > 2) then
          if (IS_SHAMAN_AVAILABLE_FOR_ATTACK(TRIBE_BLACK) > 0) then
            if (count_troops(TRIBE_BLACK) > 8) then
              local path = G_RANDOM(4)
              if (path == 0) then
                if (GET_HEIGHT_AT_POS(9) == 0) then
                  WRITE_CP_ATTRIB(TRIBE_BLACK,ATTR_AWAY_MEDICINE_MAN,1)
                  ATTACK(TRIBE_BLACK,G_RANDOM(2),0,1,0,999,M_SPELL_LAND_BRIDGE,0,0,ATTACK_NORMAL,0,8,10,-1)
                else
                  if (GET_HEIGHT_AT_POS(12) == 0) then
                    WRITE_CP_ATTRIB(TRIBE_BLACK,ATTR_AWAY_MEDICINE_MAN,1)
                    ATTACK(TRIBE_BLACK,G_RANDOM(2),10,1,0,999,M_SPELL_LAND_BRIDGE,7,7,ATTACK_NORMAL,0,11,13,-1)
                  else
                    WRITE_CP_ATTRIB(TRIBE_BLACK,ATTR_AWAY_MEDICINE_MAN,1)
                    ATTACK(TRIBE_BLACK,G_RANDOM(2),10,1,0,999,7,7,7,ATTACK_NORMAL,0,11,-1,-1)
                  end
                end
              elseif (path == 1) then
                if (GET_HEIGHT_AT_POS(15) == 0) then
                  WRITE_CP_ATTRIB(TRIBE_BLACK,ATTR_AWAY_MEDICINE_MAN,1)
                  ATTACK(TRIBE_BLACK,G_RANDOM(2),0,1,0,999,M_SPELL_LAND_BRIDGE,0,0,ATTACK_NORMAL,0,14,16,-1)
                else
                  if (GET_HEIGHT_AT_POS(18) == 0) then
                    WRITE_CP_ATTRIB(TRIBE_BLACK,ATTR_AWAY_MEDICINE_MAN,1)
                    ATTACK(TRIBE_BLACK,G_RANDOM(2),10,1,0,999,M_SPELL_LAND_BRIDGE,7,7,ATTACK_NORMAL,0,17,19,-1)
                  else
                    WRITE_CP_ATTRIB(TRIBE_BLACK,ATTR_AWAY_MEDICINE_MAN,1)
                    ATTACK(TRIBE_BLACK,G_RANDOM(2),10,1,0,999,7,7,7,ATTACK_NORMAL,0,17,-1,-1)
                  end
                end
              elseif (path == 2) then
                if (GET_HEIGHT_AT_POS(21) == 0) then
                  WRITE_CP_ATTRIB(TRIBE_BLACK,ATTR_AWAY_MEDICINE_MAN,1)
                  ATTACK(TRIBE_BLACK,G_RANDOM(2),10,1,0,999,M_SPELL_LAND_BRIDGE,7,7,ATTACK_NORMAL,0,22,23,-1)
                else
                  WRITE_CP_ATTRIB(TRIBE_BLACK,ATTR_AWAY_MEDICINE_MAN,1)
                  ATTACK(TRIBE_BLACK,G_RANDOM(2),10,1,0,999,7,7,7,ATTACK_NORMAL,0,22,-1,-1)
                end
              elseif (path == 3) then
                if (GET_HEIGHT_AT_POS(25) == 0) then
                  WRITE_CP_ATTRIB(TRIBE_BLACK,ATTR_AWAY_MEDICINE_MAN,1)
                  ATTACK(TRIBE_BLACK,TRIBE_GREEN,10,1,0,999,M_SPELL_LAND_BRIDGE,7,7,ATTACK_NORMAL,0,24,26,-1)
                else
                  WRITE_CP_ATTRIB(TRIBE_BLACK,ATTR_AWAY_MEDICINE_MAN,1)
                  ATTACK(TRIBE_BLACK,TRIBE_GREEN,10,1,0,999,7,7,7,ATTACK_NORMAL,0,24,-1,-1)
                end
              end
            end
          end
        end
      end
    end

    if (every2Pow(9)) then
      if (PLAYERS_PEOPLE_OF_TYPE(TRIBE_BLACK, M_PERSON_BRAVE) > 20 and _gsi.Players[TRIBE_BLACK].NumPeople > 35) then
        WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_PREF_WARRIOR_TRAINS, 1)
        WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_PREF_WARRIOR_PEOPLE, 18+G_RANDOM(17))
        WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_PREF_RELIGIOUS_TRAINS, 1)
        WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_PREF_RELIGIOUS_PEOPLE, 15+G_RANDOM(15))
        WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_PREF_SUPER_WARRIOR_TRAINS, 1)
        WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_PREF_SUPER_WARRIOR_PEOPLE, 16+G_RANDOM(15))
        STATE_SET(TRIBE_BLACK, FALSE, CP_AT_TYPE_MED_MAN_GET_WILD_PEEPS)
      else
        WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_PREF_WARRIOR_TRAINS, 0)
        WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_PREF_WARRIOR_PEOPLE, 5)
        WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_PREF_RELIGIOUS_TRAINS, 0)
        WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_PREF_RELIGIOUS_PEOPLE, 5)
        WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_PREF_SUPER_WARRIOR_TRAINS, 0)
        WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_PREF_SUPER_WARRIOR_PEOPLE, 5)
        STATE_SET(TRIBE_BLACK, TRUE, CP_AT_TYPE_MED_MAN_GET_WILD_PEEPS)
      end

      if (READ_CP_ATTRIB(TRIBE_BLACK,ATTR_HOUSE_PERCENTAGE) < 160 and GetPlayerPeople(TRIBE_BLACK) > READ_CP_ATTRIB(TRIBE_BLACK,ATTR_HOUSE_PERCENTAGE)) then
        WRITE_CP_ATTRIB(TRIBE_BLACK,ATTR_HOUSE_PERCENTAGE,READ_CP_ATTRIB(TRIBE_BLACK,ATTR_HOUSE_PERCENTAGE)+2)
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
