require "bootstrap"
local Map = require("map")
local Camera = require ("camera")
local state = 'in_game'
local Pause = require ("pause")
function love.load()
    Map:load()
    Pause:load()
    Player:load()
    
end

function love.update(dt)
    if state == 'in_game' then
        World:update(dt)
        Player:update(dt)
        Map:update()
        Camera:setPosition(Player.x, 0)
    end
end

function love.draw()
    if state == 'in_game' then
        Map:draw(-Camera.x, -Camera.y, Camera.scale, Camera.scale)

        Camera:apply()
        Player:draw()
        Camera:clear()
    end
    if state == 'paused' then 
        Pause:draw()
    end 
end

function love.keypressed(key)
    -- fix logic here
    if key == 'p' then
        if state == 'in_game' then 
            state = 'paused'
        else 
            state = 'in_game'
        end
    else
        Map:keypressed(key)
        Player:keypressed(key)
    end
end

function beginContact(a, b, collision)
    Player:beginContact(a, b, collision)
	Map:beginContact(a, b, collision)
end

function endContact(a, b, collision)
	Player:endContact(a, b, collision)
end