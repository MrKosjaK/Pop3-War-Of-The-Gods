import(Module_Defines)
import(Module_PopScript)
import(Module_Game)
import(Module_Person)
import(Module_Objects)
import(Module_Map)
import(Module_MapWho)
import(Module_Draw)

include("UtilPThings.lua")

_constants.MaxManaValue = 2500000
_constants.ShamenDeadManaPer256Gained = 16

availableNums = {4,5}
SET_TIMER_GOING((12*60)*15,1)
prisons = {}
penalty = false
timer_removed = false
tip_shown1 = false
tip_shown2 = false
index = 1

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
  SET_NO_REINC(i)
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
  end
  
  for y,v in ipairs(botBldgs) do
    PThing.BldgSet(availableNums[i-3], v, TRUE)
  end
  
  computer_init_player(_gsi.Players[availableNums[i-3]])
  
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_EXPANSION, 24+G_RANDOM(16))
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_HOUSE_PERCENTAGE, 5+G_RANDOM(38))
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_MAX_BUILDINGS_ON_GO, 6+G_RANDOM(5))
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_PREF_WARRIOR_TRAINS, 0)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_PREF_WARRIOR_PEOPLE, 0)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_PREF_RELIGIOUS_TRAINS, 0)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_PREF_RELIGIOUS_PEOPLE, 0)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_PREF_SUPER_WARRIOR_TRAINS, 1)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_PREF_SUPER_WARRIOR_PEOPLE, 30)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_PREF_SPY_TRAINS, 0)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_PREF_SPY_PEOPLE, 0)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_AWAY_BRAVE, 5)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_AWAY_WARRIOR, 80)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_AWAY_RELIGIOUS, 69)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_AWAY_SUPER_WARRIOR, 87)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_AWAY_SPY, 0)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_AWAY_MEDICINE_MAN, 100)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_USE_PREACHER_FOR_DEFENCE, 1)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_DEFENSE_RAD_INCR, 4)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_MAX_DEFENSIVE_ACTIONS, 0)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_ATTACK_PERCENTAGE, 125)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_MAX_ATTACKS, 15)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_RETREAT_VALUE, 0)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_BASE_UNDER_ATTACK_RETREAT, 0)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_RANDOM_BUILD_SIDE, 1)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_GROUP_OPTION, 0)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_PEOPLE_PER_BOAT, 8)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_PEOPLE_PER_BALLOON, 7)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_ENEMY_SPY_MAX_STAND, 255)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_SPY_CHECK_FREQUENCY, 128)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_SPY_DISCOVER_CHANCE, 5)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_MAX_TRAIN_AT_ONCE, 3)
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
  STATE_SET(availableNums[i-3], FALSE, CP_AT_TYPE_MED_MAN_GET_WILD_PEEPS)
  
  SET_BUCKET_USAGE(availableNums[i-3], TRUE)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-3], M_SPELL_BLAST, 8)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-3], M_SPELL_CONVERT_WILD, 8)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-3], M_SPELL_GHOST_ARMY, 12)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-3], M_SPELL_INSECT_PLAGUE, 16)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-3], M_SPELL_SHIELD, 20)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-3], M_SPELL_LAND_BRIDGE, 32)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-3], M_SPELL_LIGHTNING_BOLT, 40)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-3], M_SPELL_INVISIBILITY, 28)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-3], M_SPELL_HYPNOTISM, 70)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-3], M_SPELL_WHIRLWIND, 80)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-3], M_SPELL_SWAMP, 100)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-3], M_SPELL_EARTHQUAKE, 175)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-3], M_SPELL_EROSION, 200)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-3], M_SPELL_FIRESTORM, 400)
  SET_NO_REINC(availableNums[i-3])
end

SHAMAN_DEFEND(TRIBE_CYAN, 244, 70, TRUE)
SHAMAN_DEFEND(TRIBE_PINK, 202, 70, TRUE)
SET_DRUM_TOWER_POS(TRIBE_CYAN, 244, 70)
SET_DRUM_TOWER_POS(TRIBE_PINK, 202, 70)

