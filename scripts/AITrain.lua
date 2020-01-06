import(Module_Table)
import(Module_DataTypes)
import(Module_Objects)
import(Module_Defines)
import(Module_Game)

include("UtilRefs.lua")

train_bldgs = {}
allowed_models = {5,6,7,8}

ProcessGlobalTypeList(T_BUILDING, function(t)
  if (t.Type == T_BUILDING) then
    if (_gsi.Players[t.Owner].PlayerType == COMPUTER_PLAYER) then
      if DoesExist(allowed_models,t.Model) then
        table.insert(train_bldgs,t.ThingNum)
      end
    end
  end
  return true
end)

function OnCreateThing(t)
  if (t.Type == T_BUILDING) then
    if (_gsi.Players[t.Owner].PlayerType == COMPUTER_PLAYER) then
      if DoesExist(allowed_models,t.Model) then
        table.insert(train_bldgs,t.ThingNum)
      end
    end
  end
end

function OnTurn()
  if every2Pow(5) then
    for i,v in ipairs(train_bldgs) do
      local t = GetThing(v)
      if (t ~= nil) then
        if (t.Type == T_BUILDING and DoesExist(allowed_models,t.Model)) then
          if (t.u.Bldg.ShapeThingIdx:isNull()) then
            if (t.u.Bldg.TrainingManaCost > 0) then
              t.u.Bldg.TrainingManaStored = t.u.Bldg.TrainingManaStored + 500
            end
          end
        else
          table.remove(train_bldgs,i)
        end
      else
        table.remove(train_bldgs,i)
      end
    end
  end
end
