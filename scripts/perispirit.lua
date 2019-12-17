import(Module_Defines)
import(Module_PopScript)
import(Module_Game)
import(Module_Objects)
import(Module_Map)
import(Module_MapWho)

include("UtilPThings.lua")
include("UtilRefs.lua")

_c.MaxManaValue = 2000000
_c.ShamenDeadManaPer256Gained = 16

wilds = {}
spell_delay = {0,0,0,0}
index = 1
availableNums = {4,7,2,3}
numthings = 16
cyanEnemies = {0,1,2,3,7}
orangeEnemies = {0,1,2,3,4}
tickCyanAttack = GetTurn() + (1744+G_RANDOM(512))
tickOrangeAttack = GetTurn() + (1744+G_RANDOM(512))
tickCyanBoat = GetTurn() + (630+G_RANDOM(250))
tickOrangeBoat = GetTurn() + (630+G_RANDOM(250))
cyanTowers = {MAP_XZ_2_WORLD_XYZ(162, 150),
              MAP_XZ_2_WORLD_XYZ(154, 132),
              MAP_XZ_2_WORLD_XYZ(152, 156),
              MAP_XZ_2_WORLD_XYZ(190, 192),
              MAP_XZ_2_WORLD_XYZ(188, 124),
              MAP_XZ_2_WORLD_XYZ(196, 118),
              MAP_XZ_2_WORLD_XYZ(206, 170),
              MAP_XZ_2_WORLD_XYZ(170, 210)
}
orangeTowers = {MAP_XZ_2_WORLD_XYZ(144, 98),
                MAP_XZ_2_WORLD_XYZ(134, 38),
                MAP_XZ_2_WORLD_XYZ(112, 42),
                MAP_XZ_2_WORLD_XYZ(94, 92),
                MAP_XZ_2_WORLD_XYZ(98, 84),
                MAP_XZ_2_WORLD_XYZ(156, 60),
                MAP_XZ_2_WORLD_XYZ(146, 16)
}
botSpells = {M_SPELL_CONVERT_WILD,
             M_SPELL_BLAST,
             M_SPELL_LAND_BRIDGE,
             M_SPELL_LIGHTNING_BOLT,
             M_SPELL_INSECT_PLAGUE,
             M_SPELL_INVISIBILITY,
             M_SPELL_GHOST_ARMY,
}
botBldgs = {M_BUILDING_TEPEE,
            M_BUILDING_DRUM_TOWER,
            M_BUILDING_WARRIOR_TRAIN,
            M_BUILDING_TEMPLE,
            M_BUILDING_SUPER_TRAIN,
            M_BUILDING_BOAT_HUT_1
}

for i = 2,3 do
  for j = 0,1 do
    set_players_allied(i-2,j)
  end

  for u,v in ipairs(botSpells) do
    PThing.SpellSet(availableNums[i-1], v, TRUE, FALSE)
    PThing.SpellSet(TRIBE_CYAN, M_SPELL_SWAMP, TRUE, FALSE)
  end

  for y,v in ipairs(botBldgs) do
    PThing.BldgSet(availableNums[i-1], v, TRUE)
  end

  computer_init_player(_gsi.Players[availableNums[i-1]])

  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_EXPANSION, 24+G_RANDOM(8))
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_HOUSE_PERCENTAGE, 36+G_RANDOM(28))
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_MAX_BUILDINGS_ON_GO, 3+G_RANDOM(5))
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
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_MAX_ATTACKS, 15)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_RETREAT_VALUE, 0+G_RANDOM(25))
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_BASE_UNDER_ATTACK_RETREAT, 0)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_RANDOM_BUILD_SIDE, 1)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_GROUP_OPTION, 1)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_PEOPLE_PER_BOAT, 8)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_PEOPLE_PER_BALLOON, 1)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_ENEMY_SPY_MAX_STAND, 255)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_SPY_CHECK_FREQUENCY, 128)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_SPY_DISCOVER_CHANCE, 10)
  WRITE_CP_ATTRIB(availableNums[i-1], ATTR_MAX_TRAIN_AT_ONCE, 5)
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
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-1], M_SPELL_GHOST_ARMY, 12)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-1], M_SPELL_INSECT_PLAGUE, 16)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-1], M_SPELL_LAND_BRIDGE, 32)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-1], M_SPELL_LIGHTNING_BOLT, 40)
  SET_BUCKET_COUNT_FOR_SPELL(availableNums[i-1], M_SPELL_INVISIBILITY, 28)

  SET_DEFENCE_RADIUS(availableNums[i-1], 7)
  SET_SPELL_ENTRY(availableNums[i-1], 0, M_SPELL_INSECT_PLAGUE, 25000, 64, 3, 0)
  SET_SPELL_ENTRY(availableNums[i-1], 1, M_SPELL_LIGHTNING_BOLT, 40000, 64, 2, 0)
  SET_SPELL_ENTRY(availableNums[i-1], 2, M_SPELL_GHOST_ARMY, 20000, 64, 3, 0)
  SET_SPELL_ENTRY(availableNums[i-1], 3, M_SPELL_INSECT_PLAGUE, 25000, 64, 3, 1)
  SET_SPELL_ENTRY(availableNums[i-1], 4, M_SPELL_LIGHTNING_BOLT, 40000, 64, 2, 1)
  SET_SPELL_ENTRY(availableNums[i-1], 5, M_SPELL_GHOST_ARMY, 20000, 64, 3, 1)
