local pause = {}
function pause:load()

end 

function init(state)
    self.state = state
end

function pause:draw()
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()

    -- overlay with pause message
    love.graphics.setColor(0,0,0, 100)
    love.graphics.rectangle('fill', 0,0, w, h)
    love.graphics.setColor(255,255,255)
    love.graphics.printf('PAUSE', 0, h/2, w, 'center')
end

function pause:keypressed(key)
    
end

return pause