import(Module_Objects)
import(Module_DataTypes)
import(Module_Defines)
import(Module_Game)
import(Module_Draw)
import(Module_Globals)
import(Module_Map)

include("UtilRefs.lua")

_sti[4].DfltResourceValue = 140
_sti[4].DormantTime = 3000
_sti[4].ToolTipStrId = 611
_sti[4].ShadowDepth = 6

bushes_spread_cells = 2
bushes_spread_cells_rand = 5
bushes_groups = 32
bushes_in_group = 3

function generate_bush(coord)
  coord.Xpos = coord.Xpos + ((G_RANDOM(bushes_spread_cells_rand)+bushes_spread_cells * 512) * randSign())
  coord.Zpos = coord.Zpos + ((G_RANDOM(bushes_spread_cells_rand)+bushes_spread_cells * 512) * randSign())
  CREATE_THING_WITH_PARAMS4(T_SCENERY, M_SCENERY_DORMANT_TREE, TRIBE_HOSTBOT, coord, T_SCENERY, 4, 0, 0);
end

for i = 0,bushes_groups do
  local tries = 128
  local crd = Coord2D.new()
  local c3d = Coord3D.new()
  while (tries > 0) do
    tries=tries-1
    crd.Xpos = G_RANDOM(65536)
    crd.Zpos = G_RANDOM(65536)
    if (is_map_point_land(crd) == 1) then
      break
    end
  end

  coord2D_to_coord3D(crd, c3d)

  for j = 0,G_RANDOM(bushes_in_group)+2 do
    generate_bush(c3d)
  end
end

function OnTurn()
  if (EVERY_2POW_TURNS(6)) then
    ProcessGlobalSpecialList(TRIBE_NEUTRAL, WOODLIST, function(t)
      if (t.Model == 4) then
        if (t.DrawInfo.DrawNum == 159) then
          if (t.u.Scenery.ResourceRemaining < 240 and t.u.Scenery.ResourceRemaining > 138) then
            t.u.Scenery.ResourceRemaining = t.u.Scenery.ResourceRemaining+10
            t.u.ObjectInfo.Scale = t.u.ObjectInfo.Scale+1
          end
        end
      end

      return true
    end)
  end
end

function OnCreateThing(t)
  if (t.Type == T_SCENERY) then
    if (t.Model == 4) then
      t.DrawInfo.DrawNum = 158+G_RANDOM(2)
      t.AngleXZ = G_RANDOM(2048)
      if (t.DrawInfo.DrawNum == 158) then
        t.u.ObjectInfo.Scale = 70
      end
    end
  end
end
