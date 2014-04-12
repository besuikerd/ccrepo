local exports = {}

function exports.module(table)
  return setmetatable(table, {
    __call = function(t)
      for k, v in pairs(t) do
        _G[k] = v
      end
    end
  })
end

return exports.module(exports)