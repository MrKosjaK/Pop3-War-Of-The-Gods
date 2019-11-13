import(Module_Players)
import(Module_Defines)
import(Module_PopScript)
import(Module_Game)
import(Module_Objects)
import(Module_Map)

include("UtilPThings.lua")

wilds = {}
spell_delay = {0,0,0}
index = 1
numthings = 16
botSpells = {M_SPELL_CONVERT_WILD,
                    M_SPELL_BLAST,
                    M_SPELL_LAND_BRIDGE
}
botBldgs = {M_BUILDING_TEPEE,
                   M_BUILDING_DRUM_TOWER,
                   M_BUILDING_WARRIOR_TRAIN
}

heightCache = {GET_HEIGHT_AT_POS(12),
                      GET_HEIGHT_AT_POS(14)
}

for i = 2,3 do
  for j = 0,2 do
    set_players_allied(i-2,j)
    set_players_allied(i+2,j+4)
  end
  
  for u,v in ipairs(botSpells) do
    PThing.SpellSet(i+2, v, TRUE, FALSE)
  end
  
  for y,v in ipairs(botBldgs) do
    PThing.BldgSet(i+2, v, TRUE)
  end
  
  computer_init_player(_gsi.Players[i+2])
  
  WRITE_CP_ATTRIB(i+2, ATTR_EXPANSION, 12+G_RANDOM(8))
  WRITE_CP_ATTRIB(i+2, ATTR_HOUSE_PERCENTAGE, 24+G_RANDOM(30))
  WRITE_CP_ATTRIB(i+2, ATTR_MAX_BUILDINGS_ON_GO, 5+G_RANDOM(5))
  WRITE_CP_ATTRIB(i+2, ATTR_PREF_WARRIOR_TRAINS, 1)
  WRITE_CP_ATTRIB(i+2, ATTR_PREF_WARRIOR_PEOPLE, 15+G_RANDOM(15))
  WRITE_CP_ATTRIB(i+2, ATTR_PREF_RELIGIOUS_TRAINS, 0)
  WRITE_CP_ATTRIB(i+2, ATTR_PREF_RELIGIOUS_PEOPLE, 0)
  WRITE_CP_ATTRIB(i+2, ATTR_PREF_SUPER_WARRIOR_TRAINS, 0)
  WRITE_CP_ATTRIB(i+2, ATTR_PREF_SUPER_WARRIOR_PEOPLE, 0)
  WRITE_CP_ATTRIB(i+2, ATTR_PREF_SPY_TRAINS, 0)
  WRITE_CP_ATTRIB(i+2, ATTR_PREF_SPY_PEOPLE, 0)
  WRITE_CP_ATTRIB(i+2, ATTR_AWAY_BRAVE, 5)
  WRITE_CP_ATTRIB(i+2, ATTR_AWAY_WARRIOR, 80)
  WRITE_CP_ATTRIB(i+2, ATTR_AWAY_RELIGIOUS, 0)
  WRITE_CP_ATTRIB(i+2, ATTR_AWAY_SUPER_WARRIOR, 0)
  WRITE_CP_ATTRIB(i+2, ATTR_AWAY_SPY, 0)
  WRITE_CP_ATTRIB(i+2, ATTR_AWAY_MEDICINE_MAN, 100)
  WRITE_CP_ATTRIB(i+2, ATTR_USE_PREACHER_FOR_DEFENCE, 1)
  WRITE_CP_ATTRIB(i+2, ATTR_DEFENSE_RAD_INCR, 4)
  WRITE_CP_ATTRIB(i+2, ATTR_MAX_DEFENSIVE_ACTIONS, 3)
  WRITE_CP_ATTRIB(i+2, ATTR_ATTACK_PERCENTAGE, 100)
  WRITE_CP_ATTRIB(i+2, ATTR_MAX_ATTACKS, 4)
  WRITE_CP_ATTRIB(i+2, ATTR_RETREAT_VALUE, 25)
  WRITE_CP_ATTRIB(i+2, ATTR_BASE_UNDER_ATTACK_RETREAT, 0)
  WRITE_CP_ATTRIB(i+2, ATTR_RANDOM_BUILD_SIDE, 1)
  WRITE_CP_ATTRIB(i+2, ATTR_GROUP_OPTION, 0)
  WRITE_CP_ATTRIB(i+2, ATTR_PEOPLE_PER_BOAT, 7)
  WRITE_CP_ATTRIB(i+2, ATTR_PEOPLE_PER_BALLOON, 5)
  WRITE_CP_ATTRIB(i+2, ATTR_ENEMY_SPY_MAX_STAND, 255)
  WRITE_CP_ATTRIB(i+2, ATTR_SPY_CHECK_FREQUENCY, 128)
  WRITE_CP_ATTRIB(i+2, ATTR_SPY_DISCOVER_CHANCE, 10)
  WRITE_CP_ATTRIB(i+2, ATTR_MAX_TRAIN_AT_ONCE, 3)
  WRITE_CP_ATTRIB(i+2, ATTR_SHAMEN_BLAST, 8)
  
  STATE_SET(i+2, TRUE, CP_AT_TYPE_FETCH_WOOD)
  STATE_SET(i+2, TRUE, CP_AT_TYPE_CONSTRUCT_BUILDING)
  STATE_SET(i+2, TRUE, CP_AT_TYPE_BUILD_OUTER_DEFENCES)
  STATE_SET(i+2, TRUE, CP_AT_TYPE_DEFEND)
  STATE_SET(i+2, TRUE, CP_AT_TYPE_DEFEND_BASE)
  STATE_SET(i+2, TRUE, CP_AT_TYPE_PREACH)
  STATE_SET(i+2, TRUE, CP_AT_TYPE_BRING_NEW_PEOPLE_BACK)
  STATE_SET(i+2, TRUE, CP_AT_TYPE_SUPER_DEFEND)
  STATE_SET(i+2, TRUE, CP_AT_TYPE_TRAIN_PEOPLE)
  STATE_SET(i+2, TRUE, CP_AT_TYPE_AUTO_ATTACK)
  STATE_SET(i+2, TRUE, CP_AT_TYPE_HOUSE_A_PERSON)
  STATE_SET(i+2, TRUE, CP_AT_TYPE_POPULATE_DRUM_TOWER)
  STATE_SET(i+2, TRUE, CP_AT_TYPE_FETCH_LOST_PEOPLE)
  STATE_SET(i+2, TRUE, CP_AT_TYPE_MED_MAN_GET_WILD_PEEPS)
  
  SET_BUCKET_USAGE(i+2, TRUE)
  SET_BUCKET_COUNT_FOR_SPELL(i+2, M_SPELL_BLAST, 8)
  SET_BUCKET_COUNT_FOR_SPELL(i+2, M_SPELL_CONVERT_WILD, 8)
  
  SET_DEFENCE_RADIUS(i+2, 7)
