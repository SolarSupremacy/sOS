local app = {}

function app.load()
  
  -- Define values on load.
  local appInfo = {}
  
  appInfo.title = "Example Program" --Title of the program.
  appInfo.mini = true --If the app 
  
  -- Define global variables here.
  countup = 0
  
  rand = 0
  rand2 = 0.5
  
  return (appInfo)
end

function app.tick()
  
  -- Code here will be run every tick (or 1/60 of a second).
  countup = countup + 0.001
  if countup > 1 then countup = 0 end
  
  rand = rand + (math.random()-0.5)*0.01
  
  if rand < -1 then rand = -1 end
  if rand > 1 then rand = 1 end
  
  rand2 = rand2 + rand * 0.001
  
  if rand2 < 0 then rand2 = 0 end
  if rand2 > 1 then rand2 = 1 end
  
end

function app.draw(width, height)
  
  -- Code here to draw on the canvas.
  
  api.g.text(5, 4, "Short Block")
  api.g.bar(5, 5, 10, "right", "block", countup)
  api.g.text(5, 6, "Long Block")
  api.g.bar(5, 7, 100, "right", "block", countup)
  api.g.text(5, 8, "Short Fade")
  api.g.bar(5, 9, 10, "right", "fade", countup)
  api.g.text(5, 10, "Long Fade")
  api.g.bar(5, 11, 100, "right", "fade", countup)
  
  api.g.text(5, 13, "static bars")
  api.g.bar(5, 14, 2, "right", "fade", 0.5)
  api.g.bar(5, 16, 2, "right", "fade", 0.625)
  api.g.bar(5, 18, 2, "right", "fade", 0.75)
  api.g.bar(5, 20, 2, "right", "fade", 0.875)
  api.g.bar(5, 22, 2, "right", "fade", 1.0)
  
  api.g.bar(10, 50, 100, "right", "fade", rand2)
  
end

-- Add more functions below, but they must be formatted 'app.<name>'.


return (app)