GUARD_BETWEEN_MARKERS(TRIBE_CYAN, 10, -1, 0, 0, 4, 0, GUARD_NORMAL)
GUARD_BETWEEN_MARKERS(TRIBE_CYAN, 9, -1, 0, 0, 4, 0, GUARD_NORMAL)
GUARD_BETWEEN_MARKERS(TRIBE_CYAN, 8, -1, 0, 0, 4, 0, GUARD_NORMAL)
GUARD_BETWEEN_MARKERS(TRIBE_CYAN, 7, -1, 0, 3, 0, 0, GUARD_NORMAL)
GUARD_BETWEEN_MARKERS(TRIBE_CYAN, 6, -1, 0, 3, 0, 0, GUARD_NORMAL)
GUARD_BETWEEN_MARKERS(TRIBE_CYAN, 5, -1, 0, 3, 0, 0, GUARD_NORMAL)
GUARD_BETWEEN_MARKERS(TRIBE_CYAN, 4, -1, 0, 0, 4, 0, GUARD_NORMAL)
GUARD_BETWEEN_MARKERS(TRIBE_CYAN, 3, -1, 0, 0, 4, 0, GUARD_NORMAL)
GUARD_BETWEEN_MARKERS(TRIBE_CYAN, 2, -1, 0, 0, 4, 0, GUARD_NORMAL)
PREACH_AT_MARKER(TRIBE_CYAN, 2)
PREACH_AT_MARKER(TRIBE_CYAN, 3)
PREACH_AT_MARKER(TRIBE_CYAN, 4)
PREACH_AT_MARKER(TRIBE_CYAN, 5)
PREACH_AT_MARKER(TRIBE_CYAN, 6)
PREACH_AT_MARKER(TRIBE_CYAN, 7)

GUARD_BETWEEN_MARKERS(TRIBE_PINK, 20, -1, 0, 0, 3, 0, GUARD_NORMAL)
GUARD_BETWEEN_MARKERS(TRIBE_PINK, 19, -1, 0, 0, 3, 0, GUARD_NORMAL)
GUARD_BETWEEN_MARKERS(TRIBE_PINK, 18, -1, 0, 0, 3, 0, GUARD_NORMAL)
GUARD_BETWEEN_MARKERS(TRIBE_PINK, 17, -1, 0, 0, 3, 0, GUARD_NORMAL)
GUARD_BETWEEN_MARKERS(TRIBE_PINK, 16, -1, 0, 4, 0, 0, GUARD_NORMAL)
GUARD_BETWEEN_MARKERS(TRIBE_PINK, 15, -1, 0, 4, 0, 0, GUARD_NORMAL)
GUARD_BETWEEN_MARKERS(TRIBE_PINK, 14, -1, 0, 4, 0, 0, GUARD_NORMAL)
GUARD_BETWEEN_MARKERS(TRIBE_PINK, 13, -1, 0, 4, 0, 0, GUARD_NORMAL)
GUARD_BETWEEN_MARKERS(TRIBE_PINK, 12, -1, 0, 0, 4, 0, GUARD_NORMAL)
GUARD_BETWEEN_MARKERS(TRIBE_PINK, 11, -1, 0, 0, 4, 0, GUARD_NORMAL)
PREACH_AT_MARKER(TRIBE_PINK, 11)
PREACH_AT_MARKER(TRIBE_PINK, 12)
PREACH_AT_MARKER(TRIBE_PINK, 13)
PREACH_AT_MARKER(TRIBE_PINK, 14)
PREACH_AT_MARKER(TRIBE_PINK, 17)
PREACH_AT_MARKER(TRIBE_PINK, 18)
PREACH_AT_MARKER(TRIBE_PINK, 19)
PREACH_AT_MARKER(TRIBE_PINK, 20)

function OnTurn()
  if (_gsi.Counts.GameTurn > 1) then
    if (_gsi.Counts.GameTurn > 12*15 and not tip_shown1) then
      tip_shown1 = true
      log_msg(TRIBE_NEUTRAL, "[green] Provided god-like power is not the something You can hold.")
    elseif(_gsi.Counts.GameTurn > 12*20 and not tip_shown2) then
      tip_shown2 = true
      log_msg(TRIBE_NEUTRAL, "[green] Although, You seem destined to be one of us.")
    end
    
    if (EVERY_2POW_TURNS(9)) then
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
      if (not timer_removed) then
        local prisons = 0
        
        ProcessGlobalTypeList(T_BUILDING, function(t)
          if (t.Model == M_BUILDING_PRISON) then
            prisons = prisons+1
          end
          
          return true
        end)
        
        if (prisons == 0 and not penalty) then
          REMOVE_TIMER()
          timer_removed = true
        end
      end
    end
    
    if (HAS_TIMER_REACHED_ZERO() == true and not penalty) then
      REMOVE_TIMER()
      penalty = true
      
      ProcessGlobalTypeList(T_PERSON, function(t)
        if (t.Owner == TRIBE_BLUE or t.Owner == TRIBE_RED) then
          damage_person(t, TRIBE_CYAN, 65535, 1)
        end
        return true
      end)
      ProcessGlobalTypeList(T_BUILDING, function(t)
        if (t.Owner == TRIBE_BLUE or t.Owner == TRIBE_RED) then
          createThing(T_EFFECT,M_EFFECT_FIRESTORM,TRIBE_HOSTBOT,t.Pos.D3,false,false)
        end
        
        if (t.Model == M_BUILDING_PRISON) then
          createThing(T_EFFECT,M_EFFECT_LIGHTNING_BOLT,TRIBE_HOSTBOT,t.Pos.D3,false,false)
        end
        return true
      end)
    end
  end
end