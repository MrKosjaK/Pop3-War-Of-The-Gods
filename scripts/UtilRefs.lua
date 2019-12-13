import(Module_DataTypes)
import(Module_Globals)
import(Module_Players)

_gsi = gsi()
_sti = scenery_type_info()
_c = constants()

function GetTurn()
  return _gsi.Counts.GameTurn
end

function GetPlayerPeople(pn)
  return _gsi.Players[pn].NumPeople
end

function randSign()
  local a = -1
  if (G_RANDOM(2) == 0) then
    a = 1
  end
  return a
end

function tablelength(te)
  local count = 0
  for _ in pairs(te) do count = count + 1 end
  return count
end
