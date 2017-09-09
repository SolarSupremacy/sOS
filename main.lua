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
  
  grid = {}
  grid.width = math.floor(love.graphics.getWidth() / fontWidth)
  grid.height = math.floor(love.graphics.getHeight() / fontHeight)
  grid.widthbuffer = (love.graphics.getWidth() - grid.width * fontWidth) / 2
  grid.heightbuffer = (love.graphics.getHeight() - grid.height * fontHeight) / 2
  grid.fontwidth = fontWidth
  grid.fontheight = fontHeight
  
  -- Load Apps
  for k,v in ipairs(systemApps) do
    app.newTask(love.filesystem.getSource( ).. "/os/sysapps/"..v, "SYS")
  end
  for k,v in ipairs(userApps) do
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
    currentpen = pen
    
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
  if activeApp ~= 0 then
    pen = activeApp

    currentpen = pen
    apps[pen].code.draw(grid.width-66, grid.height)

    for i=1, grid.height do
      for j=1, grid.width - 66 do
        gra.set(j+33, i, gra.appGet(pen, j, i))
      end
    end
  end
  
  -- Draw System Info
  --gra.setColor(15)
  gra.setArea(1, 1, 32, grid.height, "#")
  gra.setArea(grid.width-31       , 1, 32, grid.height, "#")
  gra.text(3,     3, apps[pen].tag)
  gra.text(3, 5, apps[pen].title)
  gra.setArea(grid.width-11, 1, 12, 7, " ") 
  gra.makeBox(grid.width-11, 1, 12, 3)
  gra.makeBoxAdapt(grid.width-11, 3, 12, 3)
  gra.makeBoxAdapt(grid.width-11, 5, 12, 3)
  gra.text(grid.width-9, 2, os.date():sub(10, 17))
  gra.text(grid.width-9, 4, os.date():sub(1, 8))
  gra.text(grid.width-9, 6, "TPS: " .. love.timer.getFPS())
  
  -- Print Everything
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
  if activeApp ~= 0 and apps[activeApp].code.textInput ~= nil then
    apps[activeApp].code.textInput(char)
  end
end

function love.keypressed(key, scan, rep)
  
  -- OS Controls
  if love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl") or true then
    if key == "tab" then
      activeApp = activeApp + 1
      if activeApp > #apps then
        activeApp = 1
      end
    end
  end

  -- App Controls
  if activeApp ~= 0 and apps[activeApp].code.keyPress ~= nil then
    apps[activeApp].code.keyPress(key, rep)
  end
  
end

function love.keyreleased(key, scan)
  
  -- App Controls
  if activeApp ~= 0 and apps[activeApp].code.keyRelease ~= nil then
    apps[activeApp].code.keyRelease(key)
  end
end
