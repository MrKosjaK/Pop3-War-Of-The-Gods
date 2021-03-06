import(Module_Players)
import(Module_Defines)
import(Module_PopScript)
import(Module_Game)
import(Module_Objects)
import(Module_Map)

include("UtilPThings.lua")
include("UtilRefs.lua")

local STurn = GetTurn()

wilds = {}
spell_delay = {0,0}
index = 1
numthings = 16
availaibleNums = {2,6}
botSpells = {M_SPELL_CONVERT_WILD,
                    M_SPELL_BLAST,
                    M_SPELL_LAND_BRIDGE,
                    M_SPELL_INSECT_PLAGUE
}
botBldgs = {M_BUILDING_TEPEE,
                   M_BUILDING_DRUM_TOWER,
                   M_BUILDING_WARRIOR_TRAIN
}


for i = 2,3 do
  for j = 0,1 do
    set_players_allied(i-2,j)
    set_players_allied(availaibleNums[i-1], availaibleNums[j+1])
  end

  for u,v in ipairs(botSpells) do
    PThing.SpellSet(TRIBE_BLACK, v, TRUE, FALSE)
  end

  for y,v in ipairs(botBldgs) do
    PThing.BldgSet(TRIBE_BLACK, v, TRUE)
  end

  computer_init_player(_gsi.Players[TRIBE_BLACK])

  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_EXPANSION, 12+G_RANDOM(8))
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_HOUSE_PERCENTAGE, 24+G_RANDOM(12))
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_MAX_BUILDINGS_ON_GO, 5+G_RANDOM(5))
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_PREF_WARRIOR_TRAINS, 1)
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_PREF_WARRIOR_PEOPLE, 15+G_RANDOM(15))
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_PREF_RELIGIOUS_TRAINS, 0)
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_PREF_RELIGIOUS_PEOPLE, 0)
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_PREF_SUPER_WARRIOR_TRAINS, 0)
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_PREF_SUPER_WARRIOR_PEOPLE, 0)
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_PREF_SPY_TRAINS, 0)
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_PREF_SPY_PEOPLE, 0)
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_BRAVE, 5)
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_WARRIOR, 80)
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_RELIGIOUS, 0)
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_SUPER_WARRIOR, 0)
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_SPY, 0)
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_MEDICINE_MAN, 100)
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_USE_PREACHER_FOR_DEFENCE, 1)
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_DEFENSE_RAD_INCR, 4)
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_MAX_DEFENSIVE_ACTIONS, 3)
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_ATTACK_PERCENTAGE, 100)
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_MAX_ATTACKS, 4)
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_RETREAT_VALUE, 25)
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_BASE_UNDER_ATTACK_RETREAT, 0)
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_RANDOM_BUILD_SIDE, 1)
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_GROUP_OPTION, 0)
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_PEOPLE_PER_BOAT, 7)
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_PEOPLE_PER_BALLOON, 5)
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_ENEMY_SPY_MAX_STAND, 255)
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_SPY_CHECK_FREQUENCY, 128)
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_SPY_DISCOVER_CHANCE, 10)
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_MAX_TRAIN_AT_ONCE, 3)
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_SHAMEN_BLAST, 8)

  STATE_SET(TRIBE_BLACK, TRUE, CP_AT_TYPE_FETCH_WOOD)
  STATE_SET(TRIBE_BLACK, TRUE, CP_AT_TYPE_CONSTRUCT_BUILDING)
  STATE_SET(TRIBE_BLACK, TRUE, CP_AT_TYPE_BUILD_OUTER_DEFENCES)
  STATE_SET(TRIBE_BLACK, TRUE, CP_AT_TYPE_DEFEND)
  STATE_SET(TRIBE_BLACK, TRUE, CP_AT_TYPE_DEFEND_BASE)
  STATE_SET(TRIBE_BLACK, TRUE, CP_AT_TYPE_PREACH)
  STATE_SET(TRIBE_BLACK, TRUE, CP_AT_TYPE_BRING_NEW_PEOPLE_BACK)
  STATE_SET(TRIBE_BLACK, TRUE, CP_AT_TYPE_SUPER_DEFEND)
  STATE_SET(TRIBE_BLACK, TRUE, CP_AT_TYPE_TRAIN_PEOPLE)
  STATE_SET(TRIBE_BLACK, TRUE, CP_AT_TYPE_AUTO_ATTACK)
  STATE_SET(TRIBE_BLACK, TRUE, CP_AT_TYPE_HOUSE_A_PERSON)
  STATE_SET(TRIBE_BLACK, TRUE, CP_AT_TYPE_POPULATE_DRUM_TOWER)
  STATE_SET(TRIBE_BLACK, TRUE, CP_AT_TYPE_FETCH_LOST_PEOPLE)
  STATE_SET(TRIBE_BLACK, TRUE, CP_AT_TYPE_MED_MAN_GET_WILD_PEEPS)

  SET_BUCKET_USAGE(TRIBE_BLACK, TRUE)
  SET_BUCKET_COUNT_FOR_SPELL(TRIBE_BLACK, M_SPELL_BLAST, 8)
  SET_BUCKET_COUNT_FOR_SPELL(TRIBE_BLACK, M_SPELL_CONVERT_WILD, 8)
  SET_BUCKET_COUNT_FOR_SPELL(TRIBE_BLACK, M_SPELL_INSECT_PLAGUE, 16)
  SET_BUCKET_COUNT_FOR_SPELL(TRIBE_BLACK, M_SPELL_LAND_BRIDGE, 32)

  SET_DEFENCE_RADIUS(TRIBE_BLACK, 7)
