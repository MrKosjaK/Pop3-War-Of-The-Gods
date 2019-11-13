import(Module_Players)
import(Module_Defines)
import(Module_PopScript)
import(Module_Game)
import(Module_Objects)
import(Module_Map)

include("UtilPThings.lua")

wilds = {}
spell_delay = 0
attack_idx = 0
index = 1
numthings = 16
mark_towers_planned = FALSE
botSpells = {M_SPELL_CONVERT_WILD,
                    M_SPELL_BLAST,
                    M_SPELL_LAND_BRIDGE,
                    M_SPELL_INSECT_PLAGUE
}
botBldgs = {M_BUILDING_TEPEE,
                   M_BUILDING_DRUM_TOWER,
                   M_BUILDING_WARRIOR_TRAIN,
                   M_BUILDING_TEMPLE
}


for i = 2,3 do
  for j = 0,1 do
    set_players_allied(i-2,j)
  end
  
  for u,v in ipairs(botSpells) do
    PThing.SpellSet(TRIBE_ORANGE, v, TRUE, FALSE)
  end
  
  for y,v in ipairs(botBldgs) do
    PThing.BldgSet(TRIBE_ORANGE, v, TRUE)
  end
  
  computer_init_player(_gsi.Players[TRIBE_ORANGE])
  
  WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_EXPANSION, 12+G_RANDOM(8))
  WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_HOUSE_PERCENTAGE, 29+G_RANDOM(27))
  WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_MAX_BUILDINGS_ON_GO, 5+G_RANDOM(5))
  WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_PREF_WARRIOR_TRAINS, 1)
  WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_PREF_WARRIOR_PEOPLE, 15+G_RANDOM(22))
  WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_PREF_RELIGIOUS_TRAINS, 1)
  WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_PREF_RELIGIOUS_PEOPLE, 12+G_RANDOM(15))
  WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_PREF_SUPER_WARRIOR_TRAINS, 0)
  WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_PREF_SUPER_WARRIOR_PEOPLE, 0)
  WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_PREF_SPY_TRAINS, 0)
  WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_PREF_SPY_PEOPLE, 0)
  WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_AWAY_BRAVE, 5)
  WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_AWAY_WARRIOR, 80)
  WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_AWAY_RELIGIOUS, 80)
  WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_AWAY_SUPER_WARRIOR, 0)
  WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_AWAY_SPY, 0)
  WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_AWAY_MEDICINE_MAN, 100)
  WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_USE_PREACHER_FOR_DEFENCE, 1)
  WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_DEFENSE_RAD_INCR, 4)
  WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_MAX_DEFENSIVE_ACTIONS, 3)
  WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_ATTACK_PERCENTAGE, 100)
  WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_MAX_ATTACKS, 4)
  WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_RETREAT_VALUE, 25)
  WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_BASE_UNDER_ATTACK_RETREAT, 0)
  WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_RANDOM_BUILD_SIDE, 1)
  WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_GROUP_OPTION, 0)
  WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_PEOPLE_PER_BOAT, 7)
  WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_PEOPLE_PER_BALLOON, 5)
  WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_ENEMY_SPY_MAX_STAND, 255)
  WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_SPY_CHECK_FREQUENCY, 128)
  WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_SPY_DISCOVER_CHANCE, 10)
  WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_MAX_TRAIN_AT_ONCE, 3)
  WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_SHAMEN_BLAST, 8)
  
  STATE_SET(TRIBE_ORANGE, TRUE, CP_AT_TYPE_FETCH_WOOD)
  STATE_SET(TRIBE_ORANGE, TRUE, CP_AT_TYPE_CONSTRUCT_BUILDING)
  STATE_SET(TRIBE_ORANGE, TRUE, CP_AT_TYPE_BUILD_OUTER_DEFENCES)
  STATE_SET(TRIBE_ORANGE, TRUE, CP_AT_TYPE_DEFEND)
  STATE_SET(TRIBE_ORANGE, TRUE, CP_AT_TYPE_DEFEND_BASE)
  STATE_SET(TRIBE_ORANGE, TRUE, CP_AT_TYPE_PREACH)
  STATE_SET(TRIBE_ORANGE, TRUE, CP_AT_TYPE_BRING_NEW_PEOPLE_BACK)
  STATE_SET(TRIBE_ORANGE, TRUE, CP_AT_TYPE_SUPER_DEFEND)
  STATE_SET(TRIBE_ORANGE, TRUE, CP_AT_TYPE_TRAIN_PEOPLE)
  STATE_SET(TRIBE_ORANGE, TRUE, CP_AT_TYPE_AUTO_ATTACK)
  STATE_SET(TRIBE_ORANGE, TRUE, CP_AT_TYPE_HOUSE_A_PERSON)
  STATE_SET(TRIBE_ORANGE, TRUE, CP_AT_TYPE_POPULATE_DRUM_TOWER)
  STATE_SET(TRIBE_ORANGE, TRUE, CP_AT_TYPE_FETCH_LOST_PEOPLE)
  STATE_SET(TRIBE_ORANGE, TRUE, CP_AT_TYPE_MED_MAN_GET_WILD_PEEPS)
  
  SET_BUCKET_USAGE(TRIBE_ORANGE, TRUE)
  SET_BUCKET_COUNT_FOR_SPELL(TRIBE_ORANGE, M_SPELL_BLAST, 8)
  SET_BUCKET_COUNT_FOR_SPELL(TRIBE_ORANGE, M_SPELL_CONVERT_WILD, 8)
  SET_BUCKET_COUNT_FOR_SPELL(TRIBE_ORANGE, M_SPELL_INSECT_PLAGUE, 16)
  SET_BUCKET_COUNT_FOR_SPELL(TRIBE_ORANGE, M_SPELL_LAND_BRIDGE, 32)
  
  SET_DEFENCE_RADIUS(TRIBE_ORANGE, 7)
