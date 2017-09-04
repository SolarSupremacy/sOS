local api = {}

api.g = {}

function api.g.set(x, y, char)
  gra.appSet(currentPID, x, y, char)
  return (true)
end

function api.g.get(x, y)
  return (gra.appGet(currentPID, x, y))
end

function api.g.text(x, y, str)
  gra.appText(currentPID, x, y, str)
  return (true)
end

function api.g.box(x, y, w, h, adapt)
  if adapt == nil then adapt = false end
  if adapt then
    gra.appMakeBoxAdapt(currentPID, x, y, w, h)
  else
    gra.appMakeBox(currentPID, x, y, w, h)
  end
  return (true)
end

return (api)
  