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
  [1] = {DATA = {1,0,84,156,1742,1739}},
  [2] = {DATA = {2,0,82,172,1747,1739}},
  [3] = {DATA = {3,0,66,160,1752,1739}},
  [4] = {DATA = {4,0,56,176,1757,1739}},
  [5] = {DATA = {5,0,48,176,1762,1741}},
  [6] = {DATA = {6,512,58,146,1743,1739}},
  [7] = {DATA = {7,512,46,146,1748,1739}},
  [8] = {DATA = {8,0,32,138,1753,1739}},
  [9] = {DATA = {9,0,18,186,1758,1739}},
  [10] = {DATA = {10,512,14,168,1763,1741}},
  [11] = {DATA = {11,512,74,124,1744,1741}},
  [12] = {DATA = {12,0,50,100,1749,1741}},
  [13] = {DATA = {13,0,28,114,1754,1741}},
  [14] = {DATA = {14,0,10,94,1759,1741}},
  [15] = {DATA = {15,0,44,118,1764,1739}},
  [16] = {DATA = {15,0,16,152,1745,1739}},
  [17] = {DATA = {15,512,238,162,1750,1739}},
  [18] = {DATA = {15,0,252,200,1754,1739}},
  [19] = {DATA = {15,512,236,194,1760,1739}},
  [20] = {DATA = {15,512,0,168,1765,1739}},
  [21] = {DATA = {15,512,6,130,1746,1739}},
  [22] = {DATA = {15,0,240,124,1751,1739}},
  [23] = {DATA = {15,512,218,168,1756,1739}},
  [24] = {DATA = {15,512,216,184,1761,1739}},
  [25] = {DATA = {15,512,198,178,1766,1739}}
}

for k,v in ipairs(levels) do
  local portal = IPortal.reg(v.DATA[1],v.DATA[2],v.DATA[3],v.DATA[4],v.DATA[5],v.DATA[6])
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