local app = {}

-- Define global variables for you app here.
testVal = 0
text = ""
function app.load()
  appInfo = {}
  -- Define values on load. "width" and "height" are for outer window dimentions.
  -- For reference, inner window dimentions are 4 shorter and 2 thinner.
  -- Example: outer width 40 and height 20 makes inner width 38 and height 16.
  -- "title" is the text at the top of the window, "mini" is if the app is minimized.
  appInfo.width = 60
  appInfo.height = 51
  appInfo.title = "Template App"
  appInfo.mini = false
  return (appInfo)
end  

function app.tick()
  
  -- Code here will be run every tick, or 1/60 of a second. 
  testVal = testVal + 1
  
end

function app.draw()
  
  -- Code here will be run after every tick, and the app's canvas is cleared
  -- before this function, so all drawing must be done from here.
  api.g.text(1,2,"This is an app coded only in test.lua")
  api.g.text(1,3,"which is outside of all of the OS code.")
  api.g.box(10,7,20,5,false)
  api.g.text(12,9,"This is working!")
  api.g.text(2,12,"Increments every tick: "..testVal)
  api.g.box(3,13,34,3)
  api.g.text(4+(testVal%32),14,"█")
  api.g.text(1,1,text)
end

-- Add more functions to do whatever you like down here.
function app.textInput(char)
  text = text..char
end


return (app)