local gra = {}

-- sOS Graphics Library

-- Convert color code (0-15) to RGB values
local function _colorcodeToRGB(x)
  if (x == 0)      then return 0,   0,   0
  elseif (x == 1)  then return 128, 0,   0
  elseif (x == 2)  then return 0,   128, 0
  elseif (x == 3)  then return 128, 128, 0
  elseif (x == 4)  then return 0,   0,   128
  elseif (x == 5)  then return 128, 0,   128
  elseif (x == 6)  then return 0,   128, 128
  elseif (x == 7)  then return 192, 192, 192
  elseif (x == 8)  then return 128, 128, 128
  elseif (x == 9)  then return 255, 0,   0
  elseif (x == 10) then return 0,   255, 0
  elseif (x == 11) then return 255, 255, 0
  elseif (x == 12) then return 0,   0,   255
  elseif (x == 13) then return 255, 0,   255
  elseif (x == 14) then return 0,   255, 255
  else                  return 255, 255, 255
  end
end

-- currentSetColor = 15
-- currentPrintColor = 15

--[[
function gra.setColor(x)
  local r, g, b = _colorcodeToRGB(x)
  love.graphics.setColor(r, g, b)
  
end
--]]

--[[
function gra.getColor(x)
  
  local r, g, b = _colorcodeToRGB(x)
  love.graphics.setColor(r, g, b)
  
  currentPrintColor = x
  
  return {r, g, b}
  
end
--]]

--[[
function gra.color(color)
  currentSetColor = color
end
--]]

function gra.set(x, y, str)
  
  if str == "\n" or str == "\t" then str = " " end
  --color = color or 15
  
  if state.pid == 0 then
    if (y > grid.height) or (x > grid.width) then
      return
    end
    if (y < 1) or (x < 1) then
      return
    end
    
    setCanvas(x, y, str)
  else
    if (y > grid.height) or (x > grid.width - 66) then
      return
    end
    if (y < 1) or (x < 1) then
      return
    end
    
    setCanvas(x+33, y, str)
  end
  
  --colorOut[y][x] = currentSetColor
end

function gra.get(x, y)
  if state.pid == 0 then
    if (y > grid.height) or (x > grid.width) then
      return (nil)
    end
    return (getCanvas()[y][x])
  else
    if (y > grid.height) or (x > grid.width - 66) then
      return (nil)
    end
    return (getCanvas()[y][x+33])
  end
end

local function _textBarToDirections(bar)
  local up, down, right, left = false, false, false, false
  if (bar == "║") then up = true; down = true
  elseif (bar == "═") then right = true; left = true
  elseif (bar == "╚") then up = true; right = true
  elseif (bar == "╝") then up = true; left = true
  elseif (bar == "╗") then left = true; down = true
  elseif (bar == "╔") then right = true; down = true
  elseif (bar == "╠") then up = true; down = true; right = true
  elseif (bar == "╣") then up = true; down = true; left = true
  elseif (bar == "╩") then up = true; right = true; left = true
  elseif (bar == "╦") then down = true; right = true; left = true
  elseif (bar == "╬") then up = true; down = true; right = true; left = true
  end

  return up, down, right, left
end

function gra.charCombine(stri, strf)
  local u1, d1, r1, l1 = _textBarToDirections(stri)
  local u2, d2, r2, l2 = _textBarToDirections(strf)
  local up, down, right, left = u1 or u2, d1 or d2, r1 or r2, l1 or l2
  
  -- drastically increased indentation here for easier readbility
  if up then
        if down then
            if right then
                if left then
                    return ("╬")
                else
                    return ("╠")
                end
            else
                if left then
                    return ("╣")
                else
                    return ("║")
                end
            end
        else
            if right then
                if left then
                    return ("╩")
                else
                    return ("╚")
                end
            else
                if left then
                    return ("╝")
                else
                    return ("#")
                end
            end
        end
    else
        if down then
            if right then
                if left then
                    return ("╦")
                else
                    return ("╔")
                end
            else
                if left then
                    return ("╗")
                else
                    return ("@")
                end
            end
        else
            if right then
                if left then
                    return ("═")
                else
                    return ("%")
                end
            else
                if left then
                    return ("&")
                else
                    return (" ")
                end
            end
        end
  end
  
end

--[[
function gra.seto(x, y, str)
  gra.set(x, y, gra.charCombine(gra.get(x, y), str))
end
--]]

function gra.makeBox(x, y, w, h)
  gra.set(x, y, "╔")
  gra.set(x+w-1, y, "╗")
  gra.set(x, y+h-1, "╚")
  gra.set(x+w-1, y+h-1, "╝")
  
  for i=1, w-2 do
    gra.set(x+i, y, "═")
    gra.set(x+i, y+h-1, "═")
  end
  
  for i=1, h-2 do
    gra.set(x, y+i, "║")
    gra.set(x+w-1, y+i, "║")
  end
  
  for i=1, w-2 do
    for j=1, h-2 do
      gra.set(x+i, y+j, " ")
    end
  end
  
end

function gra.makeBoxAdapt(x, y, w, h)
  gra.seto(x, y, "╔")
  gra.seto(x+w-1, y, "╗")
  gra.seto(x, y+h-1, "╚")
  gra.seto(x+w-1, y+h-1, "╝")
  
  for i=1, w-2 do
    gra.seto(x+i, y, "═")
    gra.seto(x+i, y+h-1, "═")
  end
  
  for i=1, h-2 do
    gra.seto(x, y+i, "║")
    gra.seto(x+w-1, y+i, "║")
  end
  
  for i=1, w-2 do
    for j=1, h-2 do
      gra.seto(x+i, y+j, " ")
    end
  end
  
end

function gra.text(x, y, str)
  for i=1, string.len(str) do
    gra.set(x+i-1, y, string.sub(str, utf8.offset(str, i), utf8.offset(str, i+1)-1))
  end
end


-- [1, 2]
-- [3, 4]

-- [[1, 2], [3, 4]]

function gra.setArea(x, y, w, h, str)
  for i=1, h do
    for j=1, w do
      gra.set(x+j-1, y+i-1, str)
    end
  end
end

-- App Functions

function gra.appCanvasReset(pen)
  
  apps[pen].canvas = {}
  for i=1, grid.height do
    apps[pen].canvas[i] = {}
    for j=1, grid.width - 66 do
      apps[pen].canvas[i][j] = " "
    end
  end
  
  --[[
  apps[pen].canvasColor = {}
  for i=1, grid.height do
    apps[pen].canvasColor[i] = {}
    for j=1, grid.width do
      apps[pen].canvasColor[i][j] = 15
    end
  end
  --]]
  
end

function gra.appSet(pid, x, y, str)
  if (y > #apps[pid].canvas) or (x > #apps[pid].canvas[1]) then
    return
  end
  if (y < 1) or (x < 1) then
    return
  end
  apps[pid].canvas[y][x] = str
  --[[
  apps[pen].canvasColor[y][x] = currentSetColor
  --]]
end

function gra.appGet(pid, x, y)
  return (apps[pid].canvas[y][x])
end

return (gra)