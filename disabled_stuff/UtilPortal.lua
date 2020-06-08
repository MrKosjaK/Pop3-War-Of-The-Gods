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
  local data = {}

  data.pLevel = _level
  data.pAngle = _angle
  data.pHoloSpr = _spr
  data.pHoloDiff = _diff
  data.pCoord3D = MAP_XZ_2_WORLD_XYZ(_x, _z)
  data.pWarpActive = false
  data.pWarpCooldown = 0

  function data:InitPortal()
    local portal = createThing(T_SCENERY,M_SCENERY_TOP_LEVEL_SCENERY,TRIBE_HOSTBOT,data.pCoord3D,false,false)
    portal.AngleXZ = data.pAngle
    portal.DrawInfo.DrawNum = 160
    portal.DrawInfo.Flags = portal.DrawInfo.Flags | (1<<7)
    ensure_thing_on_ground(portal)
    centre_coord3d_on_block(portal.Pos.D3)
  end

  function data:InitHologram()
    local hLevel = createThing(T_GENERAL,M_GENERAL_MAPWHO_THING,TRIBE_HOSTBOT,data.pCoord3D,false,false)
    local hDiff = createThing(T_GENERAL,M_GENERAL_MAPWHO_THING,TRIBE_HOSTBOT,data.pCoord3D,false,false)
    centre_coord3d_on_block(hLevel.Pos.D3)
    centre_coord3d_on_block(hDiff.Pos.D3)
    hLevel.Pos.D3.Ypos = hLevel.Pos.D3.Ypos + 512 + 128
    hLevel.DrawInfo.DrawNum = data.pHoloSpr
    hLevel.DrawInfo.Alpha = -16
    hDiff.Pos.D3.Ypos = hDiff.Pos.D3.Ypos + 512 + 16
    hDiff.DrawInfo.DrawNum = data.pHoloDiff
    hDiff.DrawInfo.Alpha = -16
  end

  function data:ProcessThis()
    if not (data.pWarpActive) then
      local shamans_present = 0
      SearchMapCells(SQUARE, 0, 0, 1, world_coord3d_to_map_idx(data.pCoord3D), function(me)
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

      if (shamans_present == 2 and not data.pWarpActive) then
        data.pWarpActive = true
        data.pWarpCooldown = 36
      end
    else
      if (data.pWarpCooldown > 0) then
        data.pWarpCooldown = data.pWarpCooldown-1
      else
        change_level(data.pLevel)
        level_load_in_level_details_and_computer_player_info(data.pLevel)
        current_level = data.pLevel
        in_hub = false
        upd_level = true
        data.pWarpActive = false
      end
    end
  end

  data:InitPortal()
  data:InitHologram()

  return data
end
