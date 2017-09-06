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

gra = require("os.lib.gra")
app = require("os.lib.app")
api = require("os.lib.api")
lgc = require("os.lib.lgc")
utf8 = require("utf8")

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
  
  local systemApps = love.filesystem.getDirectoryItems("os/sysapps")
  local userApps = love.filesystem.getDirectoryItems("programs")
  
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
  
  textGrid = {}
  textGrid.width = math.floor(love.graphics.getWidth() / fontWidth)
  textGrid.height = math.floor(love.graphics.getHeight() / fontHeight)
  textGrid.widthbuffer = (love.graphics.getWidth() - textGrid.width * fontWidth) / 2
  textGrid.heightbuffer = (love.graphics.getHeight() - textGrid.height * fontHeight) / 2
  textGrid.fontwidth = fontWidth
  textGrid.fontheight = fontHeight
  
  -- Load Apps
  for k,v in pairs(systemApps) do
    app.newTask(love.filesystem.getSource( ).. "/os/sysapps/"..v, "SYS")
  end
  for k,v in pairs(userApps) do
    app.newTask(love.filesystem.getSource( ).. "/programs/"..v, "APP")
  end
  
  
end

function love.update(dt)
  -- Tick Counter
  ticks = ticks + 1
  
  -- OS Controls
  if love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl") then
    if love.keyboard.isDown("escape") then
      love.event.quit()
    end
  end
  
  if love.keyboard.isDown("escape") then
    love.event.quit()
  end
  
  -- Window Moving
  if love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl") then
    if ticks % 2 == 0 then
      local pid = appManager[1]
      if love.keyboard.isDown("up") then
        apps[pid].y = apps[pid].y - 1
      end
      if love.keyboard.isDown("down") then
        apps[pid].y = apps[pid].y + 1
      end
      if love.keyboard.isDown("left") then
        apps[pid].x = apps[pid].x - 1
      end
      if love.keyboard.isDown("right") then
        apps[pid].x = apps[pid].x + 1
      end
    end
  end
  
  -- Process processor for processing processes
  for pid,v in pairs(apps) do
    -- ID for graphics functions to handle
    currentPID = pid
    
    -- Run the app
    apps[pid].code.tick()
    
    -- Make sure the app is within the screen
    if apps[pid].x < 1 then apps[pid].x = 1 end
    if apps[pid].y < 1 then apps[pid].y = 1 end
    if apps[pid].x + apps[pid].width - 1 > textGrid.width then
      apps[pid].x = textGrid.width - apps[pid].width + 1
    end
    if apps[pid].y + apps[pid].height - 1 > textGrid.height then
      apps[pid].y = textGrid.height - apps[pid].height + 1
    end
  end
  
  
end

function love.draw()
  -- Reset Screen
  printOut = {}
  for i=1, textGrid.height do
    printOut[i] = {}
    for j=1, textGrid.width do
      printOut[i][j] = " "
    end
  end
  
  -- Reset Apps
  for pid,v in pairs(apps) do
    gra.appCanvasReset(pid)
  end
  
  -- Draw Apps
  for l = #appManager, 1, -1 do
    pid = appManager[l]
    
    --gra.setColor(15)
    gra.makeBox(apps[pid].x, apps[pid].y, apps[pid].width, apps[pid].height)
    gra.makeBoxAdapt(apps[pid].x, apps[pid].y, 5, 3)
    gra.makeBoxAdapt(apps[pid].x+4, apps[pid].y, apps[pid].width-4, 3)
    gra.makeBoxAdapt(apps[pid].x+4, apps[pid].y, apps[pid].width-4, 3)
    if (pid == appManager[1]) then
      sym = "█"
      gra.set(apps[pid].x, apps[pid].y, sym)
      gra.set(apps[pid].x+apps[pid].width-1, apps[pid].y, sym)
      gra.set(apps[pid].x, apps[pid].y+apps[pid].height-1, sym)
      gra.set(apps[pid].x+apps[pid].width-1, apps[pid].y+apps[pid].height-1, sym)
    end
    
    gra.text(apps[pid].x+1, apps[pid].y+1, apps[pid].tag)
    gra.text(apps[pid].x+6, apps[pid].y+1, apps[pid].title)
    
    currentPID = pid
    apps[pid].code.draw()
    
    for i=1, apps[pid].height-4 do
      for j=1, apps[pid].width-2 do
        gra.set(j+apps[pid].x, i+apps[pid].y+2, gra.appGet(pid, j, i))
      end
    end
  end
  
  -- Draw System Info
  --gra.setColor(15)
  gra.makeBox(textGrid.width-11, 1, 12, 3)
  gra.makeBoxAdapt(textGrid.width-11, 3, 12, 3)
  gra.makeBoxAdapt(textGrid.width-11, 5, 12, 3)
  gra.text(textGrid.width-9, 2, os.date():sub(10, 17))
  gra.text(textGrid.width-9, 4, os.date():sub(1, 8))
  gra.text(textGrid.width-9, 6, "TPS: " .. love.timer.getFPS())
  
  -- Print Everything
  for i=1, textGrid.height do
    line = ""
    for j=1, textGrid.width do
      if not (printOut[i][j] == nil) then
        line = line .. printOut[i][j]
      else
        line = line .. "!"
      end
      
    end
    love.graphics.print(line ,textGrid.widthbuffer, textGrid.heightbuffer + 14 * (i-1))
  end
  
  -- **** ALTERNATE PRINT METHODS FOR COLOR! NEEDS OPTIMIZATION! ****
  
  --[[for i=1, textGrid.height do
    line = ""
    start = 0
    for j=1, textGrid.width do
      if start < 1 then
        start = j
        line = ""
      end
      if colorOut[i][j] ~= currentPrintColor then
        love.graphics.print(line, textGrid.widthbuffer + (start-1)*textGrid.fontwidth,
          textGrid.heightbuffer + (i-1)*textGrid.fontheight)
        line = printOut[i][j]
        gra.setColor(colorOut[i][j])
        start = j
      elseif j == textGrid.width then
        line = line..printOut[i][j]
        love.graphics.print(line, textGrid.widthbuffer + (start-1)*textGrid.fontwidth,
          textGrid.heightbuffer + (i-1)*textGrid.fontheight)
        start = 0
        line = ""
      else
        line = line..printOut[i][j]
      end
      
    end
    
  end]]
  
  --[[finalPrint = {gra.getColor(15)}
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
  love.graphics.print(finalPrint ,textGrid.widthbuffer, textGrid.heightbuffer)]]
  
  --[[colorPrints = {}
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
    love.graphics.print(table.concat(colorPrints[i]), textGrid.widthbuffer, textGrid.heightbuffer)
    
    
  end]]
  
end

function love.textinput(char)
  
  -- App Controls
  if apps[appManager[1]].code.textInput ~= nil then
    apps[appManager[1]].code.textInput(char)
  end
end

function love.keypressed(key, scan, rep)
  
  -- OS Controls
  if love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl") then
    if key == "tab" then
      table.insert(appManager, table.remove(appManager, 1))
    end
  end

  -- App Controls
  if apps[appManager[1]].code.keyPress ~= nil then
    apps[appManager[1]].code.keyPress(key, rep)
  end
  
end

function love.keyreleased(key, scan)
  
  -- App Controls
  if apps[appManager[1]].code.keyRelease ~= nil then
    apps[appManager[1]].code.keyRelease(key)
  end
end
