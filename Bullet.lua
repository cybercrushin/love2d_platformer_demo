Bullet = Object:extend()

function Bullet:new()
    self.x = 0
    self.y = 0
    self.img = nil
    self.height = 0
    self.width = 0
    self.dmg = 0
end

DefaultBullet = Bullet:extend()

function DefaultBullet:new(x, y, dir, rotation)
    self.img = love.graphics.newImage('Assets/bullets/default.png')
    self.x = x 
    self.y = y
    self.start_x = x
    self.start_y = y
    self.range_x = 2000
    self.range_y = 2000
    self.dir = dir
    self.rotation = rotation
    self.width = self.img:getHeight()
    self.height = self.img:getWidth()
    self.dmg = 500

    if dir == "left" then
        print("left fire"..self.y)
        self.x = x - 30
    else
        print("right fire"..self.y)
        self.x = x + 20
    end

    self.physics = {}
    self.physics.body = love.physics.newBody(World, self.x, self.y, "dynamic")
    self.physics.body:setFixedRotation(true)
    self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
end