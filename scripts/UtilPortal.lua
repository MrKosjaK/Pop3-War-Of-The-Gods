import(Module_Table)
import(Module_Map)
import(Module_Defines)
import(Module_DataTypes)
import(Module_MapWho)
import(Module_Level)
import(Module_Objects)

IPortal = {}
IPortal.reg  = function(_level, _angle, _x, _z)
  local p = {}
  
  p.level = _level
  p.angle = _angle
  p.coord = MAP_XZ_2_WORLD_XYZ(_x, _z)
  p.activetransfer = false
  p.transferdelay = 0
  
  function p:get_level()
    return p.level
  end
  
  function p:initialize()
    local mark = createThing(T_EFFECT,M_EFFECT_FIRESTORM_SMOKE,TRIBE_HOSTBOT,p.coord,false,false)
    centre_coord3d_on_block(mark.Pos.D3)
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
  
  p:initialize()
  
  return p
end