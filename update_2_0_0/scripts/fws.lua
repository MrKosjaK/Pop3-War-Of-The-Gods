import(Module_System)
import(Module_Defines)
import(Module_Objects)
import(Module_Game)
import(Module_Globals)
import(Module_DataTypes)
import(Module_Helpers)
import(Module_Draw)

AlphaIndex = {4,0,5,3,12,13,14,1}

function OnCreateThing(t)
  if (t.Type == T_SHOT) then
    if (t.Model == M_SHOT_SUPER_WARRIOR) then
      t.DrawInfo.Alpha = AlphaIndex[t.Owner+1]
      t.DrawInfo.DrawNum = 1731
    end
  end
end