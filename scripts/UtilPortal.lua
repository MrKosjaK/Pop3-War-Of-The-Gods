import(Module_Table)
import(Module_Map)
import(Module_Defines)
import(Module_DataTypes)
import(Module_MapWho)
import(Module_Level)
import(Module_Objects)
import(Module_Draw)

IPortal = {}
IPortal.reg  = function(_level, _angle, _x, _z, _spr, _diff)
  local p = {}
  
  p.level = _level
  p.angle = _angle
  p.holo_spr = _spr
  p.holo_diff = _diff
  p.coord = MAP_XZ_2_WORLD_XYZ(_x, _z)
  p.activetransfer = false
  p.transferdelay = 0
  
  function p:init_portal()
    local portal = createThing(T_SCENERY,M_SCENERY_TOP_LEVEL_SCENERY,TRIBE_HOSTBOT,p.coord,false,false)
    portal.AngleXZ = p.angle
    portal.DrawInfo.DrawNum = 160
    portal.DrawInfo.Flags = portal.DrawInfo.Flags | (1<<7)
    ensure_thing_on_ground(portal)
    centre_coord3d_on_block(portal.Pos.D3)
  end
  
  function p:init_holo()
    local holo_level = createThing(T_GENERAL,M_GENERAL_MAPWHO_THING,TRIBE_HOSTBOT,p.coord,false,false)
    local holo_difficulty = createThing(T_GENERAL,M_GENERAL_MAPWHO_THING,TRIBE_HOSTBOT,p.coord,false,false)
    centre_coord3d_on_block(holo_level.Pos.D3)
    centre_coord3d_on_block(holo_difficulty.Pos.D3)
    holo_level.Pos.D3.Ypos = holo_level.Pos.D3.Ypos + 512 + 128
    holo_level.DrawInfo.DrawNum = p.holo_spr
    holo_level.DrawInfo.Alpha = -16
    holo_difficulty.Pos.D3.Ypos = holo_difficulty.Pos.D3.Ypos + 512 + 16
    holo_difficulty.DrawInfo.DrawNum = p.holo_diff
    holo_difficulty.DrawInfo.Alpha = -16
  end
  
  function p:process()
    if not (p.activetransfer) then
      local shamans_present = 0
      SearchMapCells(SQUARE, 0, 0, 1, world_coord3d_to_map_idx(p.coord), function(me)
        me.MapWhoList:processList(function (t)
          if (t.Type == T_PERSON) then
            if (t.Model == M_PERSON_MEDICINE_MAN) then
              if (t.Owner == TRIBE_BLUE or t.Owner == TRIBE_RED) then
                shamans_present = shamans_present+1
              end
            end
          end
          return true
        end)
        return true
      end)
      
      if (shamans_present == 2 and not p.activetransfer) then
        p.activetransfer = true
        p.transferdelay = 36
      end
    else
      if (p.transferdelay > 0) then
        p.transferdelay = p.transferdelay-1
      else
        change_level(p.level)
        level_load_in_level_details_and_computer_player_info(p.level)
        current_level = p.level
        in_hub = false
        upd_level = true
        p.activetransfer = false
      end
    end
  end
  
  p:init_portal()
  p:init_holo()
  
  return p
end