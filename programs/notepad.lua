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
  
  pipe = " "
  
  if (ticks % 60) < 30 then
    pipe = "█"
  end
  
  for i=1, #text do
    printy = text[i]
    if (i == #text) then
      printy = printy..pipe 
    end
    api.g.text(1, i, printy)
  end
  
  
end

-- Add more functions to do whatever you like down here.

function app.textInput(char)
  text[#text] = text[#text]..char
end

function app.keyPress(key, rep)
  ticks = 0
  if (key == "backspace") then
    if (text[#text] ~= "") then
      text[#text] = string.sub(text[#text], 1, #text[#text]-1)
    elseif (#text > 1) then
      table.remove(text, #text)
    end
  elseif (key == "return") then
    text[#text+1] = ""
  end
end

return (app)