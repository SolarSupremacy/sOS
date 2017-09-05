-- sOS Applications Library

local app = {}

apps = {}

appManager = {}

function app.newTask(dir, tag)
  
  -- Getting lowest unused PID.
  local pid
  local running
  local good
  running = true
  pid = 0
  while running do
    pid = pid + 1
    good = true
    for k,v in pairs(apps) do
      if (k==pid) then good = false end
    end
    if good then running = false end
  end
  
  -- Creating app in table apps.
  apps[pid] = {}
  apps[pid].code = {}
  apps[pid].dir = dir
  apps[pid].tag = tag
  app.newEnvironment(dir, pid)
  
  -- Setting up default values.
  apps[pid].width = 30
  apps[pid].height = 5
  apps[pid].title = "Untitled App, PID: " .. pid
  apps[pid].mini = false
  
  -- Running load() function to setup app.
  appTable = apps[pid].code.load()
  apps[pid].width = appTable.width
  apps[pid].height = appTable.height
  apps[pid].title = appTable.title
  apps[pid].mini = appTable.mini
  
  -- Centering window based on size
  apps[pid].x = math.floor((textGrid.width - apps[pid].width) / 2)
  apps[pid].y = math.floor((textGrid.height - apps[pid].height) / 2)
  
  gra.appCanvasReset(pid)
  
  table.insert(appManager, 1, pid)
  
  print("New Task Created. "..pid.." - "..apps[pid].title)
  
end

function app.newEnvironment(dir, pid)
  
  -- Setup Sandbox Environment
  sandbox_env = {
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
  
  if (apps[pid].tag == "SYS") then
    print("run")
    sandbox_env.api.s = {appsTable = api.s.appsTable}
  end
  
  -- Load app in environment
  fnew = setfenv(assert(loadfile(dir, "bt")), sandbox_env)
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