end

SET_SPELL_ENTRY(TRIBE_BLACK, 0, M_SPELL_INSECT_PLAGUE, 25000, 64, 3, 0)
SET_SPELL_ENTRY(TRIBE_BLACK, 1, M_SPELL_INSECT_PLAGUE, 25000, 64, 3, 1)
SHAMAN_DEFEND(TRIBE_BLACK, 60, 124, TRUE)
SET_DRUM_TOWER_POS(TRIBE_BLACK, 60, 124)

function OnTurn()
  if (every2Pow(11)) then
    if (GetTurn() > STurn + (12 * 300)) then
      if (_gsi.Players[TRIBE_BLACK].NumPeople > 45) then
        if (IS_SHAMAN_AVAILABLE_FOR_ATTACK(TRIBE_BLACK) == 1) then
          if (GET_HEIGHT_AT_POS(2) > 0) then
            WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_MEDICINE_MAN, 100)
            ATTACK(TRIBE_BLACK, G_RANDOM(2), 6+G_RANDOM(12), ATTACK_BUILDING, -1, 250+G_RANDOM(700), M_SPELL_INSECT_PLAGUE, M_SPELL_INSECT_PLAGUE, M_SPELL_INSECT_PLAGUE, ATTACK_NORMAL, 0, 1, NO_MARKER, NO_MARKER)
          end
        end
      end
    end
  end

  if (every2Pow(8)) then
    if (GET_HEIGHT_AT_POS(2) > 0) then
      if (PLAYERS_PEOPLE_OF_TYPE(TRIBE_BLACK, M_PERSON_WARRIOR) > 3) then
        WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_MEDICINE_MAN, 0)
        ATTACK(TRIBE_BLACK, G_RANDOM(2), 1+G_RANDOM(3), ATTACK_BUILDING, -1, 250+G_RANDOM(700), M_SPELL_NONE, M_SPELL_NONE, M_SPELL_NONE, ATTACK_NORMAL, 0, 1, NO_MARKER, NO_MARKER)
      end
    end
  end

  if (every2Pow(9)) then
    ProcessGlobalTypeList(T_BUILDING, function(t)
      if (t.Model < 4 and t.Owner > 1) then
        if (t.u.Bldg.SproggingCount < 2000) then
          t.u.Bldg.SproggingCount = t.u.Bldg.SproggingCount + 750
        end
      end

      return true
    end)

    if (COUNT_PEOPLE_IN_MARKER(TRIBE_BLACK, TRIBE_BLUE, 8, 2) +
        COUNT_PEOPLE_IN_MARKER(TRIBE_BLACK, TRIBE_RED, 8, 2) > 0) then
      WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_MEDICINE_MAN, 100)
      ATTACK(TRIBE_BLACK, G_RANDOM(2), 1+G_RANDOM(3), ATTACK_BUILDING, -1, 250+G_RANDOM(700), M_SPELL_BLAST, M_SPELL_BLAST, M_SPELL_BLAST, ATTACK_NORMAL, 0, NO_MARKER, NO_MARKER, NO_MARKER)
    end
  end

  if (every2Pow(3)) then
    if (_gsi.Players[TRIBE_YELLOW].NumPeople +
        _gsi.Players[TRIBE_BLACK].NumPeople < 70 and
        GetTurn() < STurn + (12*60)*2 and
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
        local idx = G_RANDOM(2)+1
        local s = getShaman(availaibleNums[idx])
        if (s ~= nil) then
          if(get_world_dist_xyz(t.Pos.D3, s.Pos.D3) < (8192 + s.Pos.D3.Ypos*3) and spell_delay[idx] == 0) then
            createThing(T_SPELL, M_SPELL_CONVERT_WILD, s.Owner, t.Pos.D3, false, false)
            if (s.Owner == TRIBE_BLACK) then
              spell_delay[2] = 96
            else
              spell_delay[1] = 96
            end
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
