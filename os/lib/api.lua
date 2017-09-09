local api = {}

-- Graphics
api.g = {}

function api.g.set(x, y, char)
  gra.appSet(state.currentPEN, x, y, char)
  return (true)
end

function api.g.get(x, y)
  return (gra.appGet(state.currentPEN, x, y))
end

function api.g.text(x, y, str)
  gra.appText(state.currentPEN, x, y, str)
  return (true)
end

function api.g.box(x, y, w, h, adapt)
  if adapt == nil then adapt = false end
  if adapt then
    gra.appMakeBoxAdapt(state.currentPEN, x, y, w, h)
  else
    gra.appMakeBox(state.currentPEN, x, y, w, h)
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
