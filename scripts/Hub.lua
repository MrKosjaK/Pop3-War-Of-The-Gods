import(Module_Defines)
import(Module_PopScript)
import(Module_DataTypes)
import(Module_Globals)
import(Module_Game)

include("UtilFlags.lua")
include("UtilPortal.lua")

current_level = 0
in_hub = true
upd_level = false

portals = {}
levels = {
  [1] = {DATA = {1,0,84,156}},
  [2] = {DATA = {2,0,82,172}},
  [3] = {DATA = {3,0,66,160}},
  [4] = {DATA = {4,0,56,176}},
  [5] = {DATA = {5,0,48,176}},
  [6] = {DATA = {6,512,58,146}},
  [7] = {DATA = {7,512,46,146}},
  [8] = {DATA = {8,0,32,138}},
  [9] = {DATA = {9,0,18,186}},
  [10] = {DATA = {10,512,14,168}},
  [11] = {DATA = {11,512,74,124}},
  [12] = {DATA = {12,0,50,100}},
  [13] = {DATA = {13,0,28,114}},
  [14] = {DATA = {14,0,10,94}},
  [15] = {DATA = {15,0,44,118}},
  [16] = {DATA = {15,0,16,152}},
  [17] = {DATA = {15,512,238,162}},
  [18] = {DATA = {15,0,252,200}},
  [19] = {DATA = {15,512,236,194}},
  [20] = {DATA = {15,512,0,168}},
  [21] = {DATA = {15,512,6,130}},
  [22] = {DATA = {15,0,240,124}},
  [23] = {DATA = {15,512,218,168}},
  [24] = {DATA = {15,512,216,184}},
  [25] = {DATA = {15,512,198,178}}
}

for k,v in ipairs(levels) do
  local portal = IPortal.reg(v.DATA[1],v.DATA[2],v.DATA[3],v.DATA[4])
  table.insert(portals, portal)
end

_gnsi = gnsi()
_gnsi.GameParams.Flags2 = enable_flag(_gnsi.GameParams.Flags2,GPF2_GAME_NO_WIN)

for i=0,1 do
  SET_NO_REINC(i)
end

function OnTurn()
  if (in_hub) then
    for i in ipairs(portals) do
      portals[i]:process()
    end
  elseif not (in_hub) then
    if (upd_level) then
      log_msg(TRIBE_NEUTRAL, "[green] Entered " .. current_level .. " level!")
      _gnsi.GameParams.Flags2 = disable_flag(_gnsi.GameParams.Flags2,GPF2_GAME_NO_WIN)
      upd_level = false
    end
  end
end