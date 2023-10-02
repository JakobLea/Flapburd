push = require 'push'

Class = require 'class'

require 'Bird'

require 'Pipe'

require 'PipePair'

require 'StateMachine'
require 'states/BaseState'
require 'states/CountdownState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/TitleScreenState'


WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 678

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 271

local background = love.graphics.newImage('image/background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('image/ground.png')
local groundScroll = 0

local scrolling = true
local PAUSE_IMAGE = love.graphics.newImage('image/pause_icon.png')

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local BACKGROUND_LOOPING_POINT = 413

local GROUND_LOOPING_POINT = 514


local bird = Bird()

local pipePairs = {}

local spawnTimer = 0

local lastY = -PIPE_HEIGHT + math.random(80) + 20

local scrolling = true

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Im Birdman, thats who I am. In Paris. Brr brr')

    smallFont = love.graphics.newFont('font/font.ttf', 8)
    mediumFont = love.graphics.newFont('font/flappy.ttf', 14)
    flappyFont = love.graphics.newFont('font/flappy.ttf', 28)
    hugeFont = love.graphics.newFont('font/flappy.ttf', 56)   
    love.graphics.setFont(flappyFont)

    medals = {
        ['bronze'] = love.graphics.newImage('image/bronze.png'),
        ['silver'] = love.graphics.newImage('image/silver.png'),
        ['gold'] = love.graphics.newImage('image/gold.png'),
        }



    sounds = {
        ['jump'] = love.audio.newSource('sounds/jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('sounds/explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['music'] = love.audio.newSource('sounds/Batman.mp3', 'static'),
        ['pause'] = love.audio.newSource('sounds/pause.mp3', 'static')
    }

    sounds['jump']:setVolume(0.6)
    sounds['music']:setLooping(true)
    sounds['music']:setVolume(1)
    sounds['music']:play()

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['countdown'] = function() return CountdownState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end
    }
    gStateMachine:change('title')

    love.keyboard.keysPressed = {}

    love.mouse.buttonsPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end


function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
end

function love.update(dt)

    if love.keyboard.wasPressed('p') and gStateMachine:currentStateName() == 'play' then
        if scrolling then
            sounds['music']:pause()
        else
            sounds['music']:play()
        end
        sounds['pause']:play()
        scrolling = not scrolling
    end

    if scrolling then
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % 
            BACKGROUND_LOOPING_POINT
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % GROUND_LOOPING_POINT

        gStateMachine:update(dt)
    end

    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end



function love.draw()
    push:start()

    love.graphics.draw(background, -backgroundScroll, 0)
    gStateMachine:render()
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    if not scrolling then
        love.graphics.draw(PAUSE_IMAGE, VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2, 0, 1, 1, PAUSE_IMAGE:getWidth() / 2, PAUSE_IMAGE:getHeight() / 2)
        love.graphics.setFont(flappyFont)
        love.graphics.printf('GAME PAUSED', 0, VIRTUAL_HEIGHT / 2 - 56, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(mediumFont)
        love.graphics.printf('Press "p" To Resume Game', 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
    end

    push:finish()
    displayFPS()
end

function displayFPS()

    love.graphics.setFont(flappyFont)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print('FPS ' .. tostring(love.timer.getFPS()), 5, 5)
end