import(Module_Players)
import(Module_Defines)
import(Module_PopScript)
import(Module_Game)
import(Module_Objects)
import(Module_Globals)
import(Module_Map)

include("UtilPThings.lua")

wilds = {}
spell_delay = 0
index = 1
shamansNums = {0,1}
lights_used = 0
numthings = 16

for i = 2,3 do
  for j = 0,1 do
    set_players_allied(i-2,j)
  end
end

function OnTurn()
  if (EVERY_2POW_TURNS(9)) then
    ProcessGlobalTypeList(T_BUILDING, function(t)
      if (t.Model < 4 and t.Owner > 1) then
        if (t.u.Bldg.SproggingCount < 2000) then
          t.u.Bldg.SproggingCount = t.u.Bldg.SproggingCount + 875
        end
      end
      
      if (t.Model < 3 and t.Owner > 1) then
        if (t.u.Bldg.UpgradeCount < 500) then
          t.u.Bldg.UpgradeCount = t.u.Bldg.UpgradeCount + 155
        end
      end
      
      return true
    end)
    
    if (lights_used > 0) then
      lights_used = lights_used-1
    end
  end
  
  if (EVERY_2POW_TURNS(5)) then
    local shaman = getShaman(TRIBE_GREEN)
            
    local enemyshaman = G_RANDOM(tablelength(shamansNums))+1
    local est = getShaman(shamansNums[enemyshaman])
    
    if (shaman ~= nil and est ~= nil and shaman.Owner ~= est.Owner) then
      if (get_world_dist_xyz(shaman.Pos.D3, est.Pos.D3) < 6144 + shaman.Pos.D3.Ypos*3) then
        if (spell_delay == 0 and is_thing_on_ground(shaman) == 1 and lights_used < 4) then
          createThing(T_SPELL, M_SPELL_LIGHTNING_BOLT, shaman.Owner, est.Pos.D3, false, false)
          lights_used = lights_used + 1
          spell_delay = 24
        end
      end
    end
  end
  
  if (EVERY_2POW_TURNS(3)) then
    if (_gsi.Players[TRIBE_GREEN].NumPeople < 70 and
        _gsi.Counts.GameTurn < (12*60)*2 and
        _gsi.Counts.GameTurn > (12*10)) then
      process(numthings)
    end
  end
  
  if (spell_delay > 0) then
    spell_delay = spell_delay-1
  end
end

ProcessGlobalTypeList(T_PERSON, function(t)
  if (t.Model == M_PERSON_WILD) then 
    table.insert(wilds, t)
  end 
  return true
end)

function OnCreateThing(t)
  if (t.Type == T_PERSON and t.Model == M_PERSON_WILD) then
    table.insert(wilds, t)
  end
end

function process(n)
  for i = 0,n do
    if (index < tablelength(wilds)) then
      local t = GetThing(wilds[index].ThingNum)
      if (t ~= nil and t.Type == T_PERSON and t.Model == M_PERSON_WILD) then
        local s = getShaman(TRIBE_GREEN)
        if (s ~= nil) then
          if(get_world_dist_xyz(t.Pos.D3, s.Pos.D3) < (8192 + s.Pos.D3.Ypos*3) and spell_delay == 0) then
            createThing(T_SPELL, M_SPELL_CONVERT_WILD, s.Owner, t.Pos.D3, false, false)
            spell_delay = 18
          end
        end
      else
        table.remove(wilds, index)
      end
      index = index+1
    else
      index = 1
    end
  end
end

function tablelength(te)
  local count = 0
  for _ in pairs(te) do count = count + 1 end
  return count
end