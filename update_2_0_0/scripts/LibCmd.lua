import(Module_Commands)
import(Module_DataTypes)
import(Module_Defines)
import(Module_Objects)
import(Module_Map)

function cmd_gather_wood(tree,flag)
  local cmd = Commands.new()
  cmd.Flags = cmd.Flags | CMD_FLAG_WOOD_TREE
  if (flag) then
    cmd.Flags = cmd.Flags | CMD_FLAG_CONTINUE_CMD
  end
  cmd.CommandType = CMD_GET_WOOD
  cmd.u.TargetCoord = tree.Pos.D2
  return cmd
end

function cmd_build(shape)
  local cmd = Commands.new()
  cmd.CommandType = CMD_BUILD_BUILDING
  cmd.u.TMIdxs.TargetIdx:set(shape.ThingNum)
  cmd.u.TMIdxs.MapIdx = world_coord2d_to_map_idx(cmd.u.TMIdxs.TargetIdx:get().Pos.D2)
  return cmd
end