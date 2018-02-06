local app = {}

-- sOS Applications Library

function app.newTask(dir, tag)
  
  -- Generating new 1000 - 9999 PID
  local pid
  local good
  while true do
    pid = ('%d'):format(love.math.random(1000, 9999))
    good = true
    for v,_ in pairs(apps) do
      if v == pid then good = false end
    end
    if good then break end
  end
  
  -- Creating app in table apps.
  apps[pid] = {}
  apps[pid].code = {}
  apps[pid].dir = dir
  apps[pid].tag = tag
  apps[pid].err = ""

  app.newEnvironment(dir, pid)
  
  -- Running load() function to setup app.
  local appTable = apps[pid].code.load()
  apps[pid].title = appTable.title or "Untitled App, PID: " .. pid
  apps[pid].mini = appTable.mini or false
  apps[pid].max = appTable.max or 1
  
  --gra.appCanvasReset(pid)
  
  print("New Task Created. "..pid.." - "..apps[pid].title)
  
  table.insert(appList, pid)
  
  local similar = 0
  for _,v in pairs(apps) do
    if (v.title == apps[pid].title) then similar = similar + 1 end
  end
  if similar > apps[pid].max and apps[pid].max ~= -1 then app.endTask(pid) end
  
end

function app.endTask(pid)
  apps[pid] = nil
  for k,v in pairs(appList) do
    if v == pid then
      table.remove(appList, k)
      break
    end
  end
  
end

function app.newEnvironment(dir, pid)
  
  -- Setup Sandbox Environment
  local sandbox_env = {
    ipairs = ipairs,
    next = next,
    pairs = pairs,
    print = print,
    pcall = pcall,
    tonumber = tonumber,
    tostring = tostring,
    type = type,
    unpack = unpack,
    --[[coroutine = { create = coroutine.create, resume = coroutine.resume,
        running = coroutine.running, status = coroutine.status,
        wrap = coroutine.wrap },]]
    string = { byte = string.byte, char = string.char, find = string.find,
        format = string.format, gmatch = string.gmatch, gsub = string.gsub,
        len = string.len, lower = string.lower, match = string.match,
        rep = string.rep, reverse = string.reverse, sub = string.sub,
        upper = string.upper },
    table = { insert = table.insert, maxn = table.maxn, remove = table.remove,
        sort = table.sort },
    math = { abs = math.abs, acos = math.acos, asin = math.asin,
        atan = math.atan, atan2 = math.atan2, ceil = math.ceil, cos = math.cos,
        cosh = math.cosh, deg = math.deg, exp = math.exp, floor = math.floor,
        fmod = math.fmod, frexp = math.frexp, huge = math.huge,
        ldexp = math.ldexp, log = math.log, log10 = math.log10, max = math.max,
        min = math.min, modf = math.modf, pi = math.pi, pow = math.pow,
        rad = math.rad, random = math.random, sin = math.sin, sinh = math.sinh,
        sqrt = math.sqrt, tan = math.tan, tanh = math.tanh },
    os = { clock = os.clock, difftime = os.difftime, time = os.time },
    api = { g = { set=api.g.set, get=api.g.get, text=api.g.text, box=api.g.box, bar=api.g.bar },
      i = {keyStat=api.i.keyStat}},
    utf8 = { offset = utf8.offset },
    lgc = { usub = lgc.usub }
  }
  
  if (apps[pid].tag == "SYS") then
    sandbox_env.api.s = {appsTable = api.s.appsTable}
  end
  
  -- Load app in environment
  local fnew = setfenv(assert(loadfile(dir, "bt")), sandbox_env)
  apps[pid].code = fnew()
  
  --[[
  co = coroutine.create(fenv)
  
  print(coroutine.status(co))
  
  coroutine.resume(co)
  print(coroutine.status(co))
  
  coroutine.resume(co)
  print(coroutine.status(co))
  
  
  coroutine.resume(co)
  print(coroutine.status(co))
  ]]
  
end

return (app)