local app = {}

function app.load()
  
  -- Define values on load.
  -- "title" is the text of the window, "mini" is if the app is minimized.
  local appInfo = {}
  appInfo.title = "Space Detector"
  appInfo.mini = false
  
  -- Define global variables here.
  
  
  return (appInfo)
end

function app.tick()
  
  -- Code here will be run every tick (or 1/60 of a second).
  
  
end

function app.draw(width, height)
  
  -- Code here to draw on the canvas.
  
  
end

-- Add more functions below, but they must be formatted 'app.<name>'.


return (app)