local AcidPit = {}
AcidPit.__index = AcidPit

AcidPit.width = 16
AcidPit.height = 16

local ActiveAcidPits = {}
local Player = require("Player")

function AcidPit.removeAll()
   for i,v in ipairs(ActiveAcidPits) do
      v.physics.body:destroy()
   end

   ActiveAcidPits = {}
end

function AcidPit.new(x, y, width, height)
   local instance = setmetatable({}, AcidPit)
   instance.x = x
   instance.y = y
   instance.width = width
   instance.height = height
   
   instance.damage = 1
    print(x, y, width, height)
   instance.physics = {}
   instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "static")
   instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
   instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
   instance.physics.fixture:setSensor(true)
   table.insert(ActiveAcidPits, instance)
   return instance
end

function AcidPit:update(dt)

end

function AcidPit:draw()
   love.graphics.draw(self.img, self.x, self.y, 0, 1, 1, self.width / 2, self.height / 2)
end

function AcidPit.updateAll(dt)
   for i,instance in ipairs(ActiveAcidPits) do
      instance:update(dt)
   end
end

function AcidPit.drawAll()
   for i,instance in ipairs(ActiveAcidPits) do
      instance:draw()
   end
end

function AcidPit.beginContact(Player, a, b, collision)
   for i,instance in ipairs(ActiveAcidPits) do
      if a == instance.physics.fixture or b == instance.physics.fixture then
         if a == Player.physics.fixture or b == Player.physics.fixture then
            Player:teleportTo(instance.x, 0)
            return true
         end
      end
   end
end

return AcidPit