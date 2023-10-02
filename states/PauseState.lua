PauseState = Class{__includes = BaseState}

function PauseState:init()
    self.timer = 0
    self.enterParams = {}
end

function PauseState:update(dt)
    self.timer = self.timer + dt
    
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        self.enterParams = {
            ['bird'] = self.bird,
            ['pipePairs'] = self.pipePairs,
            ['timer'] = self.timer,
            ['score'] = self.score
        }
        self.timer = self.timer + 10

        gStateMachine:change('play', self.enterParams)   
    end
end

function PauseState:enter(enterParams)

    scrolling = false
    self.bird = enterParams.bird
    self.pipePairs = enterParams.pipePairs
    self.timer = enterParams.timer
    self.score = enterParams.score
end

function PauseState:render()
    love.graphics.setFont(flappyFont)
    love.graphics.printf('The game paused!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Press Enter to continue', 0, 100, VIRTUAL_WIDTH, 'center')
    love.graphics.print(self.timer .. tostring(self.score), 8, 38)
end