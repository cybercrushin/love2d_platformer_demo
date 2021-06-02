local Map = {}
-- local AcidPit = require("AcidPit")
local Camera = require("camera")
local Room = require("room")
-- local Coin = require("coin")
-- local Spike = require("spike")
-- local Stone = require("stone")
-- local Enemy = require("enemy")
-- local Player = require("Player")

function Map:load()
   self.index = 0
   self.rooms = {}
   self.rooms[0] = 'wasteland/wasteland'
   self.rooms[1] = 'wasteland/wasteland_2'
   self.rooms[2] = 'wasteland/wasteland_3'
   --table.add(self.rooms, Room.new('wasteland/wasteland'))
   self.current_room = self.rooms[0]
   World = love.physics.newWorld(0,2000)
   World:setCallbacks(beginContact, endContact)
   self.hazards = {}
   self:init()
end

function Map:init()
   self.current_room = self.rooms[self.index]
   self.old_room = self.room 
   self.room = Room.new(self.current_room)
   self.old_room = nil 
   --self.entityLayer = self.room.layers.entity

   self.room.solid_layer.visible = false
   if self.room.hazard_layer then 
      self.room.hazard_layer.visible = false
   end
   --self.entityLayer.visible = false
   MapWidth = self.room.ground_layer.width * 16
   self.map_width = MapWidth

   self:spawnEntities(self.room)
end

function Map:draw(cam_x, cam_y, cam_w, cam_h)
   local msg = "Level: " .. self.current_room .. " x: " .. Player.x .. "y: ".. Player.y
   love.graphics.print(msg, 10, 10)
   local msg2 = "Player Health: " .. Player.hp .. " Iframes: " .. Player.remaining_iframes
   love.graphics.print(msg2, 10, 30)
   local msg2 = "Player Last G X: " .. Player.last_grounded_x .. " Last G Y: " .. Player.last_grounded_y
   love.graphics.print(msg2, 10, 50)
   self.room.map:draw(cam_x, cam_y, cam_w, cam_h)
   Camera:apply()
   self.room:draw()
   Player:draw()
   Camera:clear()
end

function Map:next(new_index)
   self.index =  new_index or self.index + 1
   self:clean()
   if nil == self.rooms[self.index] then 
      print('doesnint exist')
      self.index = 0
   end
   
   self:init(self.index)
   Player:removeKeys()
   Player:resetPosition()
end

function Map:clean()
   self.room:clean()
--    Coin.removeAll()
--    Enemy.removeAll()
--    Stone.removeAll()
--    Spike.removeAll()
end

function Map:update()
   if self.room.next_room then 
      self:next()
      return 
   end 
   if Player.x > MapWidth - 16 then
      self:next()
   end
end

function Map:spawnEntities()
   self.room:spawnHazards()
   self.room:spawnItemsFromMap()
   self.room:spawnTriggersFromMap()
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
   if self.room.hazard_layer then
      for i, v in ipairs(self.room.hazard_layer.objects) do
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
   self.room:beginContact(Player, a, b, collision)
   
end 

return Map
