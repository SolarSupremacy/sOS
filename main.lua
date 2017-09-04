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
utf8 = require("utf8")

currentPID = 0

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
  mainFont = love.graphics.newFont("os/dat/cour.ttf")
  
  systemApps = love.filesystem.getDirectoryItems("os/apps")
  userApps = love.filesystem.getDirectoryItems("programs")
  
  -- Graphics
  love.graphics.setBackgroundColor(0, 0, 0)
  --love.window.setMode(1820, 980)
  love.window.setFullscreen(true)
  
  -- Processing
  love.graphics.setFont(mainFont)
  local fontWidth = mainFont:getWidth(" ") -- 7
  local fontHeight = mainFont:getHeight(" ") -- 14
  
  math.randomseed(os.time())
  
  textGrid = {}
  textGrid.width = math.floor(love.graphics.getWidth() / fontWidth)
  textGrid.height = math.floor(love.graphics.getHeight() / fontHeight)
  textGrid.widthbuffer = (love.graphics.getWidth() - textGrid.width * fontWidth) / 2
  textGrid.heightbuffer = (love.graphics.getHeight() - textGrid.height * fontHeight) / 2
  
  -- Load Apps
  for k,v in pairs(systemApps) do
    app.newTask("os/apps/"..v, "SYS")
  end
  for k,v in pairs(userApps) do
    app.newTask("programs/"..v, "APP")
  end
  
  
end

function love.update(dt)
  
  -- Temp for quitting sOS
  if love.keyboard.isDown("escape") then
    love.event.quit()
  end
  
  -- Process processor for processing processes
  for pid,v in pairs(apps) do
    currentPID = pid
    apps[pid].code.tick()
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
  for pid,v in pairs(apps) do
    
    gra.setColor(15)
    gra.makeBox(apps[pid].x, apps[pid].y, apps[pid].width, apps[pid].height)
    gra.makeBoxAdapt(apps[pid].x, apps[pid].y, 5, 3)
    gra.makeBoxAdapt(apps[pid].x+4, apps[pid].y, apps[pid].width-4, 3)
    gra.makeBoxAdapt(apps[pid].x+4, apps[pid].y, apps[pid].width-4, 3)
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
  gra.setColor(15)
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
  
  --[[love.graphics.print("      ╔═════╦═════╗\n      ║     ║     ║\n      ║  ║  ║  ═══╣\n╔═════╣  ║  ║     ║\n║  ═══╣  ║  ╠═══  ║\n╠═══  ║     ║     ║\n╚═════╩═════╩═════╝", textGrid["WidthBuffer"], textGrid["HeightBuffer"])
  love.graphics.setColor(255,255,255)
  love.graphics.print("░░░░\n░░░░", 0, 120)
  love.graphics.print("▒▒▒▒\n▒▒▒▒", 0, 148)
  love.graphics.print("▓▓▓▓\n▓▓▓▓", 0, 176)
  love.graphics.print("████\n████", 0, 204)
  love.graphics.print("│ ─ └ ┘ ┐ ┌ ├ ┤ ┴ ┬ ┼", 0, 300)
  love.graphics.print("║ ═ ╚ ╝ ╗ ╔ ╠ ╣ ╩ ╦ ╬", 0, 328)
  
  for i=0, 7 do
    gra.setColor(i)
    love.graphics.print("      ╔═════╦═════╗\n      ║     ║     ║\n      ║  ║  ║  ═══╣\n╔═════╣  ║  ║     ║\n║  ═══╣  ║  ╠═══  ║\n╠═══  ║     ║     ║\n╚═════╩═════╩═════╝", 200, 100+100*i)
  end
  for i=8, 15 do
    gra.setColor(i)
    love.graphics.print("      ╔═════╦═════╗\n      ║     ║     ║\n      ║  ║  ║  ═══╣\n╔═════╣  ║  ║     ║\n║  ═══╣  ║  ╠═══  ║\n╠═══  ║     ║     ║\n╚═════╩═════╩═════╝", 400, -700+100*i)
  end]]
  
end