end

SHAMAN_DEFEND(TRIBE_CYAN, 230, 244, TRUE)
SHAMAN_DEFEND(TRIBE_PINK, 28, 12, TRUE)
SET_DRUM_TOWER_POS(TRIBE_CYAN, 230, 244)
SET_DRUM_TOWER_POS(TRIBE_PINK, 28, 12)

function OnTurn()
  if (EVERY_2POW_TURNS(11)) then
    local h1 = GET_HEIGHT_AT_POS(12)
    local h2 = GET_HEIGHT_AT_POS(14)
    if (MANA(TRIBE_PINK) > SPELL_COST(M_SPELL_LAND_BRIDGE)) then
      if (h1 == heightCache[1]) then
        ATTACK(TRIBE_PINK, G_RANDOM(2), 0, ATTACK_BUILDING, -1, 0, M_SPELL_LAND_BRIDGE, M_SPELL_NONE, M_SPELL_NONE, ATTACK_NORMAL, 0, 11, 13, -1)
      else
        if (h2 == heightCache[2]) then
          ATTACK(TRIBE_PINK, G_RANDOM(2), 0, ATTACK_BUILDING, -1, 0, M_SPELL_LAND_BRIDGE, M_SPELL_NONE, M_SPELL_NONE, ATTACK_NORMAL, 0, 13, 15, -1)
        else
          ATTACK(TRIBE_PINK, G_RANDOM(2), 5+G_RANDOM(10), ATTACK_BUILDING, -1, 250+G_RANDOM(700), M_SPELL_BLAST, M_SPELL_BLAST, M_SPELL_BLAST, ATTACK_NORMAL, 0, 11, -1, -1)
        end
      end
    end
    
    if (h1 ~= heightCache[1] and h2 ~= heightCache[2]) then
      ATTACK(TRIBE_CYAN, G_RANDOM(2), 6+G_RANDOM(12), ATTACK_BUILDING, -1, 250+G_RANDOM(700), M_SPELL_BLAST, M_SPELL_BLAST, M_SPELL_BLAST, ATTACK_NORMAL, 0, 11, -1, -1)
    end
  end
  
  if (EVERY_2POW_TURNS(9)) then
    ProcessGlobalTypeList(T_BUILDING, function(t)
      if (t.Model < 4 and t.Owner > 2) then
        if (t.u.Bldg.SproggingCount < 2000) then
          t.u.Bldg.SproggingCount = t.u.Bldg.SproggingCount+750
        end
      end
      
      return true
    end)
  end
  
  if (EVERY_2POW_TURNS(3)) then
    if (_gsi.Players[TRIBE_GREEN].NumPeople +
        _gsi.Players[TRIBE_CYAN].NumPeople +
        _gsi.Players[TRIBE_PINK].NumPeople < 80 and
        _gsi.Counts.GameTurn < (12*60)*2 and
        _gsi.Counts.GameTurn > (12*10)) then
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
        local s = getShaman(G_RANDOM(3)+3)
        if (s ~= nil) then
          if(get_world_dist_xyz(t.Pos.D3, s.Pos.D3) < (8192 + s.Pos.D3.Ypos*3) and spell_delay[s.Owner-2] == 0 and MANA(s.Owner) > 2000) then
            createThing(T_SPELL, M_SPELL_CONVERT_WILD, s.Owner, t.Pos.D3, false, false)
            _gsi.Players[s.Owner].Mana = _gsi.Players[s.Owner].Mana - 2000
            spell_delay[s.Owner-2] = 32
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