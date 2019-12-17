import(Module_Defines)
import(Module_PopScript)
import(Module_Game)
import(Module_Objects)
import(Module_Map)
import(Module_MapWho)
import(Module_Math)

include("UtilPThings.lua")
include("UtilRefs.lua")

_c.MaxManaValue = 2500000
_c.ShamenDeadManaPer256Gained = 16

wilds = {}
spell_delay = {0,0,0,0,0,0}
index = 1
availableNums = {4,5,6,7,2,3}
cyanEnemies = {0,1,2,3,5,6,7}
blackEnemies = {0,1,2,3,4,5,7}
pink_expand = 0
numthings = 16
tick_c_attack = GetTurn() + (1840 + G_RANDOM(512))
tick_c_boat = GetTurn() + (840 + G_RANDOM(320))
tick_p_expand = GetTurn() + (480 + G_RANDOM(800))
tick_p_attack = GetTurn() + (1540 + G_RANDOM(512))
tick_b_boat = GetTurn() + (1000 + G_RANDOM(380))
tick_b_attack = GetTurn() + (1794 + G_RANDOM(512))
tick_o_attack = GetTurn() + (1840 + G_RANDOM(512))
tick_o_boat = GetTurn() + (500 + G_RANDOM(1000))
cyanTowers = {MAP_XZ_2_WORLD_XYZ(220, 78),
              MAP_XZ_2_WORLD_XYZ(192, 122),
              MAP_XZ_2_WORLD_XYZ(122, 60),
              MAP_XZ_2_WORLD_XYZ(124, 72)
}
blackTowers = {MAP_XZ_2_WORLD_XYZ(86, 190),
               MAP_XZ_2_WORLD_XYZ(76, 178),
               MAP_XZ_2_WORLD_XYZ(70, 160),
               MAP_XZ_2_WORLD_XYZ(62, 148),
               MAP_XZ_2_WORLD_XYZ(54, 140),
               MAP_XZ_2_WORLD_XYZ(60, 86),
               MAP_XZ_2_WORLD_XYZ(46, 86),
               MAP_XZ_2_WORLD_XYZ(2, 100),
               MAP_XZ_2_WORLD_XYZ(14, 96),
               MAP_XZ_2_WORLD_XYZ(26, 96),
               MAP_XZ_2_WORLD_XYZ(34, 112),
               MAP_XZ_2_WORLD_XYZ(44, 120),
               MAP_XZ_2_WORLD_XYZ(74, 136),
               MAP_XZ_2_WORLD_XYZ(96, 118),
               MAP_XZ_2_WORLD_XYZ(88, 96),
               MAP_XZ_2_WORLD_XYZ(82, 82),
               MAP_XZ_2_WORLD_XYZ(68, 76),
               MAP_XZ_2_WORLD_XYZ(62, 72),
               MAP_XZ_2_WORLD_XYZ(94, 210)
}
botSpells = {M_SPELL_CONVERT_WILD,
             M_SPELL_BLAST,
             M_SPELL_LAND_BRIDGE,
             M_SPELL_LIGHTNING_BOLT,
             M_SPELL_INSECT_PLAGUE,
             M_SPELL_INVISIBILITY,
             M_SPELL_GHOST_ARMY,
             M_SPELL_SWAMP,
             M_SPELL_HYPNOTISM
}
botBldgs = {M_BUILDING_TEPEE,
            M_BUILDING_DRUM_TOWER,
            M_BUILDING_WARRIOR_TRAIN,
            M_BUILDING_TEMPLE,
            M_BUILDING_SUPER_TRAIN,
            M_BUILDING_BOAT_HUT_1
}

set_players_allied(0,1)
set_players_allied(1,0)

