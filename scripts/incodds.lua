import(Module_Players)
import(Module_Defines)
import(Module_PopScript)
import(Module_Game)
import(Module_Objects)
import(Module_Globals)
import(Module_Map)

include("UtilPThings.lua")
include("UtilRefs.lua")

wilds = {}
spell_delay = {0,0}
index = 1
availableNums = {2,3}
shamansNums = {0,1,2,3}
lights_used = {0,0}
numthings = 16

for i = 2,3 do
  for j = 0,1 do
    set_players_allied(i-2,j)
  end
end

function OnTurn()
  if (every2Pow(9)) then
    ProcessGlobalTypeList(T_BUILDING, function(t)
      if (t.Model < 4 and t.Owner > 1) then
        if (t.u.Bldg.SproggingCount < 2000) then
          t.u.Bldg.SproggingCount = t.u.Bldg.SproggingCount + 875
        end
      end

      return true
    end)

    for i,v in ipairs(lights_used) do
      if (v > 0) then
        lights_used[i] = v-1
      end
    end
  end

  if (every2Pow(5)) then
    local idx = G_RANDOM(tablelength(availableNums))+1
    local shaman = getShaman(availableNums[idx])

    local enemyshaman = G_RANDOM(tablelength(shamansNums))+1
    local est = getShaman(shamansNums[enemyshaman])

    if (shaman ~= nil and est ~= nil and shaman.Owner ~= est.Owner) then
      if (get_world_dist_xyz(shaman.Pos.D3, est.Pos.D3) < 6144 + shaman.Pos.D3.Ypos*3) then
        if (spell_delay[idx] == 0 and is_thing_on_ground(shaman) == 1 and lights_used[idx] < 4) then
          createThing(T_SPELL, M_SPELL_LIGHTNING_BOLT, shaman.Owner, est.Pos.D3, false, false)
          lights_used[idx] = lights_used[idx] + 1
          spell_delay[idx] = 24
        end
      end
    end
  end

  if (every2Pow(3)) then
    if (_gsi.Players[TRIBE_YELLOW].NumPeople +
        _gsi.Players[TRIBE_GREEN].NumPeople < 140 and
        GetTurn() < (12*60)*2 and
        GetTurn() > (12*10)) then
      process(numthings)
    end
  end

  for i,v in ipairs(spell_delay) do
    if (v > 0) then
      spell_delay[i] = v-1
    end
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
        local idx = G_RANDOM(tablelength(availableNums))+1
        local s = getShaman(availableNums[idx])
        if (s ~= nil) then
          if(get_world_dist_xyz(t.Pos.D3, s.Pos.D3) < (8192 + s.Pos.D3.Ypos*3) and spell_delay[idx] == 0) then
            createThing(T_SPELL, M_SPELL_CONVERT_WILD, s.Owner, t.Pos.D3, false, false)
            spell_delay[idx] = 22
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
