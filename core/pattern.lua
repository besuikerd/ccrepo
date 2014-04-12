local exports = {}

function exports.constructor(name, ...)
  local args = {...}
  if _G[name] then error(name.." already exists in namespace") end
  local mt = {
    __name = name,
    __tostring = function(t)
      local i = iter(t)
      return getmetatable(t).__name.. (#t == 0 and "" or ( "("..tail(i):foldl(function(accum, n) return accum..", "..tostring(n) end, tostring(head(i))) .. ")" ))
    end
  }
  if #args == 0 then
    cons = setmetatable({}, mt)
  else
    cons = function(...)
      local obj = {...}
      if(#obj ~= #args) then
        local missing = drop(#obj, iter(args))
        error("missing constructor arguments: ["..tail(missing):foldl(function(acc, s) return acc..","..s end, head(missing).."]"))
      end
      return setmetatable(obj, mt)
    end
  end
  return cons
end

function exports.match(cons, cases)
  if not getmetatable(cons) or not getmetatable(cons).__name then error("invalid constructor to match") end
  local case = cases[getmetatable(cons).__name]
  
  if(case) then
    assert(type(cons) == "table")
    if type(case) == "function" then return case(unpack(cons)) else return case end
  else
    error("non-exhaustive pattern, missing: "..cons.__name)
  end
end

return module(exports)