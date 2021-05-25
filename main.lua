require "bootstrap"
local Map = require("map")
local Camera = require ("camera")


function love.load()
    Map:load()
    Player:load()
    background = love.graphics.newImage('Assets/Map/wasteland/sky.png')
end

function love.update(dt)
    World:update(dt)
    Player:update(dt)
    Map:update()
    Camera:setPosition(Player.x, 0)
end

function love.draw()
    love.graphics.draw(background, 0, 0, 0, 3, 3)
    Map.level:draw(-Camera.x, -Camera.y, Camera.scale, Camera.scale)

	Camera:apply()

    Player:draw()
    Camera:clear()

end

function love.keypressed(key)
	Player:jump(key)
end

function beginContact(a, b, collision)
	Player:beginContact(a, b, collision)
end

function endContact(a, b, collision)
	Player:endContact(a, b, collision)
end