end

SET_SPELL_ENTRY(TRIBE_ORANGE, 0, M_SPELL_INSECT_PLAGUE, 25000, 64, 3, 0)
SET_SPELL_ENTRY(TRIBE_ORANGE, 1, M_SPELL_INSECT_PLAGUE, 25000, 64, 3, 1)
SHAMAN_DEFEND(TRIBE_ORANGE, 148, 70, TRUE)
SET_DRUM_TOWER_POS(TRIBE_ORANGE, 148, 70)

SET_MARKER_ENTRY(TRIBE_ORANGE, 0, 1, 2, 0, 3, 0, 2)
SET_MARKER_ENTRY(TRIBE_ORANGE, 1, 3, 4, 0, 3, 0, 3)
SET_MARKER_ENTRY(TRIBE_ORANGE, 2, 5, 6, 0, 2, 0, 2)
SET_MARKER_ENTRY(TRIBE_ORANGE, 3, 7, 8, 0, 2, 0, 3)
SET_MARKER_ENTRY(TRIBE_ORANGE, 4, 12, 13, 0, 2, 0, 3)

function OnTurn()
  if (EVERY_2POW_TURNS(11) and _gsi.Counts.GameTurn > 120) then
    attack_idx = G_RANDOM(3)
    if (attack_idx == 0) then
      if (GET_HEIGHT_AT_POS(9) == 0) then
        WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_AWAY_MEDICINE_MAN, 100)
        ATTACK(TRIBE_ORANGE, G_RANDOM(2), 3+G_RANDOM(12), ATTACK_BUILDING, T_MODEL_NONE, 250+G_RANDOM(700), M_SPELL_LAND_BRIDGE, M_SPELL_INSECT_PLAGUE, M_SPELL_INSECT_PLAGUE, ATTACK_NORMAL, 0, 10, 11, NO_MARKER)
      else
        WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_AWAY_MEDICINE_MAN, 100)
        ATTACK(TRIBE_ORANGE, G_RANDOM(2), 4+G_RANDOM(12), ATTACK_BUILDING, T_MODEL_NONE, 250+G_RANDOM(700), M_SPELL_BLAST, M_SPELL_INSECT_PLAGUE, M_SPELL_INSECT_PLAGUE, ATTACK_NORMAL, 0, 10, NO_MARKER, NO_MARKER)
      end
    elseif (attack_idx == 1) then
      ATTACK(TRIBE_ORANGE, G_RANDOM(2), 4+G_RANDOM(12), ATTACK_BUILDING, T_MODEL_NONE, 250+G_RANDOM(700), M_SPELL_INSECT_PLAGUE, M_SPELL_INSECT_PLAGUE, M_SPELL_INSECT_PLAGUE, ATTACK_NORMAL, 0, NO_MARKER, NO_MARKER, NO_MARKER)
    elseif (attack_idx == 2) then
      if (_gsi.Players[TRIBE_ORANGE].NumPeople > 60) then
        ATTACK(TRIBE_ORANGE, G_RANDOM(2), 12+G_RANDOM(18), ATTACK_BUILDING, T_MODEL_NONE, 250+G_RANDOM(700), M_SPELL_INSECT_PLAGUE, M_SPELL_INSECT_PLAGUE, M_SPELL_INSECT_PLAGUE, ATTACK_NORMAL, 0, NO_MARKER, NO_MARKER, NO_MARKER)
      else
          ATTACK(TRIBE_ORANGE, G_RANDOM(2), 4+G_RANDOM(12), ATTACK_BUILDING, T_MODEL_NONE, 250+G_RANDOM(700), M_SPELL_INSECT_PLAGUE, M_SPELL_INSECT_PLAGUE, M_SPELL_INSECT_PLAGUE, ATTACK_NORMAL, 0, NO_MARKER, NO_MARKER, NO_MARKER)
      end
    end
  end
  
  if (EVERY_2POW_TURNS(10)) then
    if (_gsi.Counts.GameTurn > 12*120 and mark_towers_planned == FALSE) then
      BUILD_DRUM_TOWER(TRIBE_ORANGE, 198, 68)
      BUILD_DRUM_TOWER(TRIBE_ORANGE, 186, 42)
      mark_towers_planned = TRUE
    end
  end
  
  if (EVERY_2POW_TURNS(9)) then
    if (mark_towers_planned == TRUE) then
      if (PLAYERS_PEOPLE_OF_TYPE(TRIBE_ORANGE, M_PERSON_WARRIOR) > 5 and
          PLAYERS_PEOPLE_OF_TYPE(TRIBE_ORANGE, M_PERSON_RELIGIOUS) > 5) then
        MARKER_ENTRIES(TRIBE_ORANGE, 0, 1, 2, 3)
        
        if (GET_HEIGHT_AT_POS(9) > 0) then
          MARKER_ENTRIES(TRIBE_ORANGE, 4, -1, -1, -1)
        end
      end
    end
  end
  
  if (EVERY_2POW_TURNS(7)) then
    ProcessGlobalTypeList(T_BUILDING, function(t)
      if (t.Model < 4 and t.Owner == TRIBE_ORANGE) then
        if (t.u.Bldg.SproggingCount < 2000) then
          t.u.Bldg.SproggingCount = t.u.Bldg.SproggingCount + 750
        end
      end
      
      return true
    end)
  end
  
  if (EVERY_2POW_TURNS(6)) then
    local shaman = getShaman(TRIBE_ORANGE)
    if (shaman ~= nil) then
      ProcessGlobalTypeList(T_PERSON, function(t)
        if (t.Owner < 2 and t.Model ~= M_PERSON_WILD) then
          if (get_world_dist_xyz(shaman.Pos.D3, t.Pos.D3) < 3092 + shaman.Pos.D3.Ypos*3) then
            if (spell_delay == 0 and is_thing_on_ground(shaman) == 1) then
              createThing(T_SPELL, M_SPELL_BLAST, shaman.Owner, t.Pos.D3, false, false)
              return false
            end
           end
        end
        
        return true
      end)
    end
  end
  
  if (EVERY_2POW_TURNS(3)) then
    if (_gsi.Players[TRIBE_ORANGE].NumPeople < 70 and
        _gsi.Counts.GameTurn < (12*60)*2 and
        _gsi.Counts.GameTurn > (12*10)) then
      process(numthings)
    end
  end
  
  if (spell_delay > 0) then
    spell_delay = spell_delay - 1
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
        local s = getShaman(TRIBE_ORANGE)
        if (s ~= nil) then
          if(get_world_dist_xyz(t.Pos.D3, s.Pos.D3) < (8192 + s.Pos.D3.Ypos*3) and spell_delay == 0) then
            createThing(T_SPELL, M_SPELL_CONVERT_WILD, s.Owner, t.Pos.D3, false, false)
            spell_delay = 18
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

function tablelength(te)
  local count = 0
  for _ in pairs(te) do count = count + 1 end
  return count
end