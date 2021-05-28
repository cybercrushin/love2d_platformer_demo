Player = {}
require("Bullet")
function Player:load()
    -- Size Params
    self.width = 20
    self.height = 30
    self.weight = 100
    self.x = 20
    self.y = 10
    self.startX = self.x
    self.startY = self.y
    self.xVel = 0
    self.yVel = 0
    self.maxSpeed = 200
    self.acceleration = 4000
    self.friction = 3500
    self.gravity = 1500
        -- Position Params
    -- love.graphics.getHeight() - (32 + self.height)
        --self.y = 0
        self.direction = "right"

    -- physics
    self.physics = {}
    self.physics.body = love.physics.newBody(World, self.x, self.y, "dynamic")
    self.physics.body:setFixedRotation(true)
    self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)



    -- Speed / Movement Params
    self.speed = 200
    self.speed_modifier = 1.5



    -- Assets
    self.sprite = LoveAnimation.new('Sprites/player.lua')
    self.sprite:setRelativeOrigin(0.5, 0.5)
    self.sprite_max_directional_frames = 4
    -- Actions
    self.ifames = 5


    -- Booleans
    self.can_fire = true
    self.is_firing = false
    self.taking_damage = false
    self.is_dodging = false
    self.can_accept_input = true
    self.jumping = false

    -- Weapons
    self.selected_weapon = 'default'
    self.weapons = {}
    self.weapons['default'] = {}
    self.weapons['default']['bullet'] = DefaultBullet
    self.weapons['default']['cooldown_total_time'] = .25
    self.weapons['default']['cooldown_val'] = self.weapons['default']['cooldown_total_time'] 

    -- Player Actions
    self.actions = {}
    self.actions['fire'] = function(dt)
        self:action(dt, 'move')
    end
    
    -- Player Bullet Objects
    self.bullets = {}
end

function Player:syncPhysics()
    if self.to_x and self.to_y then
        self.physics.body:setPosition(self.to_x, self.to_y)
        self.x = self.to_x
        self.y = self.to_y
        self.to_x = nil
        self.to_y = nil
        print(self.x)
    else 
        self.x, self.y = self.physics.body:getPosition()
        self.physics.body:setLinearVelocity(self.xVel, self.yVel)
    end
    self.sprite:setPosition(self.x, self.y)

end

function Player:teleportTo(x, y)
    self.to_x = x
    self.to_y = y
end

function Player:resetPosition(newX, newY)
    x = newX or self.startX
    y = newY or self.startY
    self.physics.body:setPosition(x, y)
 end

function Player:update(dt)
    self:checkBoundaries()
    self:syncPhysics()
    self:move(dt)
    self.sprite:update(dt)
    self:applyGravity(dt)
    self:weaponAction(dt)
    self:updateBullets(dt)
    
    
end

function Player:applyGravity(dt)
    if not self.grounded then
       self.yVel = self.yVel + self.gravity * dt
    end
 end

function Player:changeDirection(new_direction)
    local currentState = self.sprite:getCurrentState()
    if new_direction == 'left' then
        self.sprite:setHorizontalFlip(true)
    else
        self.sprite:setHorizontalFlip(false)
    end
    self.direction = new_direction

end

-- Handles player movement 
function Player:move(dt)
    if self.can_accept_input then
        -- move left or right
        if love.keyboard.isDown("a", "left") then
            self.xVel = -self.speed
            if self.sprite:getCurrentState() ~= 'running' and self.grounded then 
                self.sprite:setState('running')
            end
            self:changeDirection('left')
        elseif love.keyboard.isDown("d", "right") then
            self.xVel = self.speed
            if self.sprite:getCurrentState() ~= 'running' and self.grounded then 
                self.sprite:setState('running')
            end
            self:changeDirection('right')
            
            --self.playerImg = self.rightImage
        else
            if self.grounded then
                self.sprite:setState('neutral')
                self.xVel = 0
            else  
                self.xVel = 0
            end
        end

    end
end

