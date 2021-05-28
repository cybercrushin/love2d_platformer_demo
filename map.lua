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

function Map:init(index)
   self.level = STI("Assets/Map/"..self.currentLevel..".lua", {"box2d"})
   self.index = index or 0
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
end

function Map:draw(cam_x, cam_y, cam_w, cam_h)
   self.level:draw(cam_x, cam_y, cam_w, cam_h)
   Camera:apply()
   Player:draw()
   Camera:clear()
end

function Map:next()
   self.index = self.index + 1
   self:clean()
   if nil == self.levels[self.index] then 
      self.index = 0
   end
   self.currentLevel = self.levels[self.index]
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
   if self.hazardLayer then
      for i, v in ipairs(self.hazardLayer.objects) do
         if v.type == 'acid_pit' then 
            AcidPit.new(v.x, v.y, v.width, v.height)   
         end
      end
   end 
end

function Map:keypressed(key)
   if key == "escape" then
         love.event.push("quit")
   end
end

function Map:beginContact(a, b, collision)
   AcidPit.beginContact(Player, a, b, collision)
end 

return Map
