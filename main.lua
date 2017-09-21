--[[ Solar Operating System

      ╔═════╦═════╗
      ║     ║     ║
      ║  ║  ║  ═══╣
╔═════╣  ║  ║     ║
║  ═══╣  ║  ╠═══  ║
╠═══  ║     ║     ║
╚═════╩═════╩═════╝
Version: 0.0

╔────────────────╗
│ ▄▄ █▄▀██▄▀█ ▄▀ │
│  ▄▄█ ▀▄▄ █▄█▄▄ │
│ ▄█  ▄█ ▀▄▀▄▄▄▀ │
│ █▄▄▀ ▄▄▀ █▄█▀▄ │
╚────────────────╝
]]

-- local core = require("sos.core")

require 'os.globals'  -- load globals

local gra, app, love, crypto = gra, app, love, crypto

function love.run()
  
	if love.math then
		love.math.setRandomSeed(os.time())
	end
  
	if love.load then love.load(arg) end
  
	if love.timer then love.timer.step() end
  
	local dt = 0
  
	while true do
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end
    
		if love.timer then
			love.timer.step()
			dt = love.timer.getDelta()
		end
		if love.update then love.update(dt) end
 
		if love.graphics and love.graphics.isActive() then
			love.graphics.clear(love.graphics.getBackgroundColor())
			love.graphics.origin()
			if love.draw then love.draw() end
			love.graphics.present()
		end
 
		-- if love.timer then love.timer.sleep(0.0001) end
	end
 
end

function love.load()
  
  -- Loading Files
  local mainFont = love.graphics.newFont("os/dat/cour.ttf")
  
  systemApps = love.filesystem.getDirectoryItems("os/sysapps")
  userApps = love.filesystem.getDirectoryItems("programs")
  
  -- Graphics
  love.graphics.setBackgroundColor(0, 0, 0)
  --love.window.setMode(800, 600)
  love.window.setFullscreen(true)
  
  -- Processing
  ticks = 0
  
  love.keyboard.setKeyRepeat(true)
  love.graphics.setFont(mainFont)
  local fontWidth = mainFont:getWidth(" ") -- 7
  local fontHeight = mainFont:getHeight(" ") -- 14
  
  math.randomseed(os.time())
  
  -- populate global grid object
  grid.width = math.floor(love.graphics.getWidth() / fontWidth)
  grid.height = math.floor(love.graphics.getHeight() / fontHeight)
  grid.widthbuffer = (love.graphics.getWidth() - grid.width * fontWidth) / 2
  grid.heightbuffer = (love.graphics.getHeight() - grid.height * fontHeight) / 2
  grid.fontwidth = fontWidth
  grid.fontheight = fontHeight
  
  -- Load Apps
  --[[
  for k,v in ipairs(systemApps) do
    app.newTask(love.filesystem.getSource( ).. "/os/sysapps/"..v, "SYS")
  end
  for k,v in ipairs(userApps) do
    app.newTask(love.filesystem.getSource( ).. "/programs/"..v, "APP")
  end
  --]]
  
end

function love.update(dt)
  -- Tick Counter
  ticks = ticks + 1
  
  -- OS Controls
  
  --[[ Window Moving
  if love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl") then
    if ticks % 2 == 0 then
      local pen = appManager[1]
      if love.keyboard.isDown("up") then
        apps[pen].y = apps[pen].y - 1
      end
      if love.keyboard.isDown("down") then
        apps[pen].y = apps[pen].y + 1
      end
      if love.keyboard.isDown("left") then
        apps[pen].x = apps[pen].x - 1
      end
      if love.keyboard.isDown("right") then
        apps[pen].x = apps[pen].x + 1
      end
    end
  end
  --]]
  
  -- Process processor for processing processes
  for pid,_ in pairs(apps) do
    -- ID for graphics functions to handle
    state.pid = pid
    
    -- Run the app
    local status, err = pcall(apps[pid].code.tick)
    
    if status then
      apps[pid].code.tick()
    else
      apps[pid].err = err
    end
    
    
    
    
  end
  
  
end