for i = 4,7 do
  for u,v in ipairs(botSpells) do
    PThing.SpellSet(availableNums[i-3], v, TRUE, FALSE)
    PThing.SpellSet(TRIBE_BLACK, M_SPELL_WHIRLWIND, TRUE, FALSE)
  end

  for y,v in ipairs(botBldgs) do
    PThing.BldgSet(availableNums[i-3], v, TRUE)
    PThing.BldgSet(TRIBE_CYAN, M_BUILDING_SPY_TRAIN, TRUE)
  end

  computer_init_player(_gsi.Players[availableNums[i-3]])

  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_EXPANSION, 24+G_RANDOM(16))
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_HOUSE_PERCENTAGE, 36+G_RANDOM(28))
  WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_HOUSE_PERCENTAGE, 60+G_RANDOM(40))
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_MAX_BUILDINGS_ON_GO, 5+G_RANDOM(5))
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_PREF_WARRIOR_TRAINS, 0)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_PREF_WARRIOR_PEOPLE, 0)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_PREF_RELIGIOUS_TRAINS, 0)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_PREF_RELIGIOUS_PEOPLE, 0)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_PREF_SUPER_WARRIOR_TRAINS, 0)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_PREF_SUPER_WARRIOR_PEOPLE, 0)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_PREF_SPY_TRAINS, 0)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_PREF_SPY_PEOPLE, 0)
  WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_PREF_SPY_TRAINS, 1)
  WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_PREF_SPY_PEOPLE, 5)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_AWAY_BRAVE, 5)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_AWAY_WARRIOR, 80)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_AWAY_RELIGIOUS, 69)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_AWAY_SUPER_WARRIOR, 47)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_AWAY_SPY, 0)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_AWAY_MEDICINE_MAN, 100)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_USE_PREACHER_FOR_DEFENCE, 1)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_DEFENSE_RAD_INCR, 4)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_MAX_DEFENSIVE_ACTIONS, 3)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_ATTACK_PERCENTAGE, 125)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_MAX_ATTACKS, 15)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_RETREAT_VALUE, 0+G_RANDOM(25))
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_BASE_UNDER_ATTACK_RETREAT, 0)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_RANDOM_BUILD_SIDE, 1)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_GROUP_OPTION, 0)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_PEOPLE_PER_BOAT, 8)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_PEOPLE_PER_BALLOON, 1)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_ENEMY_SPY_MAX_STAND, 255)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_SPY_CHECK_FREQUENCY, 128)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_SPY_DISCOVER_CHANCE, 30)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_MAX_TRAIN_AT_ONCE, 5)
  WRITE_CP_ATTRIB(availableNums[i-3], ATTR_SHAMEN_BLAST, 8)

  WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_PREF_BOAT_HUTS, 1)
  WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_PREF_BOAT_DRIVERS, 5)
  STATE_SET(TRIBE_CYAN, TRUE, CP_AT_TYPE_BUILD_VEHICLE)
  STATE_SET(TRIBE_CYAN, TRUE, CP_AT_TYPE_FETCH_FAR_VEHICLE)

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
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-3], M_SPELL_SWAMP, 100)

  SET_DEFENCE_RADIUS(availableNums[i-3], 7)
  SET_SPELL_ENTRY(availableNums[i-3], 0, M_SPELL_INSECT_PLAGUE, 25000, 64, 3, 0)
  SET_SPELL_ENTRY(availableNums[i-3], 1, M_SPELL_LIGHTNING_BOLT, 40000, 64, 2, 0)
  SET_SPELL_ENTRY(availableNums[i-3], 2, M_SPELL_HYPNOTISM, 70000, 64, 6, 0)
  SET_SPELL_ENTRY(availableNums[i-3], 3, M_SPELL_INSECT_PLAGUE, 25000, 64, 3, 1)
  SET_SPELL_ENTRY(availableNums[i-3], 4, M_SPELL_LIGHTNING_BOLT, 40000, 64, 2, 1)
  SET_SPELL_ENTRY(availableNums[i-3], 5, M_SPELL_HYPNOTISM, 70000, 64, 6, 1)
end

SHAMAN_DEFEND(TRIBE_CYAN, 166, 86, TRUE)
SHAMAN_DEFEND(TRIBE_PINK, 74, 30, TRUE)
SHAMAN_DEFEND(TRIBE_BLACK, 64, 108, TRUE)
SHAMAN_DEFEND(TRIBE_ORANGE, 138, 246, TRUE)
SET_DRUM_TOWER_POS(TRIBE_CYAN, 166, 86)
SET_DRUM_TOWER_POS(TRIBE_PINK, 74, 30)
SET_DRUM_TOWER_POS(TRIBE_BLACK, 64, 108)
SET_DRUM_TOWER_POS(TRIBE_ORANGE, 138, 246)

