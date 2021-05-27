local Map = {}
local STI = require("External/sti")
-- local Coin = require("coin")
-- local Spike = require("spike")
-- local Stone = require("stone")
-- local Enemy = require("enemy")
-- local Player = require("Player")
local AcidPits
function Map:load()
   self.currentLevel = 'wasteland'
   self.levels = {}
   self.levels[0] = 'wasteland'
   self.levels[1] = 'wasteland_2'
   self.levels[2] = 'wasteland_main'
   World = love.physics.newWorld(0,2000)
   World:setCallbacks(beginContact, endContact)

   self:init()
end

function Map:init()
   self.level = STI("Assets/map/"..self.currentLevel..".lua", {"box2d"})
   self.index = 0
   self.level:box2d_init(World)
   self.solidLayer = self.level.layers.solid
   self.groundLayer = self.level.layers.ground
   --self.entityLayer = self.level.layers.entity

   self.solidLayer.visible = false
   --self.entityLayer.visible = false
   MapWidth = self.groundLayer.width * 16
   self.map_width = MapWidth

   self:spawnEntities()
end

function Map:next()
   self.index = self.index + 1
   self:clean()
   self.currentLevel = self.levels[self.index]
   self:init()
   Player:resetPosition()
end

function Map:clean()
   self.level:box2d_removeLayer("solid")
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

function Map:keypressed(key)
   if key == "escape" then
         love.event.push("quit")
   end
end


return Map
