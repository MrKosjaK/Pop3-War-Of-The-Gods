import(Module_Players)
import(Module_Defines)
import(Module_Person)
import(Module_PopScript)
import(Module_Game)
import(Module_Objects)
import(Module_Globals)
import(Module_Map)

include("UtilPThings.lua")

spell_delay = 0
did_set_timer = FALSE
stone_prayed = FALSE
super_erode = FALSE
check_for_people = FALSE
island_sank = FALSE
erodeSpots = {
MAP_XZ_2_WORLD_XYZ(208, 222),
MAP_XZ_2_WORLD_XYZ(202, 224),
MAP_XZ_2_WORLD_XYZ(198, 222),
MAP_XZ_2_WORLD_XYZ(194, 226),
MAP_XZ_2_WORLD_XYZ(206, 192),
MAP_XZ_2_WORLD_XYZ(200, 192),
MAP_XZ_2_WORLD_XYZ(196, 190),
MAP_XZ_2_WORLD_XYZ(190, 192),
MAP_XZ_2_WORLD_XYZ(186, 186),
MAP_XZ_2_WORLD_XYZ(182, 190),
MAP_XZ_2_WORLD_XYZ(190, 224),
MAP_XZ_2_WORLD_XYZ(182, 230),
MAP_XZ_2_WORLD_XYZ(186, 212),
MAP_XZ_2_WORLD_XYZ(186, 204),
MAP_XZ_2_WORLD_XYZ(178, 220),
MAP_XZ_2_WORLD_XYZ(176, 212),
MAP_XZ_2_WORLD_XYZ(174, 202)
}

computer_init_player(_gsi.Players[TRIBE_ORANGE])

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

SHAMAN_DEFEND(TRIBE_ORANGE, 198, 204, TRUE)
DELAY_MAIN_DRUM_TOWER(TRIBE_ORANGE, FALSE)
SET_NO_REINC(TRIBE_ORANGE)
SET_MARKER_ENTRY(TRIBE_ORANGE, 0, 19, 20, 0, 2, 0, 0)
SET_MARKER_ENTRY(TRIBE_ORANGE, 1, 21, 22, 0, 2, 0, 0)
SET_MARKER_ENTRY(TRIBE_ORANGE, 2, 23, 24, 0, 0, 4, 0)
MARKER_ENTRIES(TRIBE_ORANGE, 0, 1, NO_MARKER, NO_MARKER)

for i = 2,3 do
  for j = 0,1 do
    set_players_allied(i-2,j)
  end
  
  SET_NO_REINC(i-2, FALSE)
end

function OnTurn()
  if (EVERY_2POW_TURNS(9)) then
    ProcessGlobalTypeList(T_BUILDING, function(t)
      if (t.Model < 4 and t.Owner > 1) then
        if (t.u.Bldg.SproggingCount < 2000) then
          t.u.Bldg.SproggingCount = t.u.Bldg.SproggingCount + 875
        end
      end
      
      if (t.Model < 3 and t.Owner > 1) then
        if (t.u.Bldg.UpgradeCount < 500) then
          t.u.Bldg.UpgradeCount = t.u.Bldg.UpgradeCount + 155
        end
      end
      
      return true
    end)
  end
  
  if (EVERY_2POW_TURNS(6)) then
    if (_gsi.Counts.GameTurn > 12*5 and _gsi.Counts.GameTurn < 12*120) then
      if (erodeSpots[1] ~= nil and spell_delay == 0) then
        createThing(T_SPELL, M_SPELL_EROSION, TRIBE_ORANGE, erodeSpots[1], false, false)
        spell_delay = 36
        table.remove(erodeSpots, 1)
      end
    elseif (_gsi.Counts.GameTurn > 12*120) then
      SHAMAN_DEFEND(TRIBE_ORANGE, 240, 226, TRUE)
      MARKER_ENTRIES(TRIBE_ORANGE, 2, NO_MARKER, NO_MARKER, NO_MARKER)
    end
  end
  
  if (did_set_timer == TRUE and HAS_TIMER_REACHED_ZERO() == true) then
    REMOVE_TIMER()
    ProcessGlobalTypeList(T_PERSON, function(t)
      if (t.Owner == TRIBE_BLUE or t.Owner == TRIBE_RED) then
        damage_person(t, TRIBE_ORANGE, 65535, 1)
      end
      
      return true
    end)
  elseif (did_set_timer == TRUE and GET_HEAD_TRIGGER_COUNT(238,210) == 0 and stone_prayed == FALSE) then
    REMOVE_TIMER()
    super_erode = TRUE
    stone_prayed = TRUE
  end
  
  if (EVERY_2POW_TURNS(4)) then
    if (COUNT_PEOPLE_IN_MARKER(TRIBE_ORANGE,TRIBE_BLUE,26,8) +
        COUNT_PEOPLE_IN_MARKER(TRIBE_ORANGE,TRIBE_RED,26,8) > 1 and
        check_for_people == TRUE and island_sank == FALSE) then
      check_for_people = FALSE
      island_sank = TRUE
      local c3d = MAP_XZ_2_WORLD_XYZ(194, 108)
      createThing(T_EFFECT, M_EFFECT_EROSION, TRIBE_ORANGE, c3d, false, false)
    end
  end
  
  if (spell_delay > 0) then
    spell_delay = spell_delay-1
  end
end

function OnCreateThing(t)
  if (t.Type == T_EFFECT) then
    if (t.Model == M_EFFECT_ATLANTIS_INVOKE) then
      if (did_set_timer ~= TRUE) then
        SET_TIMER_GOING((12*60)*8,1)
        log_msg(TRIBE_NEUTRAL,"TIP: The time is controlled by us, stones give unlimited power.")
        did_set_timer = TRUE
        check_for_people = TRUE
      end
    end
    
    if (t.Model == M_EFFECT_EROSION and t.Owner < 2) then
      if (super_erode == TRUE) then
        super_erode = FALSE
        for i=0,15 do
          local c3d = Coord3D.new()
          c3d.Xpos = t.Pos.D3.Xpos +(G_RANDOM(7)*512 * randSign())
          c3d.Zpos = t.Pos.D3.Zpos +(G_RANDOM(7)*512 * randSign())
          createThing(T_EFFECT, M_EFFECT_EROSION, t.Owner, c3d, false, false)
        end
      end
    end
  end
end

function randSign()
	local sign = -1
	
	if (G_RANDOM(2) == 0) then
		sign = 1
	end
	
	return sign;
end

function tablelength(te)
  local count = 0
  for _ in pairs(te) do count = count + 1 end
  return count
end