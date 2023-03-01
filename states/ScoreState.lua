--[[
    ScoreState Class
 
    A simple state used to display the end game screen when the player
    dies. Transitioned to from the PlayState.
]]
 
ScoreState = Class{__includes = BaseState}
 
local swidth = 384
 
 
function ScoreState:init()
    self.wood_bg = love.graphics.newImage('wood_texture.png')
    self.book_img = love.graphics.newImage('open_book.png')
    self.textbox = love.graphics.newImage('textbox.png')
    self.textbox_fill = love.graphics.newImage('textbox_fill.png')
    self.coffee = love.graphics.newImage('coffee.png')
    self.news = love.graphics.newImage('newspaper.png')
    self.fill = love.graphics.newImage('gauge_fill.png')
    self.volume = 1
 
    self.fade = false
    self.played = true
    self.timer = 0
end
 
function ScoreState:update(dt)
    -- starts a fade which will end by transitioning to playstate upon pressing enter
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        self.fade = true
    end
 
    sounds['main_theme']:setVolume(self.volume/10)
    if self.fade == true then
        self.volume = math.min(self.volume - dt/2, 1)
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
        gStateMachine:change('play')
    end
end
 
function ScoreState:render()
 
    love.graphics.draw(self.wood_bg, 0, 0, 0, 0.45, 0.45)
    love.graphics.draw(self.book_img, 256 - 1156*0.27/2, 17, 0, 0.27, 0.27)
    love.graphics.draw(self.textbox_fill, 15, 241, 0, 0.24, 0.22)
 
    --GAUGES
    --obj
    love.graphics.draw(self.fill, 18, 258, 0, 0.15 + (obj/100)*3.67, 0.23) --0.15
 
    --money
    love.graphics.draw(self.fill, 363, 276 - (money/100)*34, 0, 0.3, 0.03 + (money/100)*0.38)
 
    --rec
    love.graphics.draw(self.fill, 395, 274 - (rec/100)*31, 0, 0.6, 0.03 + (rec/100)*0.34)
 
    --health
    love.graphics.draw(self.fill, 450, 272 - (health/100)*24, 0, 0.43, 0.03 + (health/100)*0.27)
 
   
    love.graphics.draw(self.textbox, 8, 234, 0, 0.23, 0.22)
 
 
    love.graphics.draw(self.coffee, -80, 35, 0, 0.235, 0.235)
    love.graphics.draw(self.news, 440, -25, 0, 0.4, 0.4)
 
    love.graphics.setColor(0,0,0,0.75)
   
    if game_cond ~= 'obj' then
        love.graphics.setFont(pixelFontM)
        love.graphics.printf('GAME OVER', 118, 42, page_width, 'center')
    else
        love.graphics.setFont(pixelFontM)
        love.graphics.printf('CONGRATS!', 118, 42, page_width, 'center')
    end
 
    love.graphics.setFont(pixelFontS)
 
    if game_cond ~= 'obj' then
        love.graphics.printf('Notes To Self', 263, 35, page_width, "center")
        love.graphics.printf('-------------------------------', 263, 45, page_width + 2, "center")
    else
        love.graphics.printf('Credits', 263, 35, page_width, "center")
        love.graphics.printf('-------------------------------', 263, 45, page_width + 2, "center")
    end
 
    if game_cond == 'health+' then
        love.graphics.printf('Although being healthy is definitely beneficial, you might start to feel increased anxiety, depressive emotions, or mood swings due to health decisions that stray from your strict schedule such as eating away from home. There may also be an excessive amount of self-esteem which can damage relationships.', 268, 68, page_width + 2, 'left')
        love.graphics.printf('Your overinvestment in your health has caused you to overlook your financial objective. You say to yourself that you will come back to it but you never do.', 123, 65, page_width, 'left')
        love.graphics.printf('Press Enter To Play Again', 118, 190, page_width, 'center')
 
    elseif game_cond == 'health-' then
        love.graphics.printf('Make sure you take care of that body, mentally and physically. Afterall, you only have one and it takes utmost priority in your life!', 268, 59, page_width + 2, 'left')
        love.graphics.printf('You sacrificed your own health, physically and mentally, for things you beleived to be more important, but now you reap the dire consequences of your actions.', 123, 65, page_width, 'left')
        love.graphics.printf('Press Enter To Play Again', 118, 190, page_width, 'center')
 
    elseif game_cond == 'rec+' then
        love.graphics.printf("Living the high life aren't you? While it is necessary to have fun at times, make sure you balance that lifestyle out and allocate your money to long term goals.", 268, 59, page_width + 2, 'left')
        love.graphics.printf('You let distractions around you take priority and lost focus on what is important. Admist the partying and constant recreation, the focus on the financial objective you once had fades away completely.', 123, 65, page_width, 'left')
        love.graphics.printf('Press Enter To Play Again', 118, 190, page_width, 'center')
 
    elseif game_cond == 'rec-' then
        love.graphics.printf("Have you done anything fun? It's important to socialize and let loose a little. Time to make some friends and go touch some grass! Recreation is a necessity of a healthy lifestyle.", 268, 59, page_width + 2, 'left')
        love.graphics.printf('Ever since you were little, you thought recreation was meaningless and just a distraction. Only now when you have swamped yourself with responsibilities and no recreation to alleviate the stress, do you realize your mistake.', 123, 65, page_width, 'left')
        love.graphics.printf('Press Enter To Play Again', 118, 190, page_width, 'center')
 
    elseif game_cond == 'money-' then
        love.graphics.printf('Unfortunately you ran out of money. It is important to manage your money as spending more than you make can lead to debt issues.', 268, 59, page_width + 2, 'left')
        love.graphics.printf('Well, you are out of money. What more is there to say? Your life is in shambles due to your poor spending and money management.', 123, 65, page_width, 'left')
        love.graphics.printf('Press Enter To Play Again', 118, 190, page_width, 'center')
 
    elseif game_cond == 'money+' then
        love.graphics.printf('Even though this might be considered a good problem to have, hoarding too much money is not the case. With money just sitting around, it is simply losing value to inflation.', 268, 59, page_width + 2, 'left')
        love.graphics.printf('How did you lose, you are wondering? Well think again before excessively hoarding your money.', 123, 65, page_width, 'left')
        love.graphics.printf('Press Enter To Play Again', 118, 190, page_width, 'center')
 
    else
        love.graphics.printf('Developers\nWilliam Liu\nDaniel Lee\n\nNarrative Designer\nBen Ni\n\nAudio and Music Designer\nKyle Sung', 264, 60, page_width, 'center')
        love.graphics.printf('Congratulations! You have not only successfully completed your objective, but by doing so with a balanced lifestyle while being smart with your money. Continue being smart with your money!', 118, 68, page_width, 'left')
        love.graphics.printf('Press Enter To Play Again', 118, 190, page_width, 'center')
    end
 
    love.graphics.setColor(0, 0, 0, self.timer)
    love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
 
end
 
 
 
 
 