SET_MARKER_ENTRY(TRIBE_BLACK, 0, 62, 61, 0, 1, 1, 1)
SET_MARKER_ENTRY(TRIBE_BLACK, 1, 60, 59, 0, 1, 1, 1)
SET_MARKER_ENTRY(TRIBE_BLACK, 2, 58, 57, 0, 1, 1, 1)
SET_MARKER_ENTRY(TRIBE_BLACK, 3, 56, 55, 0, 1, 1, 1)
SET_MARKER_ENTRY(TRIBE_BLACK, 4, 54, 53, 0, 1, 1, 1)
SET_MARKER_ENTRY(TRIBE_BLACK, 5, 52, 51, 0, 1, 1, 1)
SET_MARKER_ENTRY(TRIBE_BLACK, 6, 50, 49, 0, 1, 1, 1)
SET_MARKER_ENTRY(TRIBE_BLACK, 7, 48, 47, 0, 1, 1, 1)
SET_MARKER_ENTRY(TRIBE_BLACK, 8, 46, 45, 0, 1, 1, 1)

function OnTurn()
  if (GetTurn() > 1) then
    if (GetTurn() > tick_c_attack) then
      tick_c_attack = GetTurn() + (1840 + G_RANDOM(512))
      if (FREE_ENTRIES(TRIBE_CYAN) > 4) then
        if (G_RANDOM(2) == 1) then
          if (PLAYERS_PEOPLE_OF_TYPE(TRIBE_CYAN, M_PERSON_WARRIOR) > 3) then
            if (_gsi.Players[TRIBE_CYAN].NumPeople > 30) then
              local spell = M_SPELL_INVISIBILITY
              local mkr = NO_MARKER
              local enemy = TRIBE_ORANGE

              if (_gsi.Players[enemy].NumPeople == 0) then
                enemy = TRIBE_MAGENTA
              end

              if (GET_HEIGHT_AT_POS(12) == 0) then
                spell = M_SPELL_LAND_BRIDGE
                mkr = 13
                WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_AWAY_MEDICINE_MAN, 1)
              end

              WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_AWAY_RELIGIOUS, 35)
              WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_AWAY_SUPER_WARRIOR, 35)
              WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_AWAY_WARRIOR, 35)
              WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_AWAY_SPY, 1)
              ATTACK(TRIBE_CYAN, enemy, 8+G_RANDOM(5), ATTACK_BUILDING, -1, G_RANDOM(1000), spell, M_SPELL_SWAMP, M_SPELL_SWAMP, ATTACK_NORMAL, 0, 11, mkr, 0)
            end
          end
        else
          if (PLAYERS_PEOPLE_OF_TYPE(TRIBE_CYAN, M_PERSON_RELIGIOUS) > 4) then
            if (_gsi.Players[TRIBE_CYAN].NumPeople > 35) then
              local spell = M_SPELL_INVISIBILITY
              local mkr = NO_MARKER
              local enemy = TRIBE_RED

              if (_gsi.Players[enemy].NumPeople == 0) then
                enemy = TRIBE_BLUE
              end

              if (GET_HEIGHT_AT_POS(9) == 0) then
                spell = M_SPELL_LAND_BRIDGE
                mkr = 10
                WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_AWAY_MEDICINE_MAN, 1)
              end

              WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_AWAY_RELIGIOUS, 35)
              WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_AWAY_SUPER_WARRIOR, 35)
              WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_AWAY_WARRIOR, 35)
              WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_AWAY_SPY, 1)
              ATTACK(TRIBE_CYAN, enemy, 10+G_RANDOM(8), ATTACK_BUILDING, -1, G_RANDOM(1000), spell, M_SPELL_SWAMP, M_SPELL_SWAMP, ATTACK_NORMAL, 0, 8, mkr, 0)
            end
          end
        end
      end
    elseif (GetTurn() > tick_p_attack) then
      tick_p_attack = GetTurn() + (1540 + G_RANDOM(512))
      if (PLAYERS_PEOPLE_OF_TYPE(TRIBE_PINK, M_PERSON_WARRIOR) > 5 and FREE_ENTRIES(TRIBE_PINK) > 3) then
        if (_gsi.Players[TRIBE_ORANGE].NumPeople > 0) then
          WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_RELIGIOUS, 35)
          WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_SUPER_WARRIOR, 35)
          WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_WARRIOR, 35)

          local ppl = 6

          if (_gsi.Players[TRIBE_PINK].NumPeople > 80 and G_RANDOM(16) == 1) then
            ppl = 24
          end

          if (IS_SHAMAN_AVAILABLE_FOR_ATTACK(TRIBE_PINK) > 0) then
            WRITE_CP_ATTRIB(TRIBE_PINK, ATTR_AWAY_MEDICINE_MAN, 1)
          end

          ATTACK(TRIBE_PINK, TRIBE_ORANGE, ppl+G_RANDOM(ppl), ATTACK_BUILDING, -1, G_RANDOM(1000), M_SPELL_HYPNOTISM, M_SPELL_SWAMP, M_SPELL_LIGHTNING_BOLT, ATTACK_NORMAL, 0, NO_MARKER, NO_MARKER, NO_MARKER)
        end
      end
    elseif (GetTurn() > tick_b_attack) then
      tick_b_attack = GetTurn() + (1794 + G_RANDOM(512))
      if (G_RANDOM(2) == 1 and _gsi.Players[TRIBE_BLACK].NumPeople > 45) then
        local troops = PLAYERS_PEOPLE_OF_TYPE(TRIBE_BLACK, M_PERSON_WARRIOR)
        troops = troops + PLAYERS_PEOPLE_OF_TYPE(TRIBE_BLACK, M_PERSON_RELIGIOUS)
        troops = troops + PLAYERS_PEOPLE_OF_TYPE(TRIBE_BLACK, M_PERSON_SUPER_WARRIOR)
        troops = math.floor(troops / 4)

        if (_gsi.Players[TRIBE_BLUE].NumPeople > 0 or _gsi.Players[TRIBE_RED].NumPeople > 0) then
          local spell = M_SPELL_WHIRLWIND
          local marker = NO_MARKER

          if (GET_HEIGHT_AT_POS(64) == 0) then
            spell = M_SPELL_LAND_BRIDGE
            marker = 65
          end

          WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_MEDICINE_MAN, 1)
          WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_RELIGIOUS, 25+G_RANDOM(50))
          WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_SUPER_WARRIOR, 25+G_RANDOM(50))
          WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_WARRIOR, 25+G_RANDOM(50))

          ATTACK(TRIBE_BLACK, G_RANDOM(2), troops, ATTACK_BUILDING, -1, G_RANDOM(1000), spell, M_SPELL_SWAMP, M_SPELL_WHIRLWIND, ATTACK_NORMAL, 0, 63, marker, NO_MARKER)
        elseif (_gsi.Players[TRIBE_CYAN].NumPeople > 0 or _gsi.Players[TRIBE_GREEN].NumPeople > 0) then
          if (G_RANDOM(2) == 0) then
            local spell = M_SPELL_WHIRLWIND
            local marker = NO_MARKER
            local marker_group = 66
            local enemy = TRIBE_GREEN

            if (GET_HEIGHT_AT_POS(67) == 0) then
              spell = M_SPELL_LAND_BRIDGE
              marker = 68
            end

            WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_MEDICINE_MAN, 1)
            WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_RELIGIOUS, 25+G_RANDOM(50))
            WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_SUPER_WARRIOR, 25+G_RANDOM(50))
            WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_WARRIOR, 25+G_RANDOM(50))

            ATTACK(TRIBE_BLACK, enemy, troops, ATTACK_BUILDING, -1, G_RANDOM(1000), spell, M_SPELL_SWAMP, M_SPELL_WHIRLWIND, ATTACK_NORMAL, 0, marker_group, marker, NO_MARKER)
          else
            local spell = M_SPELL_WHIRLWIND
            local marker = NO_MARKER
            local marker_group = 66
            local enemy = TRIBE_GREEN

            if (GET_HEIGHT_AT_POS(9) ~= 0) then
              spell = M_SPELL_WHIRLWIND
              marker = NO_MARKER
              marker_group = 10
              enemy = TRIBE_CYAN
            end

            WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_MEDICINE_MAN, 1)
            WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_RELIGIOUS, 25+G_RANDOM(50))
            WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_SUPER_WARRIOR, 25+G_RANDOM(50))
            WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_WARRIOR, 25+G_RANDOM(50))

            ATTACK(TRIBE_BLACK, enemy, troops, ATTACK_BUILDING, -1, G_RANDOM(1000), spell, M_SPELL_SWAMP, M_SPELL_WHIRLWIND, ATTACK_NORMAL, 0, marker_group, marker, NO_MARKER)
          end
        end
      else
        local troops = PLAYERS_PEOPLE_OF_TYPE(TRIBE_BLACK, M_PERSON_WARRIOR)
        troops = troops + PLAYERS_PEOPLE_OF_TYPE(TRIBE_BLACK, M_PERSON_RELIGIOUS)
        troops = troops + PLAYERS_PEOPLE_OF_TYPE(TRIBE_BLACK, M_PERSON_SUPER_WARRIOR)
        troops = math.floor(troops / 4)

        if (_gsi.Players[TRIBE_GREEN].NumPeople > 0) then
          local spell = M_SPELL_WHIRLWIND
          local marker = NO_MARKER
          local marker_group = 69

          if (GET_HEIGHT_AT_POS(70) == 0) then
            spell = M_SPELL_LAND_BRIDGE
            marker = 71
          end

          WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_MEDICINE_MAN, 1)
          WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_RELIGIOUS, 25+G_RANDOM(50))
          WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_SUPER_WARRIOR, 25+G_RANDOM(50))
          WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_WARRIOR, 25+G_RANDOM(50))

          ATTACK(TRIBE_BLACK, TRIBE_GREEN, troops, ATTACK_BUILDING, -1, G_RANDOM(1000), spell, M_SPELL_SWAMP, M_SPELL_WHIRLWIND, ATTACK_NORMAL, 0, marker_group, marker, NO_MARKER)
        end
      end
    elseif (GetTurn() > tick_o_attack) then
      tick_o_attack = GetTurn() + (1840 + G_RANDOM(512))
      if (_gsi.Players[TRIBE_ORANGE].NumPeople > 40 and FREE_ENTRIES(TRIBE_ORANGE) > 2) then
        if (_gsi.Players[TRIBE_PINK].NumPeople > 0 or _gsi.Players[TRIBE_CYAN].NumPeople > 0) then
          if (G_RANDOM(2) == 1) then
            WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_MEDICINE_MAN, 1)
            WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_RELIGIOUS, 25+G_RANDOM(50))
            WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_SUPER_WARRIOR, 25+G_RANDOM(50))
            WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_WARRIOR, 25+G_RANDOM(50))

            ATTACK(TRIBE_ORANGE, TRIBE_PINK, 2+G_RANDOM(10), ATTACK_BUILDING, -1, G_RANDOM(200), M_SPELL_HYPNOTISM, M_SPELL_SWAMP, M_SPELL_HYPNOTISM, ATTACK_NORMAL, 0, NO_MARKER, NO_MARKER, NO_MARKER)
          else
            if (GET_HEIGHT_AT_POS(12) > 0) then
              WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_MEDICINE_MAN, 1)
              WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_RELIGIOUS, 25+G_RANDOM(50))
              WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_SUPER_WARRIOR, 25+G_RANDOM(50))
              WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_WARRIOR, 25+G_RANDOM(50))

              ATTACK(TRIBE_ORANGE, TRIBE_CYAN, 10+G_RANDOM(10), ATTACK_BUILDING, -1, G_RANDOM(1000), M_SPELL_HYPNOTISM, M_SPELL_SWAMP, M_SPELL_HYPNOTISM, ATTACK_NORMAL, 0, 13, NO_MARKER, NO_MARKER)
            else
              WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_MEDICINE_MAN, 1)
              WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_RELIGIOUS, 25+G_RANDOM(50))
              WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_SUPER_WARRIOR, 25+G_RANDOM(50))
              WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_WARRIOR, 25+G_RANDOM(50))

              ATTACK(TRIBE_ORANGE, TRIBE_PINK, 2+G_RANDOM(10), ATTACK_BUILDING, -1, G_RANDOM(200), M_SPELL_HYPNOTISM, M_SPELL_SWAMP, M_SPELL_HYPNOTISM, ATTACK_NORMAL, 0, NO_MARKER, NO_MARKER, NO_MARKER)
            end
          end
        end
      end
    end

    if (GetTurn() > tick_c_boat) then
      tick_c_boat = GetTurn() + (840 + G_RANDOM(320))
      if (PLAYERS_VEHICLE_OF_TYPE(TRIBE_CYAN, M_VEHICLE_BOAT_1) > 0 and FREE_ENTRIES(TRIBE_CYAN) > 1) then
        if (PLAYERS_PEOPLE_OF_TYPE(TRIBE_CYAN, M_PERSON_SUPER_WARRIOR) > 5) then
          local wta = cyanEnemies[G_RANDOM(tablelength(cyanEnemies))+1]
          local tries = 16

          while tries > 0 do
            tries = tries-1
            if (_gsi.Players[wta].NumPeople == 0) then
              wta = cyanEnemies[G_RANDOM(tablelength(cyanEnemies))+1]
            else
              break
            end
          end

          WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_AWAY_RELIGIOUS, G_RANDOM(100))
          WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_AWAY_SUPER_WARRIOR, G_RANDOM(100))
          WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_AWAY_WARRIOR, G_RANDOM(100))
          WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_AWAY_SPY, G_RANDOM(10))
          WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_AWAY_MEDICINE_MAN, G_RANDOM(2))
          ATTACK(TRIBE_CYAN, wta, 4+G_RANDOM(GET_NUM_OF_AVAILABLE_BOATS(TRIBE_CYAN)+1)*4, ATTACK_BUILDING, -1, 850, M_SPELL_INVISIBILITY, M_SPELL_SWAMP, M_SPELL_SWAMP, ATTACK_BY_BOAT, 0, NO_MARKER, NO_MARKER, NO_MARKER)
        end
      end
    elseif (GetTurn() > tick_b_boat) then
      tick_b_boat = GetTurn() + (1000 + G_RANDOM(380))
      if (PLAYERS_VEHICLE_OF_TYPE(TRIBE_BLACK, M_VEHICLE_BOAT_1) > 0 and FREE_ENTRIES(TRIBE_BLACK) > 1) then
        if (PLAYERS_PEOPLE_OF_TYPE(TRIBE_BLACK, M_PERSON_SUPER_WARRIOR) > 5) then
          local wta = blackEnemies[G_RANDOM(tablelength(blackEnemies))+1]
          local tries = 16

          while tries > 0 do
            tries = tries-1
            if (_gsi.Players[wta].NumPeople == 0) then
              wta = blackEnemies[G_RANDOM(tablelength(blackEnemies))+1]
            else
              break
            end
          end

          WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_RELIGIOUS, G_RANDOM(100))
          WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_SUPER_WARRIOR, G_RANDOM(100))
          WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_WARRIOR, G_RANDOM(100))
          WRITE_CP_ATTRIB(TRIBE_BLACK, ATTR_AWAY_MEDICINE_MAN, G_RANDOM(2))
          ATTACK(TRIBE_BLACK, wta, 4+G_RANDOM(GET_NUM_OF_AVAILABLE_BOATS(TRIBE_BLACK)+1)*4, ATTACK_BUILDING, -1, 999, M_SPELL_WHIRLWIND, M_SPELL_WHIRLWIND, M_SPELL_WHIRLWIND, ATTACK_BY_BOAT, 0, NO_MARKER, NO_MARKER, NO_MARKER)
        end
      end
    elseif (GetTurn() > tick_o_boat) then
      tick_o_boat = GetTurn() + (1000 + G_RANDOM(1000))
      if (FREE_ENTRIES(TRIBE_ORANGE) > 2 and PLAYERS_VEHICLE_OF_TYPE(TRIBE_ORANGE, M_VEHICLE_BOAT_1) > 0) then
        if (_gsi.Players[TRIBE_BLUE].NumPeople > 0 or _gsi.Players[TRIBE_RED].NumPeople > 0) then
          local myenemy = G_RANDOM(2)
          local tries = 16

          while tries > 0 do
            tries = tries-1
            if (_gsi.Players[myenemy].NumPeople == 0) then
              myenemy = G_RANDOM(2)
            else
              break
            end
          end

          WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_AWAY_RELIGIOUS, G_RANDOM(100))
          WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_AWAY_SUPER_WARRIOR, G_RANDOM(100))
          WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_AWAY_WARRIOR, G_RANDOM(100))
          WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_AWAY_MEDICINE_MAN, G_RANDOM(2))
          ATTACK(TRIBE_ORANGE, myenemy, 4+G_RANDOM(GET_NUM_OF_AVAILABLE_BOATS(TRIBE_ORANGE)+1)*4, ATTACK_BUILDING, -1, 999, M_SPELL_HYPNOTISM, M_SPELL_HYPNOTISM, M_SPELL_HYPNOTISM, ATTACK_BY_BOAT, 0, NO_MARKER, NO_MARKER, NO_MARKER)
        end
      end
    end

    if (GetTurn() > tick_p_expand) then
      tick_p_expand = GetTurn() + (480 + G_RANDOM(800))
      if (MANA(TRIBE_PINK) > 70000 and FREE_ENTRIES(TRIBE_PINK) > 2) then
        if (IS_SHAMAN_AVAILABLE_FOR_ATTACK(TRIBE_PINK) > 0) then
          local temp = G_RANDOM(8)
          local tries = 16

          while tries > 0 do
            tries = tries-1
            if (_gsi.Players[temp].NumPeople == 0 or temp == TRIBE_PINK) then
              temp = G_RANDOM(8)
            else
              break
            end
          end

          if (pink_expand == 0) then
            ATTACK(TRIBE_PINK, temp, 0, ATTACK_BUILDING, -1, 0, M_SPELL_LAND_BRIDGE, M_SPELL_NONE, M_SPELL_NONE, ATTACK_NORMAL, 0, 16, 17, NO_MARKER)
            pink_expand = 1
          elseif (pink_expand == 1) then
            ATTACK(TRIBE_PINK, temp, 0, ATTACK_BUILDING, -1, 0, M_SPELL_LAND_BRIDGE, M_SPELL_NONE, M_SPELL_NONE, ATTACK_NORMAL, 0, 16, 18, NO_MARKER)
            pink_expand = 2
          elseif (pink_expand == 2) then
            ATTACK(TRIBE_PINK, temp, 0, ATTACK_BUILDING, -1, 0, M_SPELL_LAND_BRIDGE, M_SPELL_NONE, M_SPELL_NONE, ATTACK_NORMAL, 0, 19, 20, NO_MARKER)
            pink_expand = 3
          elseif (pink_expand == 3) then
            ATTACK(TRIBE_PINK, temp, 0, ATTACK_BUILDING, -1, 0, M_SPELL_LAND_BRIDGE, M_SPELL_NONE, M_SPELL_NONE, ATTACK_NORMAL, 0, 19, 21, NO_MARKER)
            pink_expand = 4
          elseif (pink_expand == 4) then
            ATTACK(TRIBE_PINK, temp, 0, ATTACK_BUILDING, -1, 0, M_SPELL_LAND_BRIDGE, M_SPELL_NONE, M_SPELL_NONE, ATTACK_NORMAL, 0, 22, 23, NO_MARKER)
            pink_expand = 5
          elseif (pink_expand == 5) then
            ATTACK(TRIBE_PINK, temp, 0, ATTACK_BUILDING, -1, 0, M_SPELL_LAND_BRIDGE, M_SPELL_NONE, M_SPELL_NONE, ATTACK_NORMAL, 0, 24, 25, NO_MARKER)
            pink_expand = 6
          end
        end
      end
    end

    if (every2Pow(10)) then
      if (tablelength(cyanTowers) > 0) then
        local t_idx = tablelength(cyanTowers)
        local t_rnd = G_RANDOM(t_idx)+1
        if (cyanTowers[t_rnd] ~= nil and FREE_ENTRIES(TRIBE_CYAN) > 4) then
          local map_idx = MapPosXZ.new()
          map_idx.Pos = world_coord3d_to_map_idx(cyanTowers[t_rnd])
          BUILD_DRUM_TOWER(TRIBE_CYAN, map_idx.XZ.X, map_idx.XZ.Z)
          table.remove(cyanTowers, t_rnd)
        end
      end

      if (tablelength(blackTowers) > 0) then
        local t_idx = tablelength(blackTowers)
        local t_rnd = G_RANDOM(t_idx)+1
        if (blackTowers[t_rnd] ~= nil and FREE_ENTRIES(TRIBE_BLACK) > 4) then
          local map_idx = MapPosXZ.new()
          map_idx.Pos = world_coord3d_to_map_idx(blackTowers[t_rnd])
          BUILD_DRUM_TOWER(TRIBE_BLACK, map_idx.XZ.X, map_idx.XZ.Z)
          table.remove(blackTowers, t_rnd)
        end
      end

      if (_gsi.Players[TRIBE_BLACK].NumPeople > 50) then
        MARKER_ENTRIES(TRIBE_BLACK, 0, 1, 2, 3)
        MARKER_ENTRIES(TRIBE_BLACK, 4, 5, 6, 7)
        MARKER_ENTRIES(TRIBE_BLACK, 8, NO_MARKER, NO_MARKER, NO_MARKER)
      end
    end

    if (every2Pow(9)) then
      for i = 4,7 do
        if (PLAYERS_PEOPLE_OF_TYPE(i, M_PERSON_BRAVE) > 15 and _gsi.Players[i].NumPeople > 25) then
          WRITE_CP_ATTRIB(i, ATTR_PREF_WARRIOR_TRAINS, 1)
          WRITE_CP_ATTRIB(i, ATTR_PREF_WARRIOR_PEOPLE, 17+G_RANDOM(15))
          WRITE_CP_ATTRIB(i, ATTR_PREF_RELIGIOUS_TRAINS, 1)
          WRITE_CP_ATTRIB(i, ATTR_PREF_RELIGIOUS_PEOPLE, 14+G_RANDOM(13))
          WRITE_CP_ATTRIB(i, ATTR_PREF_SUPER_WARRIOR_TRAINS, 1)
          WRITE_CP_ATTRIB(i, ATTR_PREF_SUPER_WARRIOR_PEOPLE, 14+G_RANDOM(13))
          if (i == TRIBE_BLACK and _gsi.Players[i].NumPeople > 80) then
            WRITE_CP_ATTRIB(i, ATTR_PREF_WARRIOR_TRAINS, 1)
            WRITE_CP_ATTRIB(i, ATTR_PREF_WARRIOR_PEOPLE, 21+G_RANDOM(15))
            WRITE_CP_ATTRIB(i, ATTR_PREF_RELIGIOUS_TRAINS, 1)
            WRITE_CP_ATTRIB(i, ATTR_PREF_RELIGIOUS_PEOPLE, 18+G_RANDOM(13))
            WRITE_CP_ATTRIB(i, ATTR_PREF_SUPER_WARRIOR_TRAINS, 1)
            WRITE_CP_ATTRIB(i, ATTR_PREF_SUPER_WARRIOR_PEOPLE, 22+G_RANDOM(13))
            WRITE_CP_ATTRIB(i, ATTR_HOUSE_PERCENTAGE, 85+G_RANDOM(50))
            STATE_SET(i, FALSE, CP_AT_TYPE_MED_MAN_GET_WILD_PEEPS)

            if (GetTurn() > (12*60)*8) then
              WRITE_CP_ATTRIB(i, ATTR_PREF_BOAT_HUTS, 1)
              WRITE_CP_ATTRIB(i, ATTR_PREF_BOAT_DRIVERS, 7)
              STATE_SET(i, TRUE, CP_AT_TYPE_BUILD_VEHICLE)
              STATE_SET(i, TRUE, CP_AT_TYPE_FETCH_FAR_VEHICLE)
            end
          end
          if (i == TRIBE_ORANGE and GetTurn() > (12*60)*6) then
            WRITE_CP_ATTRIB(i, ATTR_PREF_BOAT_HUTS, 1)
            WRITE_CP_ATTRIB(i, ATTR_PREF_BOAT_DRIVERS, 7)
            STATE_SET(i, TRUE, CP_AT_TYPE_BUILD_VEHICLE)
            STATE_SET(i, TRUE, CP_AT_TYPE_FETCH_FAR_VEHICLE)
          end
        else
          WRITE_CP_ATTRIB(i, ATTR_PREF_WARRIOR_TRAINS, 0)
          WRITE_CP_ATTRIB(i, ATTR_PREF_WARRIOR_PEOPLE, 5)
          WRITE_CP_ATTRIB(i, ATTR_PREF_RELIGIOUS_TRAINS, 0)
          WRITE_CP_ATTRIB(i, ATTR_PREF_RELIGIOUS_PEOPLE, 5)
          WRITE_CP_ATTRIB(i, ATTR_PREF_SUPER_WARRIOR_TRAINS, 0)
          WRITE_CP_ATTRIB(i, ATTR_PREF_SUPER_WARRIOR_PEOPLE, 5)
          STATE_SET(i, TRUE, CP_AT_TYPE_MED_MAN_GET_WILD_PEEPS)
        end
      end

      ProcessGlobalTypeList(T_BUILDING, function(t)
        if (t.Model < 4 and t.Owner > 1) then
          if (t.u.Bldg.SproggingCount < 2000) then
            t.u.Bldg.SproggingCount = t.u.Bldg.SproggingCount + 1000
          end
        end

        if (t.Model < 3 and t.Owner > 1) then
          if (t.u.Bldg.UpgradeCount < 625) then
            t.u.Bldg.UpgradeCount = t.u.Bldg.UpgradeCount + 175
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
          _gsi.Players[TRIBE_ORANGE].NumPeople +
          _gsi.Players[TRIBE_YELLOW].NumPeople +
          _gsi.Players[TRIBE_GREEN].NumPeople +
          _gsi.Players[TRIBE_PINK].NumPeople +
          _gsi.Players[TRIBE_BLACK].NumPeople < 300 and
          GetTurn() < (12*60)*4 and
          GetTurn() > (12*10)) then
        process(numthings)
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
            spell_delay[idx] = 26
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
