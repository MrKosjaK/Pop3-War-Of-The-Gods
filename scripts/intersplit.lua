import(Module_Players)
import(Module_Defines)
import(Module_PopScript)
import(Module_Game)
import(Module_Objects)
import(Module_Globals)
import(Module_Map)

include("UtilPThings.lua")
include("UtilRefs.lua")

local STurn = GetTurn()

wilds = {}
spell_delay = {0,0}
index = 1
availableNums = {5,6}
numthings = 16
pinkTowers = 0
blackTowers = 0
tickPinkAttack = GetTurn() + (1558 +(G_RANDOM(924)))
botSpells = {M_SPELL_CONVERT_WILD,
                    M_SPELL_BLAST,
                    M_SPELL_LAND_BRIDGE,
                    M_SPELL_LIGHTNING_BOLT,
                    M_SPELL_INSECT_PLAGUE,
                    M_SPELL_INVISIBILITY
}
botBldgs = {M_BUILDING_TEPEE,
                   M_BUILDING_DRUM_TOWER,
                   M_BUILDING_WARRIOR_TRAIN,
                   M_BUILDING_TEMPLE,
                   M_BUILDING_SUPER_TRAIN
}

for i = 2,3 do
  for j = 0,1 do
    set_players_allied(i-2,j)
    set_players_allied(availableNums[i-1], availableNums[j+1])
  end

  for u,v in ipairs(botSpells) do
    PThing.SpellSet(availableNums[i-1], v, TRUE, FALSE)
  end

  for y,v in ipairs(botBldgs) do
    PThing.BldgSet(availableNums[i-1], v, TRUE)
  end

  computer_init_player(_gsi.Players[availableNums[i-1]])

  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_EXPANSION, 12+G_RANDOM(8))
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_HOUSE_PERCENTAGE, 39+G_RANDOM(28))
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_MAX_BUILDINGS_ON_GO, 5+G_RANDOM(5))
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_PREF_WARRIOR_TRAINS, 1)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_PREF_WARRIOR_PEOPLE, 17+G_RANDOM(15))
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_PREF_RELIGIOUS_TRAINS, 1)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_PREF_RELIGIOUS_PEOPLE, 14+G_RANDOM(13))
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_PREF_SUPER_WARRIOR_TRAINS, 1)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_PREF_SUPER_WARRIOR_PEOPLE, 14+G_RANDOM(13))
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_PREF_SPY_TRAINS, 0)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_PREF_SPY_PEOPLE, 0)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_AWAY_BRAVE, 5)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_AWAY_WARRIOR, 80)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_AWAY_RELIGIOUS, 69)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_AWAY_SUPER_WARRIOR, 47)
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
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-1], M_SPELL_INVISIBILITY, 28)

  SET_DEFENCE_RADIUS(availableNums[i-1], 7)
  SET_SPELL_ENTRY(availableNums[i-1], 0, M_SPELL_INSECT_PLAGUE, 25000, 64, 3, 0)
  SET_SPELL_ENTRY(availableNums[i-1], 1, M_SPELL_INSECT_PLAGUE, 25000, 64, 3, 1)
  SET_SPELL_ENTRY(availableNums[i-1], 2, M_SPELL_LIGHTNING_BOLT, 40000, 64, 2, 0)
  SET_SPELL_ENTRY(availableNums[i-1], 3, M_SPELL_LIGHTNING_BOLT, 40000, 64, 2, 1)
end

SHAMAN_DEFEND(TRIBE_PINK, 68, 226, TRUE)
SHAMAN_DEFEND(TRIBE_BLACK, 194, 86, TRUE)
SET_DRUM_TOWER_POS(TRIBE_PINK, 100, 230)
SET_DRUM_TOWER_POS(TRIBE_BLACK, 214, 100)

SET_MARKER_ENTRY(TRIBE_PINK, 0, 11, 12, 0, 0, 2, 0)
SET_MARKER_ENTRY(TRIBE_PINK, 1, 13, 14, 0, 0, 2, 0)
SET_MARKER_ENTRY(TRIBE_PINK, 2, 15, 16, 0, 0, 2, 0)
SET_MARKER_ENTRY(TRIBE_PINK, 3, 17, 18, 0, 2, 0, 2)
SET_MARKER_ENTRY(TRIBE_PINK, 4, 19, 20, 0, 1, 1, 2)
SET_MARKER_ENTRY(TRIBE_PINK, 5, 21, 22, 0, 0, 2, 0)
SET_MARKER_ENTRY(TRIBE_PINK, 6, 23, 24, 0, 0, 2, 0)
SET_MARKER_ENTRY(TRIBE_BLACK, 0, 37, 36, 0, 0, 3, 0)
SET_MARKER_ENTRY(TRIBE_BLACK, 1, 38, 39, 0, 2, 2, 1)
SET_MARKER_ENTRY(TRIBE_BLACK, 2, 40, 41, 0, 2, 0, 2)
SET_MARKER_ENTRY(TRIBE_BLACK, 3, 42, 43, 0, 1, 1, 2)
SET_MARKER_ENTRY(TRIBE_BLACK, 4, 44, 45, 0, 2, 0, 2)

