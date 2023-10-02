TitleScreenState = Class{__includes = BaseState}

griffith = love.graphics.newImage('image/___.png')

guts = love.graphics.newImage('image/guts-small.png')


function TitleScreenState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function TitleScreenState:render()
    love.graphics.draw(griffith, 400, 125, 0, 0.6, 0.6) -- 0 is for rotation, see the wiki

    love.graphics.draw(guts, -20, 125, 0, 0.6, 0.6) -- 0 is for rotation, see the wiki


    love.graphics.setFont(flappyFont)
    love.graphics.printf('BirdMan', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Press Enter', 0, 100, VIRTUAL_WIDTH, 'center')

   
end