local app = {}

-- Define global variables for your app here.


function app.load()
  appInfo = {}
  -- Define values on load. "width" and "height" are for outer window dimentions.
  -- For reference, inner window dimentions are 4 shorter and 2 thinner.
  -- Example: outer width 40 and height 20 makes inner width 38 and height 16.
  -- "title" is the text at the top of the window, "mini" is if the app is minimized.
  appInfo.width = 80
  appInfo.height = 40
  appInfo.title = "Notepad"
  appInfo.mini = false
  
  cursor = {1, 1}
  
  text = {""}
  
  ticks = 0
  
  return (appInfo)
end

function app.tick()
  
  -- Code here will be run every tick (or 1/60 of a second).
  ticks = ticks + 1
  
end

function app.draw()
  
  -- Code here will be run after every tick, and the app's canvas is cleared
  -- before this function, so all drawing must be done from here.
  
  for i=1, #text do
    api.g.text(1, i, text[i])
  end
  
  if (ticks % 60) < 30 then
    api.g.set(cursor[1], cursor[2], "█")
  end
  
end

-- Add more functions to do whatever you like down here.

function app.textInput(char)
  if (cursor[1] <= #text[cursor[2]]) or true then
    text[cursor[2]] = lgc.usub(text[cursor[2]], 1, cursor[1]-1) .. char .. 
                      lgc.usub(text[cursor[2]], cursor[1], #text[cursor[2]])
  end
  
  cursor[1] = cursor[1] + 1
  
end

function app.keyPress(key)--app.keyPress(key, rep)
  ticks = 0
  if (key == "backspace") then
    if (text[#text] ~= "") then
      text[#text] = string.sub(text[#text], 1, #text[#text]-1)
    elseif (#text > 1) then
      table.remove(text, #text)
    end
    if cursor[1] > 1 then
      cursor[1] = cursor[1] - 1
    elseif cursor[2] > 1 then
      cursor[2] = cursor[2] - 1
      cursor[1] = #text[cursor[2]] + 1
    end
  elseif (key == "return") then
    text[#text+1] = ""
    cursor[1] = 1
    cursor[2] = cursor[2] + 1
  elseif (key == "right") then
    cursor[1] = cursor[1] + 1
  elseif (key == "left") then
    cursor[1] = cursor[1] - 1
    if cursor[1] < 1 and cursor[2] > 1 then
      cursor[2] = cursor[2] - 1
      cursor[1] = #text[cursor[2]] + 1
    end
  elseif (key == "down") then
    cursor[2] = cursor[2] + 1
  elseif (key == "up") then
    cursor[2] = cursor[2] - 1
  end
  
  if cursor[2] > #text then cursor[2] = #text end
  if cursor[2] < 1 then cursor[2] = 1 end
  if cursor[1] > #text[cursor[2]] + 1 then cursor[1] = #text[cursor[2]] + 1 end
  if cursor[1] < 1 then cursor[1] = 1 end
  
end

return (app)