-- Function that exexcutes generic player action
function Player:action(dt, action_name)
    if nil ~= self.actions[action_name] then
        self.actions[action_name](dt)
    end

end

-- Class method handles the actions on the players selected weapon
function Player:weaponAction(dt)
    selected = self.selected_weapon
    -- check selected weapon cool down period
    self.weapons[selected]['cooldown_val'] = dt + self.weapons[selected]['cooldown_val']

    -- if enough time has passed from the last shot, allow the next shot to occur
    if self.weapons[selected]['cooldown_val'] >= self.weapons[selected]['cooldown_total_time'] then
        self.weapons[selected]['cooldown_val'] = self.weapons[selected]['cooldown_total_time']
        self.can_fire = true
    else
        self.can_fire = false
    end

    -- if the user has hit an input to fire a weapon and cooldown has occured, add the bullet object to game
    if love.keyboard.isDown('space', 'rctrl', 'lctrl') and self.can_fire then    
        if self.direction == 'right' then
            rotation = math.rad(90)
        else
            rotation = math.rad(270)
        end
        newBullet = self.weapons[selected]['bullet'](self.x, self.y - 10, self.direction, rotation)
        table.insert(self.bullets, newBullet)
        self.weapons[selected]['cooldown_val'] = 0
        print('fire')
    end

end

-- This moves any active bullets across the screen
function Player:updateBullets(dt)
    for i, bullet in ipairs(self.bullets) do
        if bullet.dir == "left" then
            bullet.x = bullet.x - (250 * dt)
        elseif bullet.dir == "right" then
            bullet.x = bullet.x + (250 * dt)
        end

        if bullet.y < 0 then -- remove bullets when the   y pass off the screen
            table.remove(self.bullets, i)
        end
        if bullet.x > 2600 or bullet.x < 0 then
            table.remove(self.bullets, i)
            print('removed')
        end
    end
    
end

-- Checks to make sure the player is within the allowed boundaries of the game
function Player:checkBoundaries(dt)
    if self.x - 10 <= 0 then
        self.xVel = 1
    end
end

-- Draw all player related assets
function Player:draw()
    self:drawPlayer(dt)    
    self:drawBullets(dt)
end

-- Draw the player sprite
function Player:drawPlayer()
    --debug rectangle
    --love.graphics.setColor(0, 0, 0)
    --love.graphics.rectangle("line", self.x - self.width / 2, self.y - self.height / 2, self.width, self.height)
    love.graphics.setColor(255, 255, 255)
    self.sprite:draw()
    --love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
    local geo = self.sprite:getGeometry()
    --love.graphics.rectangle("line", geo.x, geo.y, geo.width, geo.height)
end

-- Draw the characters bullets if any
function Player:drawBullets()
    for i, bullet in ipairs(self.bullets) do
        love.graphics.draw(bullet.img, bullet.x, bullet.y, bullet.rotation)
    end
end

function Player:endContact(a, b, collision)
    if a == self.physics.fixture or b == self.physics.fixture then
       if self.currentGroundCollision == collision then
          self.grounded = false
       end
    end
 end

 function Player:beginContact(a, b, collision)
    if self.grounded == true then 
        return 
    end
    local nx, ny = collision:getNormal()
    if a == self.physics.fixture then
        if ny > 0 then
            self:land(collision)
        elseif ny < 0 then
            self.yVel = 0
        end
    elseif b == self.physics.fixture then
        if ny < 0 then
            self:land(collision)
        elseif ny > 0 then
            self.yVel = 0
        end
    end
 end

 function Player:land(collision)
    self.currentGroundCollision = collision
    self.yVel = 0
    self.grounded = true
    self.hasDoubleJump = true
    self.graceTime = self.graceDuration
 end
 

 

function Player:jump(key)
    if (key == "w" or key == "up") and self.grounded then
        self.yVel = -500
        self.grounded = false
        self.sprite:setState('jumping')
    end
end

function Player:keypressed(key)
    self:jump(key)
    self:attack(key)
end 

function Player:attack(key)

end