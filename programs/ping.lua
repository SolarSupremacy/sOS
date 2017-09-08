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
  
  -- App Variable Setup
  state = "menu"
  -- menu, game
  
  p1 = {}
  p2 = {}
  
  
  p1.pos = 3
  p2.pos = 3
  p1.shots = 0
  p2.shots = 0
  
  cy = appInfo.height - 4
  cx = appInfo.width - 2
  
  ticks = 0
  
  prog = 60
  
  return (appInfo)
end  

function app.tick()
  ticks = ticks + 1
  
  if (ticks%prog == 0) then
    prog = prog - 1
    p1.shots = p1.shots + 1 
    p2.shots = p2.shots + 1 
  end
  
  
  if (ticks%2 == 0) then
    return
  end
  
  -- Code here will be run every tick (or 1/60 of a second). 
  if (api.i.keyStat("w")) then
    p1.pos = p1.pos - 1
    if (p1.pos < 3) then p1.pos = 3 end
  end
  if (api.i.keyStat("s")) then
    p1.pos = p1.pos + 1
    if (p1.pos > cy - 2) then p1.pos = cy - 2 end
  end
  if (api.i.keyStat("up")) then
    p2.pos = p2.pos - 1
    if (p2.pos < 3) then p2.pos = 3 end
  end
  if (api.i.keyStat("down")) then
    p2.pos = p2.pos + 1
    if (p2.pos > cy - 2) then p2.pos = cy - 2 end
  end
  
  if (api.i.keyStat("d")) and (p1.shots > 0) then
    p1.shots = p1.shots - 1
  end
  
  
  
end

function app.draw()
  
  -- Code here will be run after every tick, and the app's canvas is cleared
  -- before this function, so all drawing must be done from here.
  api.g.set(3, p1.pos-2, "┌")
  api.g.set(3, p1.pos-1, "│")
  api.g.set(3, p1.pos, "├")
  api.g.set(3, p1.pos+1, "│")
  api.g.set(3, p1.pos+2, "└")
  
  api.g.set(cx-2, p2.pos-2, "┐")
  api.g.set(cx-2, p2.pos-1, "│")
  api.g.set(cx-2, p2.pos, "┤")
  api.g.set(cx-2, p2.pos+1, "│")
  api.g.set(cx-2, p2.pos+2, "┘")
  --│ ─ └ ┘ ┐ ┌ ├ ┤ ┴ ┬ ┼
  
  api.g.text(9, 1, "Player 1 Shots: " .. p1.shots)
  api.g.text(cx-26, 1, "Player 2 Shots: " .. p2.shots)
  
end

-- Add more functions to do whatever you like down here.


return (app)