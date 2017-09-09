-- sOS Applications Library

local app = {}

apps = {}

function app.newTask(dir, tag)
  
  -- Generating new 1000 - 9999 PID
  local pid = 0
  local good = true
  while true do
    pid = ('%d'):format(love.math.random(1000, 9999))
    good = true
    for k,v in ipairs(apps) do
      if v.pid == pid then good = false end
    end
    if good then break end
  end
  
  pen = #apps + 1
  
  -- Creating app in table apps.
  apps[pen] = {}
  apps[pen].pid = pid
  apps[pen].code = {}
  apps[pen].dir = dir
  apps[pen].tag = tag

  app.newEnvironment(dir, pen)
  
  -- Setting up default values.
  apps[pen].title = "Untitled App, PID: " .. pid
  apps[pen].mini = false
  
  -- Running load() function to setup app.
  appTable = apps[pen].code.load()
  apps[pen].title = appTable.title
  apps[pen].mini = appTable.mini
  
  gra.appCanvasReset(pen)
  
  print("New Task Created. "..pid.." - "..apps[pen].title)
  
end

function app.endTask(pen)
  table.remove(apps, pen)
end

function app.newEnvironment(dir, pen)
  
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
    api = { g = { set=api.g.set, get=api.g.get, text=api.g.text, box=api.g.box },
      i = {keyStat=api.i.keyStat}}
  }
  
  if (apps[pen].tag == "SYS") then
    sandbox_env.api.s = {appsTable = api.s.appsTable}
  end
  
  -- Load app in environment
  fnew = setfenv(assert(loadfile(dir, "bt")), sandbox_env)
  apps[pen].code = fnew()
  
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