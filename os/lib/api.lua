local api = {}

currentpen = 0

-- Graphics
api.g = {}

function api.g.set(x, y, char)
  gra.appSet(currentpen, x, y, char)
  return (true)
end

function api.g.get(x, y)
  return (gra.appGet(currentpen, x, y))
end

function api.g.text(x, y, str)
  gra.appText(currentpen, x, y, str)
  return (true)
end

function api.g.box(x, y, w, h, adapt)
  if adapt == nil then adapt = false end
  if adapt then
    gra.appMakeBoxAdapt(currentpen, x, y, w, h)
  else
    gra.appMakeBox(currentpen, x, y, w, h)
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
  