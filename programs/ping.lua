local app = {}

-- Define global variables for your app here.


function app.load()
  appInfo = {}
  -- Define values on load. "width" and "height" are for outer window dimentions.
  -- For reference, inner window dimentions are 4 shorter and 2 thinner.
  -- Example: outer width 40 and height 20 makes inner width 38 and height 16.
  -- "title" is the text at the top of the window, "mini" is if the app is minimized.
  appInfo.width = 120
  appInfo.height = 40
  appInfo.title = "Ping"
  appInfo.mini = false
  return (appInfo)
end  

function app.tick()
  
  -- Code here will be run every tick (or 1/60 of a second). 
  
  
end

function app.draw()
  
  -- Code here will be run after every tick, and the app's canvas is cleared
  -- before this function, so all drawing must be done from here.
  if api.i.keyStat("space") then
    api.g.text(1,1,"You pressed space")
  end
  
end

-- Add more functions to do whatever you like down here.


return (app)