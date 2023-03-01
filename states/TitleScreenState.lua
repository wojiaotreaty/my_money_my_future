--[[
    TitleScreenState Class
 
    The TitleScreenState is the starting screen of the game, shown on startup.
]]
 
TitleScreenState = Class{__includes = BaseState}
local y_shift = 0
x = 0
function TitleScreenState:init(dt)
    self.fade = false
    self.timer = 0
    self.volume = 0
    self.played = true
    sounds['title_theme']:setLooping(true)
    sounds['title_theme']:play()
end
 
function TitleScreenState:update(dt)
    sounds['title_theme']:setVolume(self.volume/10)
    if self.fade == false then
        self.volume = math.min(self.volume + dt/2, 1)
    else
        self.volume = self.volume - dt
    end
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        self.fade = true
    end
 
    if self.fade then
        self.timer = self.timer + dt
    end
 
    if self.timer > 0.35 and self.played then
        sounds['book_flip']:play()
        sounds['book_flip']:setVolume(0.1)
        self.played = false
    end
 
    if self.timer > 1 then
        sounds['title_theme']:stop()
        gStateMachine:change('play')
    end
 
 
    x = x + 0.012
    y_shift = math.sin(x) * 20
 
end
 
function TitleScreenState:render()
    love.graphics.draw(title_bg, 0, -30, 0, 0.45, 0.45)
    love.graphics.draw(title_book, 128, 85 + y_shift, -0.2, 0.40, 0.4)
 
    love.graphics.setColor(0, 0, 0, self.timer)
    love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
   
end
 
function TitleScreenState:exit()
 
end
 
 
 

