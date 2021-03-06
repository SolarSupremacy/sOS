local api = {}

-- Graphics
api.g = {}

function api.g.get(x, y)
  return (gra.get(x, y))
end

function api.g.set(x, y, char)
  gra.set(x, y, char)
  return (true)
end

function api.g.text(x, y, str)
  for i=1, utf8.len(str) do
    gra.set(x+i-1, y, string.sub(str, utf8.offset(str, i), utf8.offset(str, i+1)-1))
  end
  return (true)
end

function api.g.area(x, y, w, h, char)
  for i=1, w do
    for j=1, h do
      gra.set(x+i-1, y+j-1, char)
    end
  end
  return (true)
end

function api.g.box(x, y, w, h, adapt)
  if adapt == nil then adapt = false end
  if not adapt then
    
    gra.set(x, y, "╔")
    gra.set(x+w-1, y, "╗")
    gra.set(x, y+h-1, "╚")
    gra.set(x+w-1, y+h-1, "╝")
    
    for i=1, w-2 do
      gra.set(x+i, y, "═")
      gra.set(x+i, y+h-1, "═")
    end
    
    for i=1, h-2 do
      gra.set(x, y+i, "║")
      gra.set(x+w-1, y+i, "║")
    end
    
    for i=1, w-2 do
      for j=1, h-2 do
        gra.set(x+i, y+j, " ")
      end
    end
    
  else
    
    gra.set(x, y, gra.charCombine("╔", gra.get(x, y)))
    gra.set(x+w-1, y, gra.charCombine("╗", gra.get(x+w-1, y)))
    gra.set(x, y+h-1, gra.charCombine("╚", gra.get(x, y+h-1)))
    gra.set(x+w-1, y+h-1, gra.charCombine("╝", gra.get(x+w-1, y+h-1)))
    
    for i=1, w-2 do
      gra.set(x+i, y, gra.charCombine("═", gra.get(x+i, y)))
      gra.set(x+i, y+h-1, gra.charCombine("═", gra.get(x+i, y+h-1)))
    end
    
    for i=1, h-2 do
      gra.set(x, y+i, gra.charCombine("║", gra.get(x, y+i)))
      gra.set(x+w-1, y+i, gra.charCombine("║", gra.get(x+w-1, y+i)))
    end
    
    for i=1, w-2 do
      for j=1, h-2 do
        gra.set(x+i, y+j, gra.charCombine(" ", gra.get(x+i, y+j)))
      end
    end
    
  end
  
  return (true)
end

function api.g.bar(x, y, length, direction, style, percentage)
  chList = {}
  for i=0, length do
    chPer = percentage * length - i
    
    if style == "block" then
      if chPer >= 1 then
        chList[i] = "█"
      else
        chList[i] = " "
      end
    end
    
    if style == "fade" then
      if chPer >= 1 then
        chList[i] = "█"
      elseif chPer >= 0.75 then
        chList[i] = "▓"
      elseif chPer >= 0.50 then
        chList[i] = "▒"
      elseif chPer >= 0.25 then
        chList[i] = "░"
      else
        chList[i] = " "
      end
    end
    
    return (true)
  end
  
  for i=0, length do
    gra.set(x+i, y, chList[i])
  end
  
end

---[[
function api.g.color(color)
  gra.color(color)
end
--]]

-- Input
api.i = {}

function api.i.keyStat(key)
  return (love.keyboard.isDown(key))
end

-- System
api.s = {}

function api.s.appsTable()
  return (lgc.copyTable(apps))
end

return (api)
