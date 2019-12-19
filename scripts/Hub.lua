import(Module_Defines)
import(Module_PopScript)
import(Module_DataTypes)
import(Module_Globals)
import(Module_Game)

include("UtilFlags.lua")
include("UtilPortal.lua")
include("SprDefs.lua")

current_level = 0
in_hub = true
upd_level = false

portals = {}
--@[0] = {DATA = {LEVEL_NUM,ANGLE,X,Z,HOLO_LEVELNUM,HOLO_LEVELDIFF}}
levels = {
  [1] = {DATA = {1,0,84,156,1742,diff_easy}},
  [2] = {DATA = {2,0,82,172,1747,diff_easy}},
  [3] = {DATA = {3,0,66,160,1752,diff_easy}},
  [4] = {DATA = {4,0,56,176,1757,diff_easy}},
  [5] = {DATA = {5,0,48,176,1762,diff_medium}},
  [6] = {DATA = {6,512,58,146,1743,diff_easy}},
  [7] = {DATA = {7,512,46,146,1748,diff_easy}},
  [8] = {DATA = {8,0,32,138,1753,diff_easy}},
  [9] = {DATA = {9,0,18,186,1758,diff_easy}},
  [10] = {DATA = {10,512,14,168,1763,diff_medium}},
  [11] = {DATA = {11,512,74,124,1744,diff_medium}},
  [12] = {DATA = {12,0,50,100,1749,diff_medium}},
  [13] = {DATA = {13,0,28,114,1754,diff_medium}},
  [14] = {DATA = {14,0,10,94,1759,diff_medium}},
  [15] = {DATA = {15,0,44,118,1764,diff_medium}},
  [16] = {DATA = {16,0,16,152,1745,diff_medium}},
  [17] = {DATA = {17,512,238,162,1750,diff_hard}},
  [18] = {DATA = {18,0,252,200,1754,diff_medium}},
  [19] = {DATA = {19,512,236,194,1760,diff_medium}},
  [20] = {DATA = {20,512,0,168,1765,diff_hard}},
  [21] = {DATA = {21,512,6,130,1746,diff_hard}},
  [22] = {DATA = {22,0,240,124,1751,diff_easy}},
  [23] = {DATA = {23,512,218,168,1756,diff_medium}},
  [24] = {DATA = {24,512,216,184,1761,diff_medium}},
  [25] = {DATA = {25,512,198,178,1766,diff_hard}}
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
      portals[i]:ProcessThis()
    end
  elseif not (in_hub) then
    if (upd_level) then
      log_msg(TRIBE_NEUTRAL, "[green] Entering " .. current_level .. " level!")
      _gnsi.GameParams.Flags2 = disable_flag(_gnsi.GameParams.Flags2,GPF2_GAME_NO_WIN)
      upd_level = false
    end
  end
end
