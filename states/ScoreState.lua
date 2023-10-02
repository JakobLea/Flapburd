ScoreState = Class{__includes = BaseState}


function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    love.graphics.setFont(flappyFont)
       -- Change the game over message based on the score
    if self.score >= 100 then
        love.graphics.printf('Congratulations!\nYou won the gold medal!', 0, 24, VIRTUAL_WIDTH, 'center')
    elseif self.score >= 60 then
        love.graphics.printf('Great job!\nYou won the silver medal!', 0, 24, VIRTUAL_WIDTH, 'center')
    elseif self.score >= 30 then
        love.graphics.printf('Nice try!\nYou won the bronze medal!', 0, 24, VIRTUAL_WIDTH, 'center')
    else
        love.graphics.printf('Oof! You lost!', 0, 24, VIRTUAL_WIDTH, 'center')
    end

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 92, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Medals earned this round:', 0, 120, VIRTUAL_WIDTH, 'center')


       -- Display medals based on the score
    if self.score >= 30 then
        love.graphics.draw(medals['bronze'], VIRTUAL_WIDTH / 2 - medals['bronze']:getWidth() / 2 + 40, 144)
    end
    if self.score >= 60 then
        love.graphics.draw(medals['silver'], VIRTUAL_WIDTH / 2 - medals['silver']:getWidth() / 2, 144)
    end
    if self.score >= 100 then
        love.graphics.draw(medals['gold'], VIRTUAL_WIDTH / 2 - medals['gold']:getWidth() / 2 - 40, 144)
    end

    love.graphics.printf('Press Enter to Play Again!', 0, 200, VIRTUAL_WIDTH, 'center')
end