function love.draw()
  
  state.pid = 0
  
  -- Reset Screen
  canvas = {}
  for i=1, grid.height do
    canvas[i] = {}
    for j=1, grid.width do
      canvas[i][j] = " "
    end
  end
  
  -- Reset Apps
  --[[
  for pen,_ in pairs(apps) do
    gra.appCanvasReset(pen)
  end
  --]]
  
  -- Draw Apps
  if state.active ~= 0 then
    local pid = appList[state.active]
    gra.appCanvasReset(pid)

    state.pid = pid
    
    local status, err = pcall(apps[pid].code.draw, grid.width-66, grid.height)
    
    state.pid = 0
    
    if status then
      --apps[pen].code.draw(grid.width-66, grid.height)
    else
      apps[pid].err = err
    end
    
    if apps[pid].err ~= "" then
      api.g.area(1, 1, string.len(apps[pid].err) + 6, 6, "!")
      api.g.box(2, 2, string.len(apps[pid].err) + 4, 4, false)
      api.g.text(4, 3, apps[pid].err)
      api.g.text(4, 4, "'\\' to close error.")
    end
    
    --[[
    for i=1, grid.height do
      for j=1, grid.width - 66 do
        gra.set(j+33, i, gra.appGet(pid, j, i))
      end
    end
    --]]
  end
  
  -- Draw System Info
  --gra.setColor(15)
  api.g.area(32, 1, 1, grid.height, "-")
  api.g.area(grid.width-31, 1, 1, grid.height, "-")
  
  api.g.box(grid.width-29, 20, 30, #systemApps+2)
  for k,v in ipairs(systemApps) do
    if (state.selectType == 1) and (state.selectNum == k) then
      api.g.text(grid.width-27, 20+k, ">")
    end
    api.g.text(grid.width-25, 20+k, v)
  end
  
  api.g.box(grid.width-29, 20+#systemApps+2, 30, #userApps+2)
  for k,v in ipairs(userApps) do
    if (state.selectType == 2) and (state.selectNum == k) then
      api.g.text(grid.width-27, 20+k+#systemApps+2, ">")
    end
    api.g.text(grid.width-25, 20+k+#systemApps+2, v)
  end
  
  
  api.g.box(1, 1, 30, grid.height)
  local i = 0
  local pid
  local app
  for k,v in ipairs(appList) do
    pid = v
    app = apps[v]
    i = i + 1
    api.g.box(1, 1+(i-1)*4, 30, 5, true)
    api.g.text(3, 2+(i-1)*4, app.title)
    api.g.text(26, 2+(i-1)*4, app.tag)
    api.g.text(3, 3+(i-1)*4, "PID: " .. pid)
    
    if pid == appList[state.active] then
      api.g.text(20, 3+(i-1)*4, ">>>>>>")
    end
    
    if app.err ~= "" then
      api.g.text(3, 4+(k-1)*4, "Error!")
    end
  end
  
  api.g.area(grid.width-11, 1, 12, 7, " ")
  api.g.box(grid.width-11, 1, 12, 3)
  api.g.box(grid.width-11, 3, 12, 3, true)
  api.g.box(grid.width-11, 5, 12, 3, true)
  api.g.text(grid.width-9, 2, os.date():sub(10, 17))
  api.g.text(grid.width-9, 4, os.date():sub(1, 8))
  api.g.text(grid.width-9, 6, "TPS: " .. love.timer.getFPS())
  
  -- Print Everything
  
  ---[[
  local line
  for i=1, grid.height do
    line = ""
    for j=1, grid.width do
      if not (canvas[i][j] == nil) then
        line = line .. canvas[i][j]
      else
        line = line .. "!"
      end
      
    end
    love.graphics.print(line ,grid.widthbuffer, grid.heightbuffer + 14 * (i-1))
  end
  --]]
  
  -- **** ALTERNATE PRINT METHODS FOR COLOR! NEEDS OPTIMIZATION! ****
  
  --[[
  for i=1, grid.height do
    line = ""
    start = 0
    for j=1, grid.width do
      if start < 1 then
        start = j
        line = ""
      end
      if colorOut[i][j] ~= currentPrintColor then
        love.graphics.print(line, grid.widthbuffer + (start-1)*grid.fontwidth,
          grid.heightbuffer + (i-1)*grid.fontheight)
        line = canvas[i][j]
        gra.setColor(colorOut[i][j])
        start = j
      elseif j == grid.width then
        line = line..canvas[i][j]
        love.graphics.print(line, grid.widthbuffer + (start-1)*grid.fontwidth,
          grid.heightbuffer + (i-1)*grid.fontheight)
        start = 0
        line = ""
      else
        line = line..canvas[i][j]
      end
      
    end
    
  end
  --]]
  
  --[[
  finalPrint = {gra.getColor(15)}
  text = ""
  currentPrintColor = -1
  for i=1, #canvas do
    
    for j=1, #canvas[1] do
      
      if colorOut[i][j] ~= currentPrintColor then
        table.insert(finalPrint, text)
        table.insert(finalPrint, gra.getColor(colorOut[i][j]))
        text = ""
      end
      
      text = text .. canvas[i][j]
      
    end
    
    text = text .. "\n"
  end
  table.insert(finalPrint, text)
  love.graphics.print(finalPrint ,grid.widthbuffer, grid.heightbuffer)
  --]]
  
  --[[
  colorPrints = {}
  for i=0, 15 do
    colorPrints[i] = {}
  end
  
  
  
  
  for i=1, #canvas do
    
    for j=1, #canvas[1] do
      
      for k=0, 15 do
        
        if colorOut[i][j] == k then
          table.insert(colorPrints[k], canvas[i][j])
        else
          table.insert(colorPrints[k], " ")
        end
        
      end
    end
    for k=0, 15 do
      table.insert(colorPrints[k], "\n")
    end
  end
  
  for i=0, 15 do
    gra.setColor(i)
    love.graphics.print(table.concat(colorPrints[i]), grid.widthbuffer, grid.heightbuffer)
    
    
  end
  --]]
  
end

function setCanvas(x, y, char)
  canvas[y][x] = char
end

function getCanvas()
  return (canvas)
end

function love.textinput(char)
  
  -- App Controls
  if state.active ~= 0 and apps[appList[state.active]].code.textInput ~= nil then
    apps[appList[state.active]].code.textInput(char)
  end
end

function love.keypressed(key, scan, rep)
  
  if key == "\\" and state.active ~= 0 then
    print(state.active)
    apps[state.active].err = ""
  end
  
  -- OS Controls
  if love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl") or true then
    
    if key == "tab" then
      if love.keyboard.isDown("lshift") then
        state.active = (state.active - 1) % (#appList + 1)
      else
        state.active = (state.active + 1) % (#appList + 1)
      end
        
    end
    
    if key == "escape" then
      if state.active == 0 then
        love.event.quit()
      elseif state.active <= #appList then
        app.endTask(appList[state.active])
        if state.active > #appList then state.active = #appList end
      end
    end
    
    if key == "end" then
      state.selectType = (state.selectType) % 2 + 1
      state.selectNum = 1
    end
    
    if key == "pageup" then
      if state.selectType == 1 then
        state.selectNum = (state.selectNum - 2) % #systemApps + 1
      elseif state.selectType == 2 then
        state.selectNum = (state.selectNum - 2) % #userApps + 1
      end
    end
    
    if key == "pagedown" then
      if state.selectType == 1 then
        state.selectNum = (state.selectNum) % #systemApps + 1
      elseif state.selectType == 2 then
        state.selectNum = (state.selectNum) % #userApps + 1
      end
    end
    
    if key == "home" then
      if state.selectType == 1 then
        app.newTask(love.filesystem.getSource( ).. "/os/sysapps/"..systemApps[state.selectNum], "SYS")
      elseif state.selectType == 2 then
        app.newTask(love.filesystem.getSource( ).. "/programs/"..userApps[state.selectNum], "APP")
      end
    end
  end

  -- App Controls
  if state.active ~= 0 and apps[appList[state.active]].code.keyPress ~= nil then
    apps[state.active].code.keyPress(key, rep)
  end
  
end

function love.keyreleased(key, scan)
  
  -- App Controls
  if state.active ~= 0 and apps[appList[state.active]].code.keyRelease ~= nil then
    apps[state.active].code.keyRelease(key)
  end
end
