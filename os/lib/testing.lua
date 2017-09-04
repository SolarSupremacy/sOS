str:sub(i,i)

local bytesto = utf8.offset(str, i)

string.sub(str, utf8.offset(str, i), utf8.offset(str, i+1))