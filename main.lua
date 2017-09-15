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

local gra, app, api, lgc, utf8, love = gra, app, api, lgc, utf8, love

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
  --love.window.setMode(1820, 980)
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
  for pen,v in pairs(apps) do
    -- ID for graphics functions to handle
    state.currentPEN = pen
    
    -- Run the app
    apps[pen].code.tick()
    
  end
  
  
end

function love.draw()
  -- Reset Screen
  printOut = {}
  for i=1, grid.height do
    printOut[i] = {}
    for j=1, grid.width do
      printOut[i][j] = " "
    end
  end
  
  -- Reset Apps
  for pen,v in pairs(apps) do
    gra.appCanvasReset(pen)
  end
  
  
  -- Draw Apps
  if state.activePEN ~= 0 then
    pen = state.activePEN

    state.currentPEN = pen
    apps[pen].code.draw(grid.width-66, grid.height)

    for i=1, grid.height do
      for j=1, grid.width - 66 do
        gra.set(j+33, i, gra.appGet(pen, j, i))
      end
    end
  end
  
  -- Draw System Info
  --gra.setColor(15)
  gra.setArea(32, 1, 1, grid.height, "-")
  gra.setArea(grid.width-31, 1, 1, grid.height, "-")
  
  gra.makeBox(grid.width-29, 20, 30, #systemApps+2)
  for k,v in ipairs(systemApps) do
    if (state.selectType == 1) and (state.selectNum == k) then
      gra.text(grid.width-27, 20+k, ">")
    end
    gra.text(grid.width-25, 20+k, v)
  end
  
  gra.makeBox(grid.width-29, 20+#systemApps+2, 30, #userApps+2)
  for k,v in ipairs(userApps) do
    if (state.selectType == 2) and (state.selectNum == k) then
      gra.text(grid.width-27, 20+k+#systemApps+2, ">")
    end
    gra.text(grid.width-25, 20+k+#systemApps+2, v)
  end
  
  
  gra.makeBox(1, 1, 30, grid.height)
  for k,v in ipairs(apps) do
    gra.makeBoxAdapt(1, 1+(k-1)*4, 30, 5)
    gra.text(3, 2+(k-1)*4, v.title)
    gra.text(26, 2+(k-1)*4, v.tag)
    gra.text(3, 3+(k-1)*4, "PID: " .. v.pid)
    
    if k == state.activePEN then
      gra.text(20, 3+(k-1)*4, ">>>>>>")
    end
    
  end
  
  gra.setArea(grid.width-11, 1, 12, 7, " ") 
  gra.makeBox(grid.width-11, 1, 12, 3)
  gra.makeBoxAdapt(grid.width-11, 3, 12, 3)
  gra.makeBoxAdapt(grid.width-11, 5, 12, 3)
  gra.text(grid.width-9, 2, os.date():sub(10, 17))
  gra.text(grid.width-9, 4, os.date():sub(1, 8))
  gra.text(grid.width-9, 6, "TPS: " .. love.timer.getFPS())
  
  -- Print Everything
  
  ---[[
  for i=1, grid.height do
    line = ""
    for j=1, grid.width do   
      if not (printOut[i][j] == nil) then
        line = line .. printOut[i][j]
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
        line = printOut[i][j]
        gra.setColor(colorOut[i][j])
        start = j
      elseif j == grid.width then
        line = line..printOut[i][j]
        love.graphics.print(line, grid.widthbuffer + (start-1)*grid.fontwidth,
          grid.heightbuffer + (i-1)*grid.fontheight)
        start = 0
        line = ""
      else
        line = line..printOut[i][j]
      end
      
    end
    
  end
  --]]
  
  --[[
  finalPrint = {gra.getColor(15)}
  text = ""
  currentPrintColor = -1
  for i=1, #printOut do
    
    for j=1, #printOut[1] do
      
      if colorOut[i][j] ~= currentPrintColor then
        table.insert(finalPrint, text)
        table.insert(finalPrint, gra.getColor(colorOut[i][j]))
        text = ""
      end
      
      text = text .. printOut[i][j]
      
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
  
  
  
  
  for i=1, #printOut do
    
    for j=1, #printOut[1] do
      
      for k=0, 15 do
        
        if colorOut[i][j] == k then
          table.insert(colorPrints[k], printOut[i][j])
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

function love.textinput(char)
  
  -- App Controls
  if state.activePEN ~= 0 and apps[state.activePEN].code.textInput ~= nil then
    apps[state.activePEN].code.textInput(char)
  end
end

function love.keypressed(key, scan, rep)
  
  -- OS Controls
  if love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl") or true then
    
    if key == "tab" then
      if love.keyboard.isDown("lshift") then
        state.activePEN = (state.activePEN - 1) % (#apps + 1)
      else
        state.activePEN = (state.activePEN + 1) % (#apps + 1)
      end
        
    end
    
    if key == "escape" then
      if state.activePEN == 0 then
        love.event.quit()
      elseif state.activePEN <= #apps then
        app.endTask(state.activePEN)
        if state.activePEN > #apps then state.activePEN = #apps end
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
  if state.activePEN ~= 0 and apps[state.activePEN].code.keyPress ~= nil then
    apps[state.activePEN].code.keyPress(key, rep)
  end
  
end

function love.keyreleased(key, scan)
  
  -- App Controls
  if state.activePEN ~= 0 and apps[state.activePEN].code.keyRelease ~= nil then
    apps[state.activePEN].code.keyRelease(key)
  end
end
