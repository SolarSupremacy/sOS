local lgc = {}

function lgc.copyTable(object) -- mpappas @ forums.coronalabs.com
  local tableLookup = {}
  local function _copy(obj)
    if type(obj) ~= "table" then
      return obj
    elseif tableLookup[obj] then
      return tableLookup[obj]
    end
    local new_table = {}
    tableLookup[obj] = new_table
    for index, value in pairs(obj) do
      new_table[_copy(index)] = _copy(value)
    end
    return setmetatable(new_table, getmetatable(obj))
  end
  return _copy(object)
end

function lgc.usub(str, i, j)
  if (j < i) then return ("") end
  return (string.sub(str, utf8.offset(str, i), utf8.offset(str, j)))
end



return (lgc)