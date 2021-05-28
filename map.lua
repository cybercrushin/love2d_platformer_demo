local Map = {}
local STI = require("External/sti")
local AcidPit = require("AcidPit")
local Camera = require("camera")
-- local Coin = require("coin")
-- local Spike = require("spike")
-- local Stone = require("stone")
-- local Enemy = require("enemy")
-- local Player = require("Player")

function Map:load()
   self.index = 1
   self.levels = {}
   self.levels[0] = 'wasteland/wasteland'
   self.levels[1] = 'wasteland/wasteland_2'
   self.levels[2] = 'wasteland/wasteland_3'
   self.currentLevel = self.levels[0]
   World = love.physics.newWorld(0,2000)
   World:setCallbacks(beginContact, endContact)
   self.hazards = {}
   self:init()
end

function Map:init()
   self.currentLevel = self.levels[self.index]
   self.level = STI("Assets/Map/"..self.currentLevel..".lua", {"box2d"})

   self.level:box2d_init(World)
   self.solidLayer = self.level.layers.solid
   self.groundLayer = self.level.layers.ground
   self.hazardLayer = self.level.layers.hazard
   --self.entityLayer = self.level.layers.entity

   self.solidLayer.visible = false
   if self.hazardLayer then 
      self.hazardLayer.visible = false
   end
   --self.entityLayer.visible = false
   MapWidth = self.groundLayer.width * 16
   self.map_width = MapWidth

   self:spawnEntities()
   self:spawnHazards()
end

function Map:draw(cam_x, cam_y, cam_w, cam_h)
   local msg = "Level: " .. self.currentLevel .. " x: " .. Player.x .. "y: ".. Player.y
   love.graphics.print(msg, 10, 10)
   local msg2 = "Player Health: " .. Player.hp .. " Iframes: " .. Player.remaining_iframes
   love.graphics.print(msg2, 10, 30)
   local msg2 = "Player Last G X: " .. Player.last_grounded_x .. " Last G Y: " .. Player.last_grounded_y
   love.graphics.print(msg2, 10, 50)
   self.level:draw(cam_x, cam_y, cam_w, cam_h)
   Camera:apply()
   Player:draw()
   Camera:clear()
end

function Map:next(new_index)
   self.index =  new_index or self.index + 1
   self:clean()
   if nil == self.levels[self.index] then 
      print('doesnint exist')
      self.index = 0
   end
   
   self:init(self.index)
   Player:resetPosition()
end

function Map:clean()
   self.level:box2d_removeLayer("solid")
   AcidPit.removeAll()
--    Coin.removeAll()
--    Enemy.removeAll()
--    Stone.removeAll()
--    Spike.removeAll()
end

function Map:update()
   if Player.x > MapWidth - 16 then
      self:next()
   end
end

function Map:spawnEntities()

	-- for i,v in ipairs(self.entityLayer.objects) do
	-- 	-- if v.type == "spikes" then
	-- 	-- 	Spike.new(v.x + v.width / 2, v.y + v.height / 2)
	-- 	-- elseif v.type == "stone" then
	-- 	-- 	Stone.new(v.x + v.width / 2, v.y + v.height / 2)
	-- 	-- elseif v.type == "enemy" then
	-- 	-- 	Enemy.new(v.x + v.width / 2, v.y + v.height / 2)
	-- 	-- elseif v.type == "coin" then
	-- 	-- 	Coin.new(v.x, v.y)
	-- 	-- end
	-- end
end

function Map:spawnHazards()
   if self.hazardLayer then
      for i, v in ipairs(self.hazardLayer.objects) do
         if v.type == 'acid_pit' then 
            AcidPit.new(v.x, v.y, v.width, v.height)   
         end
      end
   end 
end

function Map:keypressed(key)
   print(key)
   if key == "escape" then
         love.event.push("quit")
   end
   if key == "0" then
      Map:next(0)
   end
   if key == "1" then
      Map:next(1)
   end
   if key == "2" then
      Map:next(2)
   end
   
end

function Map:beginContact(a, b, collision)
   AcidPit.beginContact(Player, a, b, collision)
end 

return Map
