import(Module_Players)
import(Module_Defines)
import(Module_PopScript)
import(Module_Game)
import(Module_Objects)
import(Module_Globals)
import(Module_Map)

include("UtilPThings.lua")

wilds = {}
spell_delay = {0,0,0}
index = 1
availableNums = {4,7,2}
cyanEnemies = {0,1,7}
orangeEnemies = {2,4,0,1}
numthings = 16
tickCyanAttack = _gsi.Counts.GameTurn + (1558 +(G_RANDOM(924)))
tickCyanLiteAttack = _gsi.Counts.GameTurn + (830 + (G_RANDOM(412)))
tickCyanCheckStone = _gsi.Counts.GameTurn + (240 + (G_RANDOM(120)))
tickOrangeAttack = _gsi.Counts.GameTurn + (1558 +(G_RANDOM(924)))
tickOrangeLiteAttack = _gsi.Counts.GameTurn + (830 + (G_RANDOM(412)))
tickOrangeCheckStone = _gsi.Counts.GameTurn + (240 + (G_RANDOM(120)))
CyanTowers = 0
OrangeTowers = 0
botSpells = {M_SPELL_CONVERT_WILD,
                    M_SPELL_BLAST,
                    M_SPELL_LAND_BRIDGE,
                    M_SPELL_LIGHTNING_BOLT,
                    M_SPELL_INSECT_PLAGUE,
                    M_SPELL_SWAMP
}
botBldgs = {M_BUILDING_TEPEE,
                   M_BUILDING_DRUM_TOWER,
                   M_BUILDING_WARRIOR_TRAIN,
                   M_BUILDING_TEMPLE
}

set_players_allied(1,0)
set_players_allied(0,1)

for i = 2,4 do
  for u,v in ipairs(botSpells) do
    PThing.SpellSet(availableNums[i-1], v, TRUE, FALSE)
  end
  
  for y,v in ipairs(botBldgs) do
    PThing.BldgSet(availableNums[i-1], v, TRUE)
  end
  
  computer_init_player(_gsi.Players[availableNums[i-1]])
  
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_EXPANSION, 12+G_RANDOM(8))
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_HOUSE_PERCENTAGE, 37+G_RANDOM(25))
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_MAX_BUILDINGS_ON_GO, 5+G_RANDOM(5))
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_PREF_WARRIOR_TRAINS, 1)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_PREF_WARRIOR_PEOPLE, 15+G_RANDOM(15))
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_PREF_RELIGIOUS_TRAINS, 1)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_PREF_RELIGIOUS_PEOPLE, 15+G_RANDOM(15))
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_PREF_SUPER_WARRIOR_TRAINS, 0)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_PREF_SUPER_WARRIOR_PEOPLE, 0)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_PREF_SPY_TRAINS, 0)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_PREF_SPY_PEOPLE, 0)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_AWAY_BRAVE, 5)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_AWAY_WARRIOR, 80)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_AWAY_RELIGIOUS, 69)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_AWAY_SUPER_WARRIOR, 0)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_AWAY_SPY, 0)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_AWAY_MEDICINE_MAN, 100)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_USE_PREACHER_FOR_DEFENCE, 1)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_DEFENSE_RAD_INCR, 4)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_MAX_DEFENSIVE_ACTIONS, 3)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_ATTACK_PERCENTAGE, 125)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_MAX_ATTACKS, 7)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_RETREAT_VALUE, 5+G_RANDOM(25))
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_BASE_UNDER_ATTACK_RETREAT, 0)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_RANDOM_BUILD_SIDE, 1)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_GROUP_OPTION, 0)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_PEOPLE_PER_BOAT, 7)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_PEOPLE_PER_BALLOON, 5)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_ENEMY_SPY_MAX_STAND, 255)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_SPY_CHECK_FREQUENCY, 128)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_SPY_DISCOVER_CHANCE, 10)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_MAX_TRAIN_AT_ONCE, 3)
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
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-1], M_SPELL_INSECT_PLAGUE, 16)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-1], M_SPELL_LAND_BRIDGE, 32)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-1], M_SPELL_LIGHTNING_BOLT, 40)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-1], M_SPELL_SWAMP, 100)
  
  SET_DEFENCE_RADIUS(availableNums[i-1], 7)
  SET_SPELL_ENTRY(availableNums[i-1], 0, M_SPELL_INSECT_PLAGUE, 25000, 64, 3, 0)
  SET_SPELL_ENTRY(availableNums[i-1], 1, M_SPELL_INSECT_PLAGUE, 25000, 64, 3, 1)
  SET_SPELL_ENTRY(availableNums[i-1], 2, M_SPELL_LIGHTNING_BOLT, 40000, 64, 2, 0)
  SET_SPELL_ENTRY(availableNums[i-1], 3, M_SPELL_LIGHTNING_BOLT, 40000, 64, 2, 1)
end

SHAMAN_DEFEND(TRIBE_CYAN, 68, 82, TRUE)
SHAMAN_DEFEND(TRIBE_ORANGE, 38, 154, TRUE)
SET_DRUM_TOWER_POS(TRIBE_CYAN, 68, 82)
SET_DRUM_TOWER_POS(TRIBE_ORANGE, 38, 154)

SET_MARKER_ENTRY(TRIBE_CYAN, 0, 11, 12, 0, 2, 0, 2)
SET_MARKER_ENTRY(TRIBE_CYAN, 1, 16, 17, 0, 2, 0, 2)
SET_MARKER_ENTRY(TRIBE_CYAN, 2, 18, 19, 0, 2, 0, 2)
SET_MARKER_ENTRY(TRIBE_CYAN, 3, 22, 23, 0, 2, 0, 2)
SET_MARKER_ENTRY(TRIBE_CYAN, 4, 32, 33, 0, 2, 0, 2)
SET_MARKER_ENTRY(TRIBE_CYAN, 5, 30, 31, 0, 2, 0, 2)
SET_MARKER_ENTRY(TRIBE_ORANGE, 0, 38, 39, 0, 3, 0, 3)
SET_MARKER_ENTRY(TRIBE_ORANGE, 1, 40, 41, 0, 3, 0, 3)
SET_MARKER_ENTRY(TRIBE_ORANGE, 2, 42, 43, 0, 3, 0, 3)
SET_MARKER_ENTRY(TRIBE_ORANGE, 3, 45, 46, 0, 2, 0, 2)

