Bird = Class{}

local GRAVITY = 10
local MAX_HEIGHT_ABOVE_SCREEN = -30  

function Bird:init()
    self.image = love.graphics.newImage('image/griffiths.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

    self.dy = 0
end

function Bird:collides(pipe)
    if (self.x - 5) + (self.width - 30) >= pipe.x and self.x + 7 <= pipe.x + PIPE_WIDTH then
        if (self.y - 5) + (self.height - 5) >= pipe.y and self.y + 7 <= pipe.y + PIPE_HEIGHT then
            return true
        end
    end

    return false
end

function Bird:update(dt)
    self.dy = self.dy + GRAVITY * dt

    if love.keyboard.wasPressed('space') or love.mouse.wasPressed(1) then
        self.dy = -2
        sounds['jump']:play()
    end

     -- Restrict the bird from going too high above the screen
     if self.y > MAX_HEIGHT_ABOVE_SCREEN then
    else
        self.y = MAX_HEIGHT_ABOVE_SCREEN
    end

    self.y = self.y + self.dy
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end