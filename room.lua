local STI = require("External/sti")
local AcidPit = require('AcidPit')
local GoldKey = require('GoldKey')

local Room = {}
Room.__index = Room
Room.width = 0
Room.height = 0
Room.items = {}

local Player = require("Player")


-- Static Methods 
function Room.new(room_name)
    local instance = setmetatable({}, Room)
    instance.room_name = map_name
    instance.map = STI("Assets/Map/"..room_name..".lua", {"box2d"})
    instance.map:box2d_init(World)
    instance.solid_layer = instance.map.layers.solid
    instance.ground_layer = instance.map.layers.ground
    instance.hazard_layer = instance.map.layers.hazard
    instance.item_layer = instance.map.layers.item
    instance.enemy_layer = instance.map.layers.enemy
    instance.trigger_layer = instance.map.layers.triggers
    instance.exit_points = {}
    instance.next_room = false
    if instance.solid_layer then 

      instance.solid_layer.visible = false
    end
    if instance.item_layer then 
      print('Has Items')
      instance.item_layer.visible = false
    end
    if instance.hazard_layer then 
      instance.hazard_layer.visible = false
    end
    if instance.trigger_layer then 
      instance.trigger_layer.visible = false
    end
    return instance
end

function Room.getRoom(room_name)

end 

function Room:update(dt)

end

function Room:draw()
   for i, item in ipairs(self.items) do
      item:draw()
   end
end


-- class methods
function Room:spawnHazards()
   if self.hazard_layer then
      for i, v in ipairs(self.hazard_layer.objects) do
         if v.type == 'acid_pit' then 
            AcidPit.new(v.x, v.y, v.width, v.height)   
         end
      end
   end 
end

function Room:spawnItemsFromMap()
   if self.item_layer then 
      for i, v in ipairs(self.item_layer.objects) do
         if v.type == 'gold_key' then 
            table.insert(self.items, GoldKey.new(v.x, v.y))   
         end
      end
   end 
end



function Room:spawnTriggersFromMap()
   if self.trigger_layer then 
      for i, v in ipairs(self.trigger_layer.objects) do
         print('add ep')
         if v.type == 'exit_point' then 
            ep = {
               x=v.x, 
               y=v.y,
               requires_type = v.properties.requires_type
            }
            table.insert(self.exit_points, ep)   
         end
      end
   end 
end 

function Room:spawnItemsFromMap()
   if self.item_layer then 
      for i, v in ipairs(self.item_layer.objects) do
         if v.type == 'gold_key' then 
            table.insert(self.items, GoldKey.new(v.x, v.y))   
         end
      end
   end 
end

function Room:clean()
   -- clear out physics for layers
   for key, val in ipairs(self.map.layers) do
      self.map:box2d_removeLayer(val.name)
   end
   AcidPit.removeAll()
   Room:removeItems()
end 

function Room:removeItems()
   if self.items then 
      for i, v in ipairs(self.items) do
         v:clear()
         table.remove(self.items, i)
      end
   end 
end 

function Room:beginContact(Player, a, b, collision)
   AcidPit.beginContact(Player, a, b, collision)
   GoldKey.beginContact(Player, self.items, a, b, collision)
   for i, ep in ipairs(self.exit_points) do
      print(Player.x, ep.x, ep.x - 20)
      if Player.x > ep.x - 20 then
         print('Right X Coords to exit')
         print (ep.requires_type)
         if ep.requires_type and Player:hasItemByType(ep.requires_type) then 
            print("Has the right item")
            self.next_room = true
         end
      end
   end 
end

return Room