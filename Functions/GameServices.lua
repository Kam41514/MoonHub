local Services = setmetatable({}, {
  __index = function(self, serviceName)
  local service = game:GetService(serviceName)
  rawset(self, serviceName, service)
  return service
  end
})

return Services