function OnTurn()
  if (every2Pow(12)) then
    if (_gsi.Players[TRIBE_BLACK].Mana > 400000 and GetTurn() > (12*60)*9) then
      if (_gsi.Players[TRIBE_BLACK].NumPeople > 60) then
        ATTACK(TRIBE_BLACK, G_RANDOM(2), 15+G_RANDOM(15), ATTACK_BUILDING, -1, 999, M_SPELL_INVISIBILITY, M_SPELL_INVISIBILITY, M_SPELL_INVISIBILITY, ATTACK_NORMAL, 0, NO_MARKER, NO_MARKER, NO_MARKER)
      end
    end
  end

  if (GetTurn() > tickPinkAttack) then
    tickPinkAttack = GetTurn() + (1558 +(G_RANDOM(924)))
    local attacks = G_RANDOM(2)
    local marker1 = NO_MARKER
    local marker2 = NO_MARKER
    local spell1 = M_SPELL_INVISIBILITY
    local spell2 = M_SPELL_INVISIBILITY

    if (GET_HEIGHT_AT_POS(25) == 0) then
      marker1 = 26
      spell1 = M_SPELL_LAND_BRIDGE
    end

    if (GET_HEIGHT_AT_POS(28) == 0) then
      marker2 = 29
      spell2 = M_SPELL_LAND_BRIDGE
    end

    if (attacks == 0) then
      if (PLAYERS_PEOPLE_OF_TYPE(TRIBE_PINK, M_PERSON_SUPER_WARRIOR) > 3 and _gsi.Players[TRIBE_PINK].NumPeople > 30) then
        WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_RELIGIOUS, 50)
        WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_WARRIOR, 50)
        WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_SUPER_WARRIOR, 50)
        ATTACK(TRIBE_PINK, G_RANDOM(2), 5+G_RANDOM(10), ATTACK_BUILDING, -1, 999, spell1, M_SPELL_LIGHTNING_BOLT, M_SPELL_LIGHTNING_BOLT, ATTACK_NORMAL, 0, 19, marker1, NO_MARKER)
      end
    elseif (attacks == 1) then
      if (PLAYERS_PEOPLE_OF_TYPE(TRIBE_PINK, M_PERSON_RELIGIOUS) > 3) then
        WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_RELIGIOUS, 100)
        WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_WARRIOR, 0)
        WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_SUPER_WARRIOR, 0)
        ATTACK(TRIBE_PINK, G_RANDOM(2), 4+G_RANDOM(9), ATTACK_BUILDING, -1, 999, spell2, M_SPELL_LIGHTNING_BOLT, M_SPELL_LIGHTNING_BOLT, ATTACK_NORMAL, 0, 27, marker2, NO_MARKER)
      end
    end
  end

  if (every2Pow(10)) then
    if (GetTurn() > STurn + (12*60)*4) then
      if (FREE_ENTRIES(TRIBE_PINK) > 4) then
        if (pinkTowers == 0) then
          BUILD_DRUM_TOWER(TRIBE_PINK,144, 204)
          BUILD_DRUM_TOWER(TRIBE_PINK,112, 240)
          BUILD_DRUM_TOWER(TRIBE_PINK,92, 202)
          pinkTowers = 1
        elseif (pinkTowers == 1) then
          BUILD_DRUM_TOWER(TRIBE_PINK,62, 204)
          BUILD_DRUM_TOWER(TRIBE_PINK,64, 220)
          pinkTowers = 2
        elseif (pinkTowers == 2) then
          BUILD_DRUM_TOWER(TRIBE_PINK,56, 236)
          BUILD_DRUM_TOWER(TRIBE_PINK,70, 0)
          pinkTowers = 3
        end
      end
    end

    if (GetTurn() > STurn + (12*60)*5) then
      if (FREE_ENTRIES(TRIBE_BLACK) > 2) then
        if (blackTowers == 0) then
          BUILD_DRUM_TOWER(TRIBE_BLACK,194, 86)
          BUILD_DRUM_TOWER(TRIBE_BLACK,140, 84)
          BUILD_DRUM_TOWER(TRIBE_BLACK,178, 60)
          blackTowers = 1
        elseif (blackTowers == 1) then
          BUILD_DRUM_TOWER(TRIBE_BLACK,200, 68)
          BUILD_DRUM_TOWER(TRIBE_BLACK,246, 72)
          blackTowers = 2
        elseif (blackTowers == 2) then
          BUILD_DRUM_TOWER(TRIBE_BLACK,214, 140)
          BUILD_DRUM_TOWER(TRIBE_BLACK,152, 112)
          blackTowers = 3
        end
      end
    end

    if (GetTurn() > STurn + (12*60)*7) then
      if (PLAYERS_PEOPLE_OF_TYPE(TRIBE_BLACK, M_PERSON_SUPER_WARRIOR) > 10) then
        if (G_RANDOM(2) == 1) then
          for i=0,2 do
            local offset = 46 + G_RANDOM(17)
            GUARD_BETWEEN_MARKERS(TRIBE_BLACK, offset, offset+1, 0,0,2,0, GUARD_NORMAL)
          end
        else
          if (PLAYERS_PEOPLE_OF_TYPE(TRIBE_BLACK, M_PERSON_BRAVE) > 30) then
            TRAIN_PEOPLE_NOW(TRIBE_BLACK,3, M_PERSON_SUPER_WARRIOR)
          end
        end
      end
    end
  end

  if (every2Pow(9)) then
    if (PLAYERS_PEOPLE_OF_TYPE(TRIBE_PINK, M_PERSON_WARRIOR) > 3 and
        PLAYERS_PEOPLE_OF_TYPE(TRIBE_PINK, M_PERSON_RELIGIOUS) > 3 and
        PLAYERS_PEOPLE_OF_TYPE(TRIBE_PINK, M_PERSON_SUPER_WARRIOR) > 3) then
          MARKER_ENTRIES(TRIBE_PINK, 0, 1, 2, 3)
          MARKER_ENTRIES(TRIBE_PINK, 4, 5, 6, NO_MARKER)
    end

    if (PLAYERS_PEOPLE_OF_TYPE(TRIBE_BLACK, M_PERSON_WARRIOR) > 3 and
        PLAYERS_PEOPLE_OF_TYPE(TRIBE_BLACK, M_PERSON_RELIGIOUS) > 3 and
        PLAYERS_PEOPLE_OF_TYPE(TRIBE_BLACK, M_PERSON_SUPER_WARRIOR) > 3) then
          MARKER_ENTRIES(TRIBE_BLACK, 0, 1, 2, 3)
          MARKER_ENTRIES(TRIBE_BLACK, 4, NO_MARKER, NO_MARKER, NO_MARKER)
    end

    ProcessGlobalTypeList(T_BUILDING, function(t)
      if (t.Model < 4 and t.Owner > 1) then
        if (t.u.Bldg.SproggingCount < 2000) then
          t.u.Bldg.SproggingCount = t.u.Bldg.SproggingCount + 850
        end
      end

      if (t.Model < 3 and t.Owner > 1) then
        if (t.u.Bldg.UpgradeCount < 500) then
          t.u.Bldg.UpgradeCount = t.u.Bldg.UpgradeCount + 150
        end
      end

      return true
    end)
  end

  if (every2Pow(3)) then
    if (_gsi.Players[TRIBE_PINK].NumPeople +
        _gsi.Players[TRIBE_BLACK].NumPeople < 120 and
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
        local idx = G_RANDOM(tablelength(availableNums))+1
        local s = getShaman(availableNums[idx])
        if (s ~= nil) then
          if(get_world_dist_xyz(t.Pos.D3, s.Pos.D3) < (8192 + s.Pos.D3.Ypos*3) and spell_delay[idx] == 0) then
            createThing(T_SPELL, M_SPELL_CONVERT_WILD, s.Owner, t.Pos.D3, false, false)
            spell_delay[idx] = 88
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