end

SHAMAN_DEFEND(TRIBE_CYAN, 190, 164, TRUE)
SHAMAN_DEFEND(TRIBE_ORANGE, 132, 60, TRUE)
SET_DRUM_TOWER_POS(TRIBE_CYAN, 190, 164)
SET_DRUM_TOWER_POS(TRIBE_ORANGE, 132, 60)

SET_MARKER_ENTRY(TRIBE_CYAN, 0, 59, 58, 0, 1, 2, 1)
SET_MARKER_ENTRY(TRIBE_CYAN, 1, 57, 56, 0, 1, 1, 2)
SET_MARKER_ENTRY(TRIBE_CYAN, 2, 55, 54, 0, 1, 2, 1)
SET_MARKER_ENTRY(TRIBE_CYAN, 3, 53, 52, 0, 1, 2, 1)
SET_MARKER_ENTRY(TRIBE_CYAN, 4, 51, 50, 0, 1, 1, 2)
SET_MARKER_ENTRY(TRIBE_CYAN, 5, 49, 48, 0, 1, 1, 2)

SET_MARKER_ENTRY(TRIBE_ORANGE, 0, 37, 38, 0, 0, 2, 0)
SET_MARKER_ENTRY(TRIBE_ORANGE, 1, 38, 39, 0, 0, 2, 0)
SET_MARKER_ENTRY(TRIBE_ORANGE, 2, 40, 41, 0, 1, 2, 1)
SET_MARKER_ENTRY(TRIBE_ORANGE, 3, 42, 43, 0, 1, 1, 2)
SET_MARKER_ENTRY(TRIBE_ORANGE, 4, 42, 43, 0, 2, 1, 2)
SET_MARKER_ENTRY(TRIBE_ORANGE, 5, 44, 45, 0, 1, 1, 1)
SET_MARKER_ENTRY(TRIBE_ORANGE, 6, 46, 47, 0, 2, 1, 2)