function OnTurn()
  if (_gsi.Counts.GameTurn > tickCyanAttack) then
    tickCyanAttack = _gsi.Counts.GameTurn + (1558 +(G_RANDOM(1024)))
    local who_shall_attack = cyanEnemies[G_RANDOM(3)+1]
    local attacks = G_RANDOM(2)
    local tries = 16
    
    while tries > 0 do
      tries = tries-1
      if (_gsi.Players[who_shall_attack].NumPeople == 0) then
        who_shall_attack = cyanEnemies[G_RANDOM(3)+1]
      else
        break
      end
    end
    
    if (PLAYERS_PEOPLE_OF_TYPE(TRIBE_CYAN, M_PERSON_WARRIOR) > 3 and
        PLAYERS_PEOPLE_OF_TYPE(TRIBE_CYAN, M_PERSON_RELIGIOUS) > 2) then
      if (attacks == 0) then
        local spell2 = M_SPELL_LIGHTNING_BOLT
        
        if (GET_NUM_ONE_OFF_SPELLS(TRIBE_CYAN, M_SPELL_SWAMP) > 0) then
          spell2 = M_SPELL_SWAMP
        end
        
        if (who_shall_attack == TRIBE_ORANGE) then
          local marker = NO_MARKER
          local spell1 = M_SPELL_LIGHTNING_BOLT
          
          if (GET_HEIGHT_AT_POS(24) == 0) then
            marker = 27
            spell1 = M_SPELL_LAND_BRIDGE
          end
          WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_AWAY_MEDICINE_MAN, 100)
          WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_AWAY_WARRIOR, G_RANDOM(100))
          WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_AWAY_RELIGIOUS, G_RANDOM(100))
          ATTACK(TRIBE_CYAN, who_shall_attack, 4+G_RANDOM(18), ATTACK_BUILDING, -1, 999, spell1, spell2, M_SPELL_INSECT_PLAGUE, ATTACK_NORMAL, 0, 26, marker, NO_MARKER)
        else
          WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_AWAY_MEDICINE_MAN, 100)
          WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_AWAY_WARRIOR, G_RANDOM(100))
          WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_AWAY_RELIGIOUS, G_RANDOM(100))
          ATTACK(TRIBE_CYAN, who_shall_attack, 4+G_RANDOM(18), ATTACK_BUILDING, -1, 999, spell2, spell2, M_SPELL_INSECT_PLAGUE, ATTACK_NORMAL, 0, 20+G_RANDOM(2), NO_MARKER, NO_MARKER)
        end
      elseif (attacks == 1) then
        local spell2 = M_SPELL_LIGHTNING_BOLT
          
        if (GET_NUM_ONE_OFF_SPELLS(TRIBE_CYAN, M_SPELL_SWAMP) > 0) then
          spell2 = M_SPELL_SWAMP
        end
        
        if (who_shall_attack == TRIBE_ORANGE) then
          local marker = NO_MARKER
          local spell1 = M_SPELL_LIGHTNING_BOLT
          
          if (GET_HEIGHT_AT_POS(25) == 0) then
            marker = 29
            spell1 = M_SPELL_LAND_BRIDGE
          end
          WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_AWAY_MEDICINE_MAN, 100)
          WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_AWAY_WARRIOR, G_RANDOM(100))
          WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_AWAY_RELIGIOUS, G_RANDOM(100))
          ATTACK(TRIBE_CYAN, who_shall_attack, 5+G_RANDOM(24), ATTACK_BUILDING, -1, 999, spell1, spell2, M_SPELL_INSECT_PLAGUE, ATTACK_NORMAL, 0, 28, marker, NO_MARKER)
        else
          WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_AWAY_MEDICINE_MAN, 100)
          WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_AWAY_WARRIOR, G_RANDOM(100))
          WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_AWAY_RELIGIOUS, G_RANDOM(100))
          ATTACK(TRIBE_CYAN, who_shall_attack, 5+G_RANDOM(24), ATTACK_BUILDING, -1, 999, spell2, spell2, M_SPELL_INSECT_PLAGUE, ATTACK_NORMAL, 0, 20+G_RANDOM(2), NO_MARKER, NO_MARKER)
        end
      end
    end
  elseif (_gsi.Counts.GameTurn > tickOrangeAttack) then
    tickOrangeAttack = _gsi.Counts.GameTurn + (1458 +(G_RANDOM(924)))
    local who_shall_attack = orangeEnemies[G_RANDOM(4)+1]
    local attacks = G_RANDOM(2)
    local tries = 16
    
    while tries > 0 do
      tries = tries-1
      if (_gsi.Players[who_shall_attack].NumPeople == 0) then
        who_shall_attack = orangeEnemies[G_RANDOM(4)+1]
      else
        break
      end
    end
    
    if (PLAYERS_PEOPLE_OF_TYPE(TRIBE_ORANGE, M_PERSON_WARRIOR) > 3 and
        PLAYERS_PEOPLE_OF_TYPE(TRIBE_ORANGE, M_PERSON_RELIGIOUS) > 2) then
      if (attacks == 0) then
        local spell2 = M_SPELL_LIGHTNING_BOLT
        
        if (GET_NUM_ONE_OFF_SPELLS(TRIBE_ORANGE, M_SPELL_FIRESTORM) > 0) then
          spell2 = M_SPELL_FIRESTORM
        end
        
        if (who_shall_attack == TRIBE_YELLOW) then
          local marker = NO_MARKER
          local spell1 = M_SPELL_LIGHTNING_BOLT
          
          if (GET_HEIGHT_AT_POS(2) == 0) then
            marker = 47
            spell1 = M_SPELL_LAND_BRIDGE
          end
          WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_AWAY_MEDICINE_MAN, 100)
          WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_AWAY_WARRIOR, G_RANDOM(100))
          WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_AWAY_RELIGIOUS, G_RANDOM(100))
          ATTACK(TRIBE_ORANGE, who_shall_attack, 5+G_RANDOM(24), ATTACK_BUILDING, -1, 999, spell1, spell2, M_SPELL_INSECT_PLAGUE, ATTACK_NORMAL, 0, 3, marker, NO_MARKER)
        else
          if (GET_HEIGHT_AT_POS(25) > 0) then
            WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_AWAY_MEDICINE_MAN, 100)
            WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_AWAY_WARRIOR, G_RANDOM(100))
            WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_AWAY_RELIGIOUS, G_RANDOM(100))
            ATTACK(TRIBE_ORANGE, who_shall_attack, 5+G_RANDOM(24), ATTACK_BUILDING, -1, 999, spell2, spell2, M_SPELL_INSECT_PLAGUE, ATTACK_NORMAL, 0, 29, 28, NO_MARKER)
          end
        end
      elseif (attacks == 1) then
        local spell2 = M_SPELL_LIGHTNING_BOLT
        
        if (GET_NUM_ONE_OFF_SPELLS(TRIBE_ORANGE, M_SPELL_FIRESTORM) > 0) then
          spell2 = M_SPELL_FIRESTORM
        end
        
        if (who_shall_attack == TRIBE_YELLOW) then
          local marker = NO_MARKER
          local spell1 = M_SPELL_LIGHTNING_BOLT
          
          if (GET_HEIGHT_AT_POS(2) == 0) then
            marker = 47
            spell1 = M_SPELL_LAND_BRIDGE
          end
          WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_AWAY_MEDICINE_MAN, 100)
          WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_AWAY_WARRIOR, G_RANDOM(100))
          WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_AWAY_RELIGIOUS, G_RANDOM(100))
          ATTACK(TRIBE_ORANGE, who_shall_attack, 5+G_RANDOM(24), ATTACK_BUILDING, -1, 999, spell1, spell2, M_SPELL_INSECT_PLAGUE, ATTACK_NORMAL, 0, 3, marker, NO_MARKER)
        else
          if (GET_HEIGHT_AT_POS(24) > 0) then
            WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_AWAY_MEDICINE_MAN, 100)
            WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_AWAY_WARRIOR, G_RANDOM(100))
            WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_AWAY_RELIGIOUS, G_RANDOM(100))
            ATTACK(TRIBE_ORANGE, who_shall_attack, 5+G_RANDOM(24), ATTACK_BUILDING, -1, 999, spell2, spell2, M_SPELL_INSECT_PLAGUE, ATTACK_NORMAL, 0, 27, 26, NO_MARKER)
          end
        end
      end
    end
  end
  
  if (_gsi.Counts.GameTurn > tickCyanLiteAttack) then
    tickCyanLiteAttack = _gsi.Counts.GameTurn + (830 + (G_RANDOM(512)))
    local who_shall_attack = cyanEnemies[G_RANDOM(3)+1]
    local tries = 16
    
    while tries > 0 do
      tries = tries-1
      if (_gsi.Players[who_shall_attack].NumPeople == 0) then
        who_shall_attack = cyanEnemies[G_RANDOM(3)+1]
      else
        break
      end
    end
    
    while tries > 0 do
      tries = tries-1
      if (who_shall_attack == TRIBE_ORANGE) then
        if (GET_HEIGHT_AT_POS(24) == 0 and GET_HEIGHT_AT_POS(25) == 0) then
          who_shall_attack = cyanEnemies[G_RANDOM(3)+1]
        else
          break
        end
      else
        break
      end
    end
    
    if (_gsi.Players[TRIBE_CYAN].NumPeople > 60) then
      WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_AWAY_MEDICINE_MAN, 0)
      WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_AWAY_RELIGIOUS, 50)
      WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_AWAY_WARRIOR, 50)
      WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_DONT_GROUP_AT_DT, 1)
      ATTACK(TRIBE_CYAN, who_shall_attack, 2+G_RANDOM(7), ATTACK_BUILDING, -1, 459, M_SPELL_NONE, M_SPELL_NONE, M_SPELL_NONE, ATTACK_NORMAL, 0, NO_MARKER, NO_MARKER, NO_MARKER)
    end
  elseif (_gsi.Counts.GameTurn > tickOrangeLiteAttack) then
    tickOrangeLiteAttack = _gsi.Counts.GameTurn + (730 + (G_RANDOM(412)))
    local who_shall_attack = orangeEnemies[G_RANDOM(4)+1]
    local tries = 16
    
    while tries > 0 do
      tries = tries-1
      if (_gsi.Players[who_shall_attack].NumPeople == 0) then
        who_shall_attack = orangeEnemies[G_RANDOM(4)+1]
      else
        break
      end
    end
    
    while tries > 0 do
      tries = tries-1
      if (who_shall_attack == TRIBE_CYAN) then
        if (GET_HEIGHT_AT_POS(24) == 0 and GET_HEIGHT_AT_POS(25) == 0 or GET_HEIGHT_AT_POS(2) == 0) then
          who_shall_attack = orangeEnemies[G_RANDOM(4)+1]
        else
          break
        end
      else
        break
      end
    end
    
    if (_gsi.Players[TRIBE_ORANGE].NumPeople > 60) then
      WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_AWAY_MEDICINE_MAN, 0)
      WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_AWAY_RELIGIOUS, 50)
      WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_AWAY_WARRIOR, 50)
      WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_DONT_GROUP_AT_DT, 1)
      ATTACK(TRIBE_ORANGE, who_shall_attack, 2+G_RANDOM(7), ATTACK_BUILDING, -1, 459, M_SPELL_NONE, M_SPELL_NONE, M_SPELL_NONE, ATTACK_NORMAL, 0, NO_MARKER, NO_MARKER, NO_MARKER)
    end
  end
  
  if (_gsi.Counts.GameTurn > tickCyanCheckStone) then
    tickCyanCheckStone = _gsi.Counts.GameTurn + (240 + (G_RANDOM(120)))
    local whomst_to_atk = G_RANDOM(2)
    if (IS_SHAMAN_IN_AREA(whomst_to_atk,10,3) > 0 and GET_HEAD_TRIGGER_COUNT(106,110) > 0) then
      if (IS_SHAMAN_AVAILABLE_FOR_ATTACK(TRIBE_CYAN) > 0 and G_RANDOM(3) == 1) then
        WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_AWAY_MEDICINE_MAN, 100)
        WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_DONT_GROUP_AT_DT, 1)
        ATTACK(TRIBE_CYAN, whomst_to_atk, 5, ATTACK_MARKER, 10, 999, M_SPELL_LIGHTNING_BOLT, M_SPELL_LIGHTNING_BOLT, M_SPELL_BLAST, ATTACK_NORMAL, 0, NO_MARKER, NO_MARKER, NO_MARKER)
      end
    else
      if (COUNT_PEOPLE_IN_MARKER(TRIBE_CYAN,whomst_to_atk,15,3) > 0 and GET_HEAD_TRIGGER_COUNT(142,94) > 0) then
        if (PLAYERS_PEOPLE_OF_TYPE(TRIBE_CYAN, M_PERSON_WARRIOR) > 3 and G_RANDOM(3) == 1) then
          WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_AWAY_MEDICINE_MAN, 100)
          WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_AWAY_WARRIOR, 50)
          WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_DONT_GROUP_AT_DT, 1)
          ATTACK(TRIBE_CYAN, whomst_to_atk, 5, ATTACK_MARKER, 15, 999, M_SPELL_INSECT_PLAGUE, M_SPELL_INSECT_PLAGUE, M_SPELL_INSECT_PLAGUE, ATTACK_NORMAL, 0, NO_MARKER, NO_MARKER, NO_MARKER)
        end
      else
        if (_gsi.Players[TRIBE_CYAN].NumPeople > 35 and G_RANDOM(8) == 1) then
          WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_AWAY_BRAVE, 100)
          WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_AWAY_MEDICINE_MAN, 0)
          PRAY_AT_HEAD(TRIBE_CYAN, 4, 14)
          WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_AWAY_BRAVE, 5)
          WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_AWAY_MEDICINE_MAN, 100)
        end
      end
    end
  elseif (_gsi.Counts.GameTurn > tickOrangeCheckStone) then
    tickOrangeCheckStone = _gsi.Counts.GameTurn + (240 + (G_RANDOM(120)))
    if (COUNT_PEOPLE_IN_MARKER(TRIBE_ORANGE,TRIBE_YELLOW,4,3) > 0 and GET_HEAD_TRIGGER_COUNT(94, 164) > 0) then
      if (PLAYERS_PEOPLE_OF_TYPE(TRIBE_ORANGE, M_PERSON_WARRIOR) > 2) then
        WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_AWAY_MEDICINE_MAN, 100)
        WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_AWAY_WARRIOR, 50)
        WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_DONT_GROUP_AT_DT, 1)
        ATTACK(TRIBE_ORANGE, TRIBE_YELLOW, 5, ATTACK_MARKER, 4, 999, M_SPELL_INSECT_PLAGUE, M_SPELL_INSECT_PLAGUE, M_SPELL_INSECT_PLAGUE, ATTACK_NORMAL, 0, NO_MARKER, NO_MARKER, NO_MARKER)
      end
    elseif (G_RANDOM(16) == 1 and _gsi.Counts.GameTurn > (12*60)*8) then
      WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_AWAY_BRAVE, 100)
      WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_AWAY_MEDICINE_MAN, 0)
      PRAY_AT_HEAD(TRIBE_ORANGE, 1, 5)
      WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_AWAY_BRAVE, 5)
      WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_AWAY_MEDICINE_MAN, 100)
    end
  end
  
  if (EVERY_2POW_TURNS(9)) then
    ProcessGlobalTypeList(T_BUILDING, function(t)
      if (t.Model < 4 and t.Owner > 1) then
        if (t.u.Bldg.SproggingCount < 2000) then
          t.u.Bldg.SproggingCount = t.u.Bldg.SproggingCount + 750
        end
      end
      
      return true
    end)
    
    if (PLAYERS_PEOPLE_OF_TYPE(TRIBE_CYAN, M_PERSON_WARRIOR) > 4) then
      if (PLAYERS_PEOPLE_OF_TYPE(TRIBE_CYAN, M_PERSON_RELIGIOUS) > 4) then
        MARKER_ENTRIES(TRIBE_CYAN, 0, 1, 2, 3)
        
        if (GET_HEIGHT_AT_POS(24) ~= 0) then
          MARKER_ENTRIES(TRIBE_CYAN, 4, NO_MARKER, NO_MARKER, NO_MARKER)
        end
        
        if (GET_HEIGHT_AT_POS(25) ~= 0) then
          MARKER_ENTRIES(TRIBE_CYAN, 5, NO_MARKER, NO_MARKER, NO_MARKER)
        end
      end
    end
    
    if (PLAYERS_PEOPLE_OF_TYPE(TRIBE_ORANGE, M_PERSON_WARRIOR) > 4) then
      if (PLAYERS_PEOPLE_OF_TYPE(TRIBE_ORANGE, M_PERSON_RELIGIOUS) > 4) then
        MARKER_ENTRIES(TRIBE_ORANGE, 0, 1, 2, NO_MARKER)
        
        if (GET_HEAD_TRIGGER_COUNT(94, 164) > 0) then
          MARKER_ENTRIES(TRIBE_ORANGE, 3, NO_MARKER, NO_MARKER, NO_MARKER)
        else
          CLEAR_GUARDING_FROM(TRIBE_ORANGE, 3, NO_MARKER, NO_MARKER, NO_MARKER)
        end
      end
    end
    
    if (_gsi.Counts.GameTurn > 3000 and CyanTowers < 3) then
      if (CyanTowers == 0) then 
        if (FREE_ENTRIES(TRIBE_CYAN) > 4) then
          BUILD_DRUM_TOWER(TRIBE_CYAN, 108, 68)
          BUILD_DRUM_TOWER(TRIBE_CYAN, 80, 54)
          CyanTowers = 1
        end
      elseif (CyanTowers == 1) then
        if (FREE_ENTRIES(TRIBE_CYAN) > 2 and GET_HEIGHT_AT_POS(24) ~= 0) then
          BUILD_DRUM_TOWER(TRIBE_CYAN, 32, 108)
          CyanTowers = 2
        end
      elseif (CyanTowers == 2) then
        if (FREE_ENTRIES(TRIBE_CYAN) > 2 and GET_HEIGHT_AT_POS(25) ~= 0) then
          BUILD_DRUM_TOWER(TRIBE_CYAN, 64, 112)
          CyanTowers = 3
        end
      end
    end
    
    if (_gsi.Counts.GameTurn > 3250 and OrangeTowers < 3) then
      if (OrangeTowers == 0 and FREE_ENTRIES(TRIBE_ORANGE) > 2) then
        BUILD_DRUM_TOWER(TRIBE_ORANGE, 44, 122)
        OrangeTowers = 1
      elseif (OrangeTowers == 1 and FREE_ENTRIES(TRIBE_ORANGE) > 2) then
        BUILD_DRUM_TOWER(TRIBE_ORANGE, 254, 150)
        OrangeTowers = 2
      elseif (OrangeTowers == 2 and FREE_ENTRIES(TRIBE_ORANGE) > 2) then
        BUILD_DRUM_TOWER(TRIBE_ORANGE, 50, 182)
        BUILD_DRUM_TOWER(TRIBE_ORANGE, 60, 182)
        OrangeTowers = 3
      end
    end
  end
  
  if (EVERY_2POW_TURNS(3)) then
    if (_gsi.Players[TRIBE_YELLOW].NumPeople +
        _gsi.Players[TRIBE_CYAN].NumPeople +
        _gsi.Players[TRIBE_ORANGE].NumPeople < 140 and
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
        local idx = G_RANDOM(tablelength(availableNums))+1
        local s = getShaman(availableNums[idx])
        if (s ~= nil) then
          if(get_world_dist_xyz(t.Pos.D3, s.Pos.D3) < (8192 + s.Pos.D3.Ypos*3) and spell_delay[idx] == 0) then
            createThing(T_SPELL, M_SPELL_CONVERT_WILD, s.Owner, t.Pos.D3, false, false)
            spell_delay[idx] = 32
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