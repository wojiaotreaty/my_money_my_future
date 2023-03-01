--[[
    GD50 2018
    Flappy Bird Remake James was here 2018
 
    Author: Colton Ogden
    cogden@cs50.harvard.edu
 
    A mobile game by Dong Nguyen that went viral in 2013, utilizing a very simple
    but effective gameplay mechanic of avoiding pipes indefinitely by just tapping
    the screen, making the player's bird avatar flap its wings and move upwards slightly.
    A variant of popular games like "Helicopter Game" that floated around the internet
    for years prior. Illustrates some of the most basic procedural generation of game
    levels possible as by having pipes stick out of the ground by varying amounts, acting
    as an infinitely generated obstacle course for the player.
]]
 
-- push is a library that will allow us to draw our game at a virtual
-- resolution, instead of however large our window is; used to provide
-- a more retro aesthetic
--
-- https://github.com/Ulydev/push
push = require 'push'
 
-- the "Class" library we're using will allow us to represent anything in
-- our game as code, rather than keeping track of many disparate variables and
-- methods
--
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'class'
 
require 'Book'
require 'Story'
 
-- a basic StateMachine class which will allow us to transition to and from
-- game states smoothly and avoid monolithic code in one file
require 'StateMachine'
 
-- all states our StateMachine can transition between
require 'states/BaseState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/TitleScreenState'
 
-- title screen images
title_bg = love.graphics.newImage('title_background.png')
title_book = love.graphics.newImage('title_book.png')
 
 
-- physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
 
--WINDOW_WIDTH = 1920
--WINDOW_HEIGHT = 1080
 
-- virtual resolution dimensions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288
 
--VIRTUAL_WIDTH = 768
--VIRTUAL_HEIGHT = 432
 
--local background = love.graphics.newImage('background.png')
 
--local ground = love.graphics.newImage('ground.png')
pause = false
 
function love.load()
    -- initialize our nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')
 
    -- seed the RNG
    math.randomseed(os.time())
 
    -- app window title
    love.window.setTitle('Decisions')
 
    -- initialize our nice-looking retro text fonts
    pixelFontS = love.graphics.newFont('font.ttf', 8)
    pixelFontM = love.graphics.newFont('font.ttf', 16)
    pixelFontL = love.graphics.newFont('font.ttf', 40)
 
    love.graphics.setFont(pixelFontM)
 
    -- initialize our table of sounds
    sounds = {
        ['coin'] = love.audio.newSource('Coin_Jingle.wav', 'static'),
        ['page_flip'] = love.audio.newSource('Page_Flip.mp3', 'static'),
        ['book_flip'] = love.audio.newSource('Page_Riffle_7.mp3', 'static'),
        ['selectA'] = love.audio.newSource('Project_C_SFX_1.mp3', 'static'),
        ['selectB'] = love.audio.newSource('Project_C_SFX_2_v2.mp3', 'static'),
        ['main_theme'] = love.audio.newSource('Project_C_Main_Theme_v5.mp3', 'static'),
        ['title_theme'] = love.audio.newSource('Project_C_Title_Theme_v6.mp3', 'static')
    }
   
    -- kick off music
   
    -- initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })
 
    -- initialize state machine with all state-returning functions
    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end
    }
    gStateMachine:change('title')
 
    -- initialize input table
    love.keyboard.keysPressed = {}
 
    -- initialize mouse input table
    love.mouse.buttonsPressed = {}
end
 
function love.resize(w, h)
    push:resize(w, h)
end
 
function love.keypressed(key)
    -- add to our table of keys pressed this frame
    love.keyboard.keysPressed[key] = true
 
    if key == 'escape' then
        love.event.quit()
    end
end
 
--[[
    LÖVE2D callback fired each time a mouse button is pressed; gives us the
    X and Y of the mouse, as well as the button in question.
]]
function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end
 
--[[
    Custom function to extend LÖVE's input handling; returns whether a given
    key was set to true in our input table this frame.
]]
function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end
 
--[[
    Equivalent to our keyboard function from before, but for the mouse buttons.
]]
function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
end
 
function love.update(dt)
 
    gStateMachine:update(dt)
 
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end
 
function love.draw()
    push:start()
    gStateMachine:render()
   -- love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)
    push:finish()
end
 
 
 
 
 

