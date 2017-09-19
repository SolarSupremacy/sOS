local app = {}

-- Define global variables for your app here.
at = {}

function app.load()
  local appInfo = {}
  -- Define values on load.
  -- For reference, inner window dimentions are 4 shorter and 2 thinner.
  -- Example: outer width 40 and height 20 makes inner width 38 and height 16.
  -- "title" is the text at the top of the window, "mini" is if the app is minimized.
  appInfo.title = "Task Manager"
  appInfo.mini = false
  return (appInfo)
end

function app.tick()
  
  at = api.s.appsTable()
  
end

function app.draw()--app.draw(width, height)
  
  api.g.box(1, 1, 56, 3, false)
  api.g.box(7, 1, 7, 3, true)
  api.g.box(48, 1, 9, 3, true)
  
  api.g.text(3, 2, "PID")
  api.g.text(9, 2, "TAG")
  api.g.text(15, 2, "PROCESS NAME")
  api.g.text(50, 2, "MINI.")
  
  api.g.box(1, 3, 56, 22, true)
  api.g.box(7, 3, 7, 22, true)
  api.g.box(48, 3, 9, 22, true)
  
  
  local i = 1
  for pid,v in pairs(at) do
    api.g.text(3, 3+i, pid)
    api.g.text(9, 3+i, v.tag)
    api.g.text(15, 3+i, v.title)
    api.g.text(50, 3+i, tostring(v.mini))
    
    i = i + 1
  end
  
end

-- Add more functions to do whatever you like down here.


return (app)