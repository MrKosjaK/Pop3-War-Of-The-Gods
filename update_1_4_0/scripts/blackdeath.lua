import(Module_Players)
import(Module_Defines)
import(Module_PopScript)
import(Module_Game)
import(Module_Objects)
import(Module_Map)

include("UtilPThings.lua")
include("UtilRefs.lua")

local STurn = GetTurn()

spell_delay = 0
index = 0
tip_shown = false
statue_has_prayed = FALSE
winner = -1
final_blow = FALSE
connected = FALSE
connectionPoints = {MAP_XZ_2_WORLD_XYZ(22, 108),MAP_XZ_2_WORLD_XYZ(32, 152),MAP_XZ_2_WORLD_XYZ(94, 52),MAP_XZ_2_WORLD_XYZ(136, 58)}
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
backdoor_points = {
  MAP_XZ_2_WORLD_XYZ(188, 22),
  MAP_XZ_2_WORLD_XYZ(190, 26),
  MAP_XZ_2_WORLD_XYZ(192, 30),
  MAP_XZ_2_WORLD_XYZ(192, 34),
  MAP_XZ_2_WORLD_XYZ(196, 38),
  MAP_XZ_2_WORLD_XYZ(198, 42),
  MAP_XZ_2_WORLD_XYZ(202, 46),
  MAP_XZ_2_WORLD_XYZ(204, 50),
  MAP_XZ_2_WORLD_XYZ(206, 54),
  MAP_XZ_2_WORLD_XYZ(208, 58),
  MAP_XZ_2_WORLD_XYZ(212, 60),
  MAP_XZ_2_WORLD_XYZ(216, 60),
  MAP_XZ_2_WORLD_XYZ(186, 18),
  MAP_XZ_2_WORLD_XYZ(186, 14),
  MAP_XZ_2_WORLD_XYZ(188, 10),
  MAP_XZ_2_WORLD_XYZ(192, 6),
  MAP_XZ_2_WORLD_XYZ(196, 2),
  MAP_XZ_2_WORLD_XYZ(200, 254),
  MAP_XZ_2_WORLD_XYZ(204, 250),
  MAP_XZ_2_WORLD_XYZ(208, 246),
  MAP_XZ_2_WORLD_XYZ(212, 242),
  MAP_XZ_2_WORLD_XYZ(220, 60),
  MAP_XZ_2_WORLD_XYZ(224, 62)
}

FIX_WILD_IN_AREA(32, 124,12)
FIX_WILD_IN_AREA(114, 50,12)

for i = 2,3 do
  for j = 0,1 do
    set_players_allied(i-2,j)
  end

  for u,v in ipairs(botSpells) do
    PThing.SpellSet(TRIBE_BLACK, v, TRUE, FALSE)
  end

  for y,v in ipairs(botBldgs) do
    PThing.BldgSet(TRIBE_BLACK, v, TRUE)
  end

  computer_init_player(_gsi.Players[TRIBE_BLACK])

  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_EXPANSION, 12+G_RANDOM(8))
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_HOUSE_PERCENTAGE, 42+G_RANDOM(35))
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_MAX_BUILDINGS_ON_GO, 5+G_RANDOM(5))
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_PREF_WARRIOR_TRAINS, 1)
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_PREF_WARRIOR_PEOPLE, 20+G_RANDOM(21))
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_PREF_RELIGIOUS_TRAINS, 1)
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_PREF_RELIGIOUS_PEOPLE, 18+G_RANDOM(14))
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_PREF_SUPER_WARRIOR_TRAINS, 0)
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_PREF_SUPER_WARRIOR_PEOPLE, 0)
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_PREF_SPY_TRAINS, 0)
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_PREF_SPY_PEOPLE, 0)
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_BRAVE, 5)
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_WARRIOR, 80)
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_RELIGIOUS, 80)
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_SUPER_WARRIOR, 0)
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_SPY, 0)
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_MEDICINE_MAN, 100)
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_USE_PREACHER_FOR_DEFENCE, 1)
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_DEFENSE_RAD_INCR, 4)
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_MAX_DEFENSIVE_ACTIONS, 3)
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_ATTACK_PERCENTAGE, 125)
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_MAX_ATTACKS, 7)
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
  SET_BUCKET_COUNT_FOR_SPELL(TRIBE_BLACK, M_SPELL_LIGHTNING_BOLT, 40)

  SET_DEFENCE_RADIUS(TRIBE_BLACK, 7)
end

SET_SPELL_ENTRY(TRIBE_BLACK, 0, M_SPELL_INSECT_PLAGUE, 25000, 64, 3, 0)
SET_SPELL_ENTRY(TRIBE_BLACK, 1, M_SPELL_INSECT_PLAGUE, 25000, 64, 3, 1)
SET_SPELL_ENTRY(TRIBE_BLACK, 2, M_SPELL_LIGHTNING_BOLT, 30000, 64, 2, 0)
SET_SPELL_ENTRY(TRIBE_BLACK, 3, M_SPELL_LIGHTNING_BOLT, 30000, 64, 2, 1)
SHAMAN_DEFEND(TRIBE_BLACK, 22, 56, TRUE)
SET_DRUM_TOWER_POS(TRIBE_BLACK, 22, 56)

SET_MARKER_ENTRY(TRIBE_BLACK, 0, 1, 2, 0, 3, 0, 3)
SET_MARKER_ENTRY(TRIBE_BLACK, 1, 3, 4, 0, 3, 0, 3)
SET_MARKER_ENTRY(TRIBE_BLACK, 2, 5, 6, 0, 3, 0, 3)
SET_MARKER_ENTRY(TRIBE_BLACK, 3, 6, 7, 0, 3, 0, 3)
SET_MARKER_ENTRY(TRIBE_BLACK, 4, 8, 9, 0, 3, 0, 3)
SET_MARKER_ENTRY(TRIBE_BLACK, 5, 10, 11, 0, 3, 0, 2)

SET_TIMER_GOING((12*60)*15, 1)

function OnTurn()
  if (every2Pow(10)) then
    if (statue_has_prayed == TRUE) then
      ProcessGlobalSpecialList(winner, PEOPLELIST, function(t)
        if (t.Model > 1 and t.Model < 8) then
          t.u.Pers.u.Owned.BloodlustCount = 8192
          t.u.Pers.u.Owned.ShieldCount = 8192
          t.Flags3 = t.Flags3 | TF3_BLOODLUST_ACTIVE
          t.Flags3 = t.Flags3 | TF3_SHIELD_ACTIVE
        end

        return true
      end)

      if (final_blow == FALSE and winner == TRIBE_BLACK) then
        WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_BRAVE, 100)
        WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_MEDICINE_MAN, 0)
        WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_WARRIOR, 100)
        WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_RELIGIOUS, 100)
        ATTACK(TRIBE_BLACK, TRIBE_BLUE, 25, ATTACK_BUILDING, -1, 999, M_SPELL_NONE, M_SPELL_NONE, M_SPELL_NONE, ATTACK_NORMAL, 0, NO_MARKER, NO_MARKER, NO_MARKER)
        ATTACK(TRIBE_BLACK, TRIBE_RED, 25, ATTACK_BUILDING, -1, 999, M_SPELL_NONE, M_SPELL_NONE, M_SPELL_NONE, ATTACK_NORMAL, 0, NO_MARKER, NO_MARKER, NO_MARKER)
        final_blow = TRUE
      end
    end
  end

  if (every2Pow(9)) then
    local shaman = getShaman(TRIBE_BLACK)
    if (shaman ~= nil) then
      ProcessGlobalTypeList(T_PERSON, function(t)
        if (t.Owner < 2) then
          if (get_world_dist_xyz(shaman.Pos.D3, t.Pos.D3) < 3092 + shaman.Pos.D3.Ypos*3 and t.Model > 1 and t.Model < 7) then
            if (spell_delay == 0 and is_thing_on_ground(shaman) == 1) then
              createThing(T_SPELL, M_SPELL_BLAST, shaman.Owner, t.Pos.D3, false, false)
              return false
            end
          else
            if (get_world_dist_xyz(shaman.Pos.D3, t.Pos.D3) < 6000 + shaman.Pos.D3.Ypos*3 and t.Model == M_PERSON_MEDICINE_MAN) then
              if (spell_delay == 0 and is_thing_on_ground(shaman) == 1) then
                createThing(T_SPELL, M_SPELL_LIGHTNING_BOLT, shaman.Owner, t.Pos.D3, false, false)
                return false
              end
            end
          end
        end

        return true
      end)
    end
  end

  if (every2Pow(8)) then
    if (GET_HEAD_TRIGGER_COUNT(238,12) > 0) then
      ProcessGlobalTypeList(T_BUILDING, function(t)
        if (t.Model < 4 and t.Owner > 1) then
          if (t.u.Bldg.SproggingCount < 2000) then
            t.u.Bldg.SproggingCount = t.u.Bldg.SproggingCount + 750
          end
        end

        return true
      end)
    end

    if (statue_has_prayed == TRUE and winner == TRIBE_BLACK) then
      WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_BRAVE, 0)
      WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_MEDICINE_MAN, 0)
      WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_WARRIOR, 50)
      WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_RELIGIOUS, 50)
      WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_DONT_GROUP_AT_DT, 1)
      ATTACK(TRIBE_BLACK, G_RANDOM(2), 5, ATTACK_BUILDING, -1, 999, M_SPELL_NONE, M_SPELL_NONE, M_SPELL_NONE, ATTACK_NORMAL, 0, NO_MARKER, NO_MARKER, NO_MARKER)
    end

    MARKER_ENTRIES(TRIBE_BLACK, 0, 1, 2, 3)
    MARKER_ENTRIES(TRIBE_BLACK, 4, 5, NO_MARKER, NO_MARKER)
  end

  if (every2Pow(5)) then
    for k,v in ipairs(backdoor_points) do
      if (point_altitude(v.Xpos,v.Zpos) ~= 0) then
        for i=0,3 do
          createThing(T_EFFECT,M_EFFECT_DIP,TRIBE_HOSTBOT,v,false,false)
        end
      end
    end
  end

  if (every2Pow(7)) then
    if (HAS_TIMER_REACHED_ZERO()) then
      if (connected == FALSE) then
        for i,v in ipairs(connectionPoints) do
          createThing(T_EFFECT, M_EFFECT_RISE, TRIBE_HOSTBOT, v, false, false)
        end
        connected = TRUE
      end

      if (IS_SHAMAN_AVAILABLE_FOR_ATTACK(TRIBE_BLACK) == 1 and GET_HEAD_TRIGGER_COUNT(238,12) > 0) then
        WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_BRAVE, 0)
        WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_MEDICINE_MAN, 100)
        WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_WARRIOR, 0)
        WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_RELIGIOUS, 0)
        PRAY_AT_HEAD(TRIBE_BLACK, 1, 12)
      end
    end
  end

  if (every2Pow(4)) then
    if (statue_has_prayed == FALSE and GET_HEAD_TRIGGER_COUNT(238,12) == 0) then
      ProcessGlobalTypeList(T_PERSON, function(t)
        if (t.Model == M_PERSON_ANGEL and t.Owner == TRIBE_BLACK) then
          statue_has_prayed = TRUE
          winner = t.Owner
          return false
        elseif (t.Model == M_PERSON_ANGEL and t.Owner < 2) then
          statue_has_prayed = TRUE
          winner = t.Owner
          return false
        end

        return true
      end)

      REMOVE_TIMER()
    end
  end

  if (every2Pow(2)) then
    if (GetTurn() > STurn + (12*15) and not tip_shown) then
      tip_shown = true
      log_msg(TRIBE_NEUTRAL,"INFO: Invoking the ancient flying creature will fill Your blood with determination... or fill Your heart with fear.")
    end
  end
end

function OnCreateThing(t)
  if (statue_has_prayed == TRUE and winner ~= -1) then
    if (t.Type == T_PERSON and t.Model > 1 and t.Model < 8 and t.Owner == winner) then
      t.u.Pers.u.Owned.BloodlustCount = 8192
      t.u.Pers.u.Owned.ShieldCount = 8192
      t.Flags3 = t.Flags3 | TF3_BLOODLUST_ACTIVE
      t.Flags3 = t.Flags3 | TF3_SHIELD_ACTIVE
    end
  end
end
