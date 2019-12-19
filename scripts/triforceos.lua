import(Module_Players)
import(Module_Defines)
import(Module_PopScript)
import(Module_Game)
import(Module_Objects)
import(Module_Map)
import(Module_Helpers)

include("UtilPThings.lua")
include("UtilRefs.lua")

wilds = {}
spell_delay = 0
attack_idx = 0
attack_idx_lite = 0
playernum = {0,1,3}
ai_pns = {3,5}
index = 1
shaman_patrol = FALSE
numthings = 16
mark_towers_planned = FALSE
botSpells = {M_SPELL_CONVERT_WILD,
                    M_SPELL_BLAST,
                    M_SPELL_LAND_BRIDGE,
                    M_SPELL_INSECT_PLAGUE,
                    M_SPELL_LIGHTNING_BOLT
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
    PThing.SpellSet(TRIBE_PINK, v, TRUE, FALSE)
  end

  for y,v in ipairs(botBldgs) do
    PThing.BldgSet(TRIBE_PINK, v, TRUE)
  end

  computer_init_player(_gsi.Players[TRIBE_PINK])

  WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_EXPANSION, 12+G_RANDOM(8))
  WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_HOUSE_PERCENTAGE, 22+G_RANDOM(37))
  WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_MAX_BUILDINGS_ON_GO, 5+G_RANDOM(5))
  WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_PREF_WARRIOR_TRAINS, 1)
  WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_PREF_WARRIOR_PEOPLE, 17+G_RANDOM(21))
  WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_PREF_RELIGIOUS_TRAINS, 1)
  WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_PREF_RELIGIOUS_PEOPLE, 14+G_RANDOM(14))
  WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_PREF_SUPER_WARRIOR_TRAINS, 0)
  WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_PREF_SUPER_WARRIOR_PEOPLE, 0)
  WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_PREF_SPY_TRAINS, 0)
  WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_PREF_SPY_PEOPLE, 0)
  WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_BRAVE, 5)
  WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_WARRIOR, 80)
  WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_RELIGIOUS, 80)
  WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_SUPER_WARRIOR, 0)
  WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_SPY, 0)
  WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_MEDICINE_MAN, 100)
  WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_USE_PREACHER_FOR_DEFENCE, 1)
  WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_DEFENSE_RAD_INCR, 4)
  WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_MAX_DEFENSIVE_ACTIONS, 3)
  WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_ATTACK_PERCENTAGE, 125)
  WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_MAX_ATTACKS, 7)
  WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_RETREAT_VALUE, 25)
  WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_BASE_UNDER_ATTACK_RETREAT, 0)
  WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_RANDOM_BUILD_SIDE, 1)
  WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_GROUP_OPTION, 0)
  WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_PEOPLE_PER_BOAT, 7)
  WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_PEOPLE_PER_BALLOON, 5)
  WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_ENEMY_SPY_MAX_STAND, 255)
  WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_SPY_CHECK_FREQUENCY, 128)
  WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_SPY_DISCOVER_CHANCE, 10)
  WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_MAX_TRAIN_AT_ONCE, 3)
  WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_SHAMEN_BLAST, 8)

  STATE_SET(TRIBE_PINK, TRUE, CP_AT_TYPE_FETCH_WOOD)
  STATE_SET(TRIBE_PINK, TRUE, CP_AT_TYPE_CONSTRUCT_BUILDING)
  STATE_SET(TRIBE_PINK, TRUE, CP_AT_TYPE_BUILD_OUTER_DEFENCES)
  STATE_SET(TRIBE_PINK, TRUE, CP_AT_TYPE_DEFEND)
  STATE_SET(TRIBE_PINK, TRUE, CP_AT_TYPE_DEFEND_BASE)
  STATE_SET(TRIBE_PINK, TRUE, CP_AT_TYPE_PREACH)
  STATE_SET(TRIBE_PINK, TRUE, CP_AT_TYPE_BRING_NEW_PEOPLE_BACK)
  STATE_SET(TRIBE_PINK, TRUE, CP_AT_TYPE_SUPER_DEFEND)
  STATE_SET(TRIBE_PINK, TRUE, CP_AT_TYPE_TRAIN_PEOPLE)
  STATE_SET(TRIBE_PINK, TRUE, CP_AT_TYPE_AUTO_ATTACK)
  STATE_SET(TRIBE_PINK, TRUE, CP_AT_TYPE_HOUSE_A_PERSON)
  STATE_SET(TRIBE_PINK, TRUE, CP_AT_TYPE_POPULATE_DRUM_TOWER)
  STATE_SET(TRIBE_PINK, TRUE, CP_AT_TYPE_FETCH_LOST_PEOPLE)
  STATE_SET(TRIBE_PINK, TRUE, CP_AT_TYPE_MED_MAN_GET_WILD_PEEPS)

  SET_BUCKET_USAGE(TRIBE_PINK, TRUE)
  SET_BUCKET_COUNT_FOR_SPELL(TRIBE_PINK, M_SPELL_BLAST, 8)
  SET_BUCKET_COUNT_FOR_SPELL(TRIBE_PINK, M_SPELL_CONVERT_WILD, 8)
  SET_BUCKET_COUNT_FOR_SPELL(TRIBE_PINK, M_SPELL_INSECT_PLAGUE, 16)
  SET_BUCKET_COUNT_FOR_SPELL(TRIBE_PINK, M_SPELL_LAND_BRIDGE, 32)
  SET_BUCKET_COUNT_FOR_SPELL(TRIBE_PINK, M_SPELL_LIGHTNING_BOLT, 40)

  SET_DEFENCE_RADIUS(TRIBE_PINK, 7)
end

SET_SPELL_ENTRY(TRIBE_PINK, 0, M_SPELL_INSECT_PLAGUE, 25000, 64, 3, 0)
SET_SPELL_ENTRY(TRIBE_PINK, 1, M_SPELL_INSECT_PLAGUE, 25000, 64, 3, 1)
SET_SPELL_ENTRY(TRIBE_PINK, 2, M_SPELL_LIGHTNING_BOLT, 30000, 64, 2, 0)
SET_SPELL_ENTRY(TRIBE_PINK, 3, M_SPELL_LIGHTNING_BOLT, 30000, 64, 2, 1)
SHAMAN_DEFEND(TRIBE_PINK, 206, 76, TRUE)
SET_DRUM_TOWER_POS(TRIBE_PINK, 210, 60)

SET_MARKER_ENTRY(TRIBE_PINK, 0, 7, 8, 0, 2, 0, 2)
SET_MARKER_ENTRY(TRIBE_PINK, 1, 9, 10, 0, 2, 0, 3)
SET_MARKER_ENTRY(TRIBE_PINK, 2, 14, 15, 0, 3, 0, 2)

function OnTurn()
  if (every2Pow(11)) then
    local who_i_attack = playernum[G_RANDOM(tablelength(playernum))+1]
    local tries = 8

    while tries > 0 do
      tries = tries-1
      if (_gsi.Players[who_i_attack].NumPeople == 0) then
        who_i_attack = playernum[G_RANDOM(tablelength(playernum))+1]
      else
        break
      end
    end

    attack_idx = G_RANDOM(4)
    if (attack_idx == 0) then
      WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_BRAVE, 5)
      WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_RELIGIOUS, 50)
      WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_MEDICINE_MAN, 0)
      WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_WARRIOR, 50)
      if (who_i_attack ~= 3) then
        if (_gsi.Players[TRIBE_PINK].NumPeople > 30) then
          ATTACK(TRIBE_PINK, who_i_attack, 6+G_RANDOM(4), ATTACK_BUILDING, -1, 100+G_RANDOM(300), M_SPELL_NONE, M_SPELL_NONE, M_SPELL_NONE, ATTACK_NORMAL, 0, 16, NO_MARKER, NO_MARKER)
        end
      else
        if (_gsi.Players[TRIBE_PINK].NumPeople > 30 and GET_HEIGHT_AT_POS(2) < 512) then
          ATTACK(TRIBE_PINK, who_i_attack, 6+G_RANDOM(4), ATTACK_BUILDING, -1, 100+G_RANDOM(300), M_SPELL_NONE, M_SPELL_NONE, M_SPELL_NONE, ATTACK_NORMAL, 0, 10, NO_MARKER, NO_MARKER)
        end
      end
    elseif (attack_idx == 1) then
      WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_BRAVE, 5)
      WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_RELIGIOUS, 50)
      WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_MEDICINE_MAN, 100)
      WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_WARRIOR, 50)
      if (who_i_attack ~= 3) then
        if (_gsi.Players[TRIBE_PINK].NumPeople > 30) then
          ATTACK(TRIBE_PINK, who_i_attack, 5+G_RANDOM(7), ATTACK_BUILDING, -1, 100+G_RANDOM(300), M_SPELL_INSECT_PLAGUE, M_SPELL_INSECT_PLAGUE, M_SPELL_LIGHTNING_BOLT, ATTACK_NORMAL, 0, 16, NO_MARKER, NO_MARKER)
        end
      else
        if (_gsi.Players[TRIBE_PINK].NumPeople > 20 and GET_HEIGHT_AT_POS(2) < 512) then
          ATTACK(TRIBE_PINK, who_i_attack, 5+G_RANDOM(7), ATTACK_BUILDING, -1, 100+G_RANDOM(300), M_SPELL_INSECT_PLAGUE, M_SPELL_INSECT_PLAGUE, M_SPELL_LIGHTNING_BOLT, ATTACK_NORMAL, 0, 10, NO_MARKER, NO_MARKER)
        end
      end
    elseif (attack_idx == 2) then
      WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_BRAVE, 5)
      WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_RELIGIOUS, 50)
      WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_MEDICINE_MAN, 100)
      WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_WARRIOR, 50)
      if (who_i_attack ~= 3) then
        if (_gsi.Players[TRIBE_PINK].NumPeople > 45) then
          ATTACK(TRIBE_PINK, who_i_attack, 11+G_RANDOM(11), ATTACK_BUILDING, -1, 100+G_RANDOM(300), M_SPELL_INSECT_PLAGUE, M_SPELL_INSECT_PLAGUE, M_SPELL_LIGHTNING_BOLT, ATTACK_NORMAL, 0, 16, NO_MARKER, NO_MARKER)
        end
      else
        if (_gsi.Players[TRIBE_PINK].NumPeople > 45 and GET_HEIGHT_AT_POS(2) < 512) then
          ATTACK(TRIBE_PINK, who_i_attack, 11+G_RANDOM(11), ATTACK_BUILDING, -1, 100+G_RANDOM(300), M_SPELL_INSECT_PLAGUE, M_SPELL_INSECT_PLAGUE, M_SPELL_LIGHTNING_BOLT, ATTACK_NORMAL, 0, 10, NO_MARKER, NO_MARKER)
        end
      end
    elseif (attack_idx == 3) then
      WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_BRAVE, 5)
      WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_RELIGIOUS, 50)
      WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_MEDICINE_MAN, 0)
      WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_WARRIOR, 50)
      if (who_i_attack ~= 3) then
        if (_gsi.Players[TRIBE_PINK].NumPeople > 40) then
          ATTACK(TRIBE_PINK, who_i_attack, 6+G_RANDOM(9), ATTACK_BUILDING, -1, 100+G_RANDOM(300), M_SPELL_NONE, M_SPELL_NONE, M_SPELL_NONE, ATTACK_NORMAL, 0, 16, NO_MARKER, NO_MARKER)
        end
      else
        if (_gsi.Players[TRIBE_PINK].NumPeople > 40 and GET_HEIGHT_AT_POS(2) < 512) then
          ATTACK(TRIBE_PINK, who_i_attack, 6+G_RANDOM(9), ATTACK_BUILDING, -1, 100+G_RANDOM(300), M_SPELL_NONE, M_SPELL_NONE, M_SPELL_NONE, ATTACK_NORMAL, 0, 10, NO_MARKER, NO_MARKER)
        end
      end
    end
  end

  if (every2Pow(10)) then
    if (G_RANDOM(2) == 1) then
      shaman_patrol = TRUE
    else
      shaman_patrol = FALSE
    end
  end

  if (every2Pow(9)) then
    if (PLAYERS_PEOPLE_OF_TYPE(TRIBE_PINK, M_PERSON_WARRIOR) > 4 and PLAYERS_PEOPLE_OF_TYPE(TRIBE_PINK, M_PERSON_RELIGIOUS) > 3) then
      MARKER_ENTRIES(TRIBE_PINK, 0, 1, NO_MARKER, NO_MARKER)
      if (GET_HEAD_TRIGGER_COUNT(232, 78) > 0) then
        MARKER_ENTRIES(TRIBE_PINK, 2, NO_MARKER, NO_MARKER, NO_MARKER)
      end
    end

    local who_i_attack = playernum[G_RANDOM(tablelength(playernum))+1]
    local tries = 8

    while tries > 0 do
      tries = tries-1
      if (_gsi.Players[who_i_attack].NumPeople == 0) then
        who_i_attack = playernum[G_RANDOM(tablelength(playernum))+1]
      else
        break
      end
    end

    attack_idx_lite = G_RANDOM(3)
    if (attack_idx_lite == 0) then
      if (PLAYERS_PEOPLE_OF_TYPE(TRIBE_PINK, M_PERSON_WARRIOR) > 4 and _gsi.Players[TRIBE_PINK].NumPeople > 55) then
        WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_BRAVE, 0)
        WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_RELIGIOUS, 0)
        WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_MEDICINE_MAN, 0)
        WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_WARRIOR, 100)
        if (who_i_attack == 3) then
          if (GET_HEIGHT_AT_POS(2) < 512) then
            ATTACK(TRIBE_PINK, who_i_attack, 2+G_RANDOM(4), ATTACK_BUILDING, -1, 200+G_RANDOM(300), M_SPELL_NONE, M_SPELL_NONE, M_SPELL_NONE, ATTACK_NORMAL, 0, 10, NO_MARKER, NO_MARKER)
          end
        else
          ATTACK(TRIBE_PINK, who_i_attack, 2+G_RANDOM(4), ATTACK_BUILDING, -1, 200+G_RANDOM(300), M_SPELL_NONE, M_SPELL_NONE, M_SPELL_NONE, ATTACK_NORMAL, 0, 16, NO_MARKER, NO_MARKER)
        end
      end
    elseif (attack_idx_lite == 1) then
      if (PLAYERS_PEOPLE_OF_TYPE(TRIBE_PINK, M_PERSON_WARRIOR) > 4 and _gsi.Players[TRIBE_PINK].NumPeople > 55) then
        WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_BRAVE, 0)
        WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_RELIGIOUS, 100)
        WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_MEDICINE_MAN, 0)
        WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_WARRIOR, 0)
        if (who_i_attack == 3) then
          if (GET_HEIGHT_AT_POS(2) < 512) then
            ATTACK(TRIBE_PINK, who_i_attack, 2+G_RANDOM(4), ATTACK_BUILDING, -1, 200+G_RANDOM(300), M_SPELL_NONE, M_SPELL_NONE, M_SPELL_NONE, ATTACK_NORMAL, 0, 10, NO_MARKER, NO_MARKER)
          end
        else
          ATTACK(TRIBE_PINK, who_i_attack, 2+G_RANDOM(4), ATTACK_BUILDING, -1, 200+G_RANDOM(300), M_SPELL_NONE, M_SPELL_NONE, M_SPELL_NONE, ATTACK_NORMAL, 0, 16, NO_MARKER, NO_MARKER)
        end
      end
    elseif (attack_idx_lite == 2) then
      if (PLAYERS_PEOPLE_OF_TYPE(TRIBE_PINK, M_PERSON_BRAVE) > 40) then
        TRAIN_PEOPLE_NOW(TRIBE_PINK, 1, M_PERSON_WARRIOR)
        TRAIN_PEOPLE_NOW(TRIBE_PINK, 1, M_PERSON_RELIGIOUS)
      end
    end
  end

  if (every2Pow(7)) then
    ProcessGlobalTypeList(T_BUILDING, function(t)
      if (t.Model < 4 and t.Owner > 1) then
        if (t.u.Bldg.SproggingCount < 2000) then
          t.u.Bldg.SproggingCount = t.u.Bldg.SproggingCount + 750
        end
      end

      return true
    end)

    if (shaman_patrol == TRUE and IS_SHAMAN_AVAILABLE_FOR_ATTACK(TRIBE_PINK) == 1) then
      SHAMAN_DEFEND(TRIBE_PINK, 206, 76, FALSE)
      if (G_RANDOM(2) == 1) then
        SHAMAN_DEFEND(TRIBE_PINK, 188, 84, TRUE)
      else
        SHAMAN_DEFEND(TRIBE_PINK, 196, 100, TRUE)
      end
    else
      SHAMAN_DEFEND(TRIBE_PINK, 206, 76, TRUE)
    end
  end

  if (every2Pow(6)) then
    local shaman = getShaman(TRIBE_PINK)
    if (shaman ~= nil) then
      ProcessGlobalTypeList(T_PERSON, function(t)
        if (t.Owner < 4) then
          if (get_world_dist_xyz(shaman.Pos.D3, t.Pos.D3) < 3092 + shaman.Pos.D3.Ypos*3 and t.Model > 1 and t.Model < 7) then
            if (spell_delay == 0 and is_thing_on_ground(shaman) == 1) then
              createThing(T_SPELL, M_SPELL_BLAST, shaman.Owner, t.Pos.D3, false, false)
              spell_delay = 14
              return false
            end
          elseif (get_world_dist_xyz(shaman.Pos.D3, t.Pos.D3) < 6000 + shaman.Pos.D3.Ypos*3 and t.Model == M_PERSON_MEDICINE_MAN) then
            if (spell_delay == 0 and is_thing_on_ground(shaman) == 1) then
              createThing(T_SPELL, M_SPELL_LIGHTNING_BOLT, shaman.Owner, t.Pos.D3, false, false)
              spell_delay = 14
              return false
            end
          end
        end

        return true
      end)
    end
  end

  if (every2Pow(3)) then
    if (_gsi.Players[TRIBE_PINK].NumPeople < 70 and
        GetTurn() < (12*60)*2 and
        GetTurn() > (12*10)) then
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
        local idx = ai_pns[G_RANDOM(tablelength(ai_pns))+1]
        local s = getShaman(idx)
        if (s ~= nil) then
          if(get_world_dist_xyz(t.Pos.D3, s.Pos.D3) < (8192 + s.Pos.D3.Ypos*3) and spell_delay == 0) then
            createThing(T_SPELL, M_SPELL_CONVERT_WILD, s.Owner, t.Pos.D3, false, false)
            spell_delay = 88
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