function OnTurn()
  if (GetTurn() > 1) then
    if (GetTurn() > tickCyanAttack) then
      tickCyanAttack = GetTurn() + (1744+G_RANDOM(512))
      if (_gsi.Players[TRIBE_BLUE].NumPeople > 0 or _gsi.Players[TRIBE_RED].NumPeople > 0) then
        if (PLAYERS_PEOPLE_OF_TYPE(TRIBE_CYAN, M_PERSON_RELIGIOUS) > 4) then
          local wta = G_RANDOM(2)
          local tries = 16
          local mkr = 22+G_RANDOM(3)

          while tries > 0 do
            tries = tries-1
            if (_gsi.Players[wta].NumPeople == 0) then
              wta = G_RANDOM(2)
            else
              break
            end
          end

          WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_AWAY_RELIGIOUS, 20+G_RANDOM(80))
          WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_AWAY_SUPER_WARRIOR, 20+G_RANDOM(80))
          WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_AWAY_WARRIOR, 20+G_RANDOM(80))
          WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_AWAY_MEDICINE_MAN, 100)
          ATTACK(TRIBE_CYAN, wta, 4+G_RANDOM(7), ATTACK_BUILDING, -1, 850, M_SPELL_INVISIBILITY, M_SPELL_SWAMP, M_SPELL_SWAMP, ATTACK_NORMAL, 0, mkr, NO_MARKER, NO_MARKER)
        end
      else
        if (PLAYERS_PEOPLE_OF_TYPE(TRIBE_CYAN, M_PERSON_RELIGIOUS) > 4) then
          if (_gsi.Players[TRIBE_GREEN].NumPeople > 0) then
            local mkr = 25+G_RANDOM(3)

            WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_AWAY_RELIGIOUS, 20+G_RANDOM(80))
            WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_AWAY_SUPER_WARRIOR, 20+G_RANDOM(80))
            WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_AWAY_WARRIOR, 20+G_RANDOM(80))
            WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_AWAY_MEDICINE_MAN, 100)
            ATTACK(TRIBE_CYAN, TRIBE_GREEN, 12+G_RANDOM(14), ATTACK_BUILDING, -1, 850, M_SPELL_INVISIBILITY, M_SPELL_SWAMP, M_SPELL_SWAMP, ATTACK_NORMAL, 0, mkr, NO_MARKER, NO_MARKER)
          end
        end
      end
    elseif (GetTurn() > tickOrangeAttack) then
      tickOrangeAttack = GetTurn() + (1744+G_RANDOM(512))
      if (G_RANDOM(100) > 30) then
        if (PLAYERS_PEOPLE_OF_TYPE(TRIBE_ORANGE, M_PERSON_SUPER_WARRIOR) > 4) then
          local wta = G_RANDOM(2)
          local tries = 16

          while tries > 0 do
            tries = tries-1
            if (_gsi.Players[wta].NumPeople == 0) then
              wta = G_RANDOM(2)
            else
              break
            end
          end

          WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_AWAY_RELIGIOUS, 20+G_RANDOM(80))
          WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_AWAY_SUPER_WARRIOR, 20+G_RANDOM(80))
          WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_AWAY_WARRIOR, 20+G_RANDOM(80))
          WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_AWAY_MEDICINE_MAN, 100)
          ATTACK(TRIBE_ORANGE, wta, 4+G_RANDOM(12), ATTACK_BUILDING, -1, 850, M_SPELL_INVISIBILITY, M_SPELL_LIGHTNING_BOLT, M_SPELL_LIGHTNING_BOLT, ATTACK_NORMAL, 0, 28, NO_MARKER, NO_MARKER)
        end
      else
        if (PLAYERS_PEOPLE_OF_TYPE(TRIBE_ORANGE, M_PERSON_SUPER_WARRIOR) > 4) then
          if (_gsi.Players[TRIBE_CYAN].NumPeople > 0) then
            WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_AWAY_RELIGIOUS, 20+G_RANDOM(80))
            WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_AWAY_SUPER_WARRIOR, 20+G_RANDOM(80))
            WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_AWAY_WARRIOR, 20+G_RANDOM(80))
            WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_AWAY_MEDICINE_MAN, 100)
            ATTACK(TRIBE_ORANGE, TRIBE_CYAN, 6+G_RANDOM(14), ATTACK_BUILDING, -1, 850, M_SPELL_INVISIBILITY, M_SPELL_LIGHTNING_BOLT, M_SPELL_LIGHTNING_BOLT, ATTACK_NORMAL, 0, 29, NO_MARKER, NO_MARKER)
          end
        end
      end
    end

    if (GetTurn() > tickCyanBoat) then
      tickCyanBoat = GetTurn() + (430+G_RANDOM(250))
      if (PLAYERS_VEHICLE_OF_TYPE(TRIBE_CYAN, M_VEHICLE_BOAT_1) > 0 and FREE_ENTRIES(TRIBE_CYAN) > 1) then
        if (PLAYERS_PEOPLE_OF_TYPE(TRIBE_CYAN, M_PERSON_RELIGIOUS) > 3) then
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

          WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_AWAY_RELIGIOUS, G_RANDOM(30))
          WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_AWAY_SUPER_WARRIOR, G_RANDOM(30))
          WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_AWAY_WARRIOR, G_RANDOM(30))
          WRITE_CP_ATTRIB(TRIBE_CYAN, ATTR_AWAY_MEDICINE_MAN, G_RANDOM(2))
          ATTACK(TRIBE_CYAN, wta, 4+G_RANDOM(4)*4, ATTACK_BUILDING, -1, 850, M_SPELL_INVISIBILITY, M_SPELL_SWAMP, M_SPELL_SWAMP, ATTACK_BY_BOAT, 0, NO_MARKER, NO_MARKER, NO_MARKER)
        end
      end
    elseif (GetTurn() > tickOrangeBoat) then
      tickOrangeBoat = GetTurn() + (430+G_RANDOM(250))
      if (PLAYERS_VEHICLE_OF_TYPE(TRIBE_ORANGE, M_VEHICLE_BOAT_1) > 0 and FREE_ENTRIES(TRIBE_ORANGE) > 1) then
        if (PLAYERS_PEOPLE_OF_TYPE(TRIBE_ORANGE, M_PERSON_RELIGIOUS) > 3) then
          local wta = orangeEnemies[G_RANDOM(tablelength(orangeEnemies))+1]
          local tries = 16

          while tries > 0 do
            tries = tries-1
            if (_gsi.Players[wta].NumPeople == 0) then
              wta = orangeEnemies[G_RANDOM(tablelength(orangeEnemies))+1]
            else
              break
            end
          end

          WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_AWAY_RELIGIOUS, G_RANDOM(30))
          WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_AWAY_SUPER_WARRIOR, G_RANDOM(30))
          WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_AWAY_WARRIOR, G_RANDOM(30))
          WRITE_CP_ATTRIB(TRIBE_ORANGE, ATTR_AWAY_MEDICINE_MAN, G_RANDOM(2))
          ATTACK(TRIBE_ORANGE, wta, 4+G_RANDOM(4)*4, ATTACK_BUILDING, -1, 850, M_SPELL_INVISIBILITY, M_SPELL_LIGHTNING_BOLT, M_SPELL_LIGHTNING_BOLT, ATTACK_BY_BOAT, 0, NO_MARKER, NO_MARKER, NO_MARKER)
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

      if (tablelength(orangeTowers) > 0) then
        local t_idx = tablelength(orangeTowers)
        local t_rnd = G_RANDOM(t_idx)+1
        if (orangeTowers[t_rnd] ~= nil and FREE_ENTRIES(TRIBE_ORANGE) > 4) then
          local map_idx = MapPosXZ.new()
          map_idx.Pos = world_coord3d_to_map_idx(orangeTowers[t_rnd])
          BUILD_DRUM_TOWER(TRIBE_ORANGE, map_idx.XZ.X, map_idx.XZ.Z)
          table.remove(orangeTowers, t_rnd)
        end
      end

      MARKER_ENTRIES(TRIBE_CYAN, 0, 1, 2, 3)
      MARKER_ENTRIES(TRIBE_CYAN, 4, 5, NO_MARKER, NO_MARKER)
      MARKER_ENTRIES(TRIBE_ORANGE, 0, 1, 2, 3)
      MARKER_ENTRIES(TRIBE_ORANGE, 4, 5, 6, NO_MARKER)
    end

    if (every2Pow(9)) then
      if (PLAYERS_BUILDING_OF_TYPE(TRIBE_BLUE, M_BUILDING_BOAT_HUT_1) > 0 or
          PLAYERS_BUILDING_OF_TYPE(TRIBE_RED, M_BUILDING_BOAT_HUT_1) > 0) then
        for i = 0,1 do
          WRITE_CP_ATTRIB(availableNums[i+1], ATTR_PREF_BOAT_HUTS, 1)
          WRITE_CP_ATTRIB(availableNums[i+1], ATTR_PREF_BOAT_DRIVERS, 5)
          STATE_SET(availableNums[i+1], TRUE, CP_AT_TYPE_BUILD_VEHICLE)
          STATE_SET(availableNums[i+1], TRUE, CP_AT_TYPE_FETCH_FAR_VEHICLE)
        end
      elseif (GetTurn() > (12*60)*15) then
        for i = 0,1 do
          WRITE_CP_ATTRIB(availableNums[i+1], ATTR_PREF_BOAT_HUTS, 1)
          WRITE_CP_ATTRIB(availableNums[i+1], ATTR_PREF_BOAT_DRIVERS, 5)
          STATE_SET(availableNums[i+1], TRUE, CP_AT_TYPE_BUILD_VEHICLE)
          STATE_SET(availableNums[i+1], TRUE, CP_AT_TYPE_FETCH_FAR_VEHICLE)
        end
      end

      ProcessGlobalTypeList(T_BUILDING, function(t)
        if (t.Model < 4 and t.Owner > 1) then
          if (t.u.Bldg.SproggingCount < 2000) then
            t.u.Bldg.SproggingCount = t.u.Bldg.SproggingCount + 950
          end
        end

        if (t.Model < 3 and t.Owner > 1) then
          if (t.u.Bldg.UpgradeCount < 525) then
            t.u.Bldg.UpgradeCount = t.u.Bldg.UpgradeCount + 170
          end
        end

        return true
      end)
    end

    if (every2Pow(3)) then
      if (_gsi.Players[TRIBE_CYAN].NumPeople +
          _gsi.Players[TRIBE_ORANGE].NumPeople +
          _gsi.Players[TRIBE_YELLOW].NumPeople +
          _gsi.Players[TRIBE_GREEN].NumPeople < 160 and
          GetTurn() < (12*60)*2 and
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
