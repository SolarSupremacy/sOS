local api = {}

-- Graphics
api.g = {}

function api.g.get(x, y)
  return (gra.appGet(state.currentPEN, x, y))
end

function api.g.set(x, y, char)
  gra.appSet(state.currentPEN, x, y, char)
  return (true)
end

function api.g.text(x, y, str)
  for i=1, utf8.len(str) do
    gra.appSet(pen, x+i-1, y, string.sub(str, utf8.offset(str, i), utf8.offset(str, i+1)-1))
  end
  return (true)
end

function api.g.area(x, y, w, h, char)
  for i=1, w do
    for j=1, h do
      gra.appSet(state.currentPEN, x+w-1, y+h-1, char)
    end
  end
  return (true)
end

function api.g.box(x, y, w, h, adapt)
  if adapt == nil then adapt = false end
  if adapt then
    
    gra.appSet(pen, x, y, "╔")
    gra.appSet(pen, x+w-1, y, "╗")
    gra.appSet(pen, x, y+h-1, "╚")
    gra.appSet(pen, x+w-1, y+h-1, "╝")
    
    for i=1, w-2 do
      gra.appSet(pen, x+i, y, "═")
      gra.appSet(pen, x+i, y+h-1, "═")
    end
    
    for i=1, h-2 do
      gra.appSet(pen, x, y+i, "║")
      gra.appSet(pen, x+w-1, y+i, "║")
    end
    
    for i=1, w-2 do
      for j=1, h-2 do
        gra.appSet(pen, x+i, y+j, " ")
      end
    end
    
  else
    
    gra.appSeto(pen, x, y, gra.charCombine("╔", gra.appGet(state.currentPEN, x, y)))
    gra.appSeto(pen, x+w-1, y, gra.charCombine("╗", gra.appGet(state.currentPEN, x, y)))
    gra.appSeto(pen, x, y+h-1, gra.charCombine("╚", gra.appGet(state.currentPEN, x, y)))
    gra.appSeto(pen, x+w-1, y+h-1, gra.charCombine("╝", gra.appGet(state.currentPEN, x, y)))
    
    for i=1, w-2 do
      gra.appSeto(pen, x+i, y, gra.charCombine("═", gra.appGet(state.currentPEN, x, y)))
      gra.appSeto(pen, x+i, y+h-1, gra.charCombine("═", gra.appGet(state.currentPEN, x, y)))
    end
    
    for i=1, h-2 do
      gra.appSeto(pen, x, y+i, gra.charCombine("║", gra.appGet(state.currentPEN, x, y)))
      gra.appSeto(pen, x+w-1, y+i, gra.charCombine("║", gra.appGet(state.currentPEN, x, y)))
    end
    
    for i=1, w-2 do
      for j=1, h-2 do
        gra.appSeto(pen, x+i, y+j, gra.charCombine(" ", gra.appGet(state.currentPEN, x, y)))
      end
    end
    
  end
  
  return (true)
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