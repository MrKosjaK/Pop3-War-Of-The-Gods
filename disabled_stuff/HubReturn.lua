import(Module_Objects)
import(Module_DataTypes)
import(Module_Players)
import(Module_Globals)
import(Module_Map)
import(Module_Defines)
import(Module_System)

include("UtilRefs.lua")

local IsHumanAlive = function()
  local human_exist = false
  ProcessGlobalTypeList(T_PERSON,function(t)
    if (GetPlayerPeople(t.Owner) ~= 0) then
      if (_gsi.Players[t.Owner].PlayerType == HUMAN_PLAYER) then
        human_exist = true
        return false
      end
    end
    return true
  end)

  return human_exist
end

local IsComputerAlive = function()
  local computer_exist = false
  ProcessGlobalTypeList(T_PERSON,function(t)
    if (GetPlayerPeople(t.Owner) ~= 0) then
      if (_gsi.Players[t.Owner].PlayerType == COMPUTER_PLAYER) then
        computer_exist = true
        return false
      end
    end
    return true
  end)

  return computer_exist
end

function OnTurn()
  if every2Pow(5) then
    if not (IsHumanAlive()) then
      log("hi")
      exit()
    elseif not (IsComputerAlive()) then
      log("hi2")
      exit()
    end
  end
end
