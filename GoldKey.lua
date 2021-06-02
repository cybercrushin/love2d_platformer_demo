local GoldKey = {}
GoldKey.__index = GoldKey

GoldKey.width = 16
GoldKey.height = 16
GoldKey.type = 'gold_key'

local ActiveGoldKeys = {}
local Player = require("Player")

function GoldKey.removeAll(keys)
   target = keys or ActiveGoldKeys
   for i,v in ipairs(ActiveGoldKeys) do
      v.physics.body:destroy()
   end
   ActiveGoldKeys = {}
end

function GoldKey.new(x, y)
   local instance = setmetatable({}, GoldKey)
   instance.x = x
   instance.y = y

   
   print(x, y, instance.width, instance.height)
   instance.physics = {}
   instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "static")
   instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
   instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
   instance.physics.fixture:setSensor(true)
   instance.img = love.graphics.newImage("Assets/Items/gold_key.png")
   return instance
end


function GoldKey.beginContact(Player, Keys, a, b, collision)
    for i,instance in ipairs(Keys) do
       if a == instance.physics.fixture or b == instance.physics.fixture then
            if a == Player.physics.fixture or b == Player.physics.fixture then
                Player:addItem({type='gold_key'})
                print('Adding Item')
                instance:clear()
                table.remove(Keys, i)
                return true
            end
        end
    end
end


 function GoldKey:draw()
   --print(self.img, self.x, self.y, 0, 2, 2, self.width / 2, self.height / 2)
    love.graphics.draw(self.img, self.x, self.y, 0, 1, 1, self.width / 2, self.height / 2)
 end
 
 function GoldKey:clear()
    self.physics.body:destroy()
 end 
 
return GoldKey