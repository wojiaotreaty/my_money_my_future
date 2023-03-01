--[[
    PlayState Class
 
    The PlayState class is the bulk of the game, holding code for the actual game.
    Transitions to ScoreState upon reaching a "death" condition
]]
PlayState = Class{__includes = BaseState}
 
game_cond = ""
 
health = 0
rec = 0
money = 0
obj = 0
 
page_width = 130
 
function PlayState:init()
    self.volume = 0
    self.played = true
    sounds['main_theme']:setLooping(true)
    sounds['main_theme']:setVolume(0)
    sounds['main_theme']:play()
 
    self.book = Book(stories, storiescopy)
    self.book:reset()
    --book:add_story()
    self.num_weeks = 1
    --gauges range from 0 (min) to 100 (max)
    self.health_gauge = 50
    self.rec_gauge = 50
    self.money_gauge = 50
    self.obj_bar = 0
 
    self.nhealth_gauge = 50
    self.nrec_gauge = 50
    self.nmoney_gauge = 50
    self.nobj_bar = 0
 
    self.last_key_pressed = nil
    self.investment = false
    self.menu = false
    self.display_changes = false
    self.job = false
    self.offering_job = false
    self.paycheck_counter = 0
    self.display_paycheck = false
    self.first_paycheck = false
    self.second_paycheck = false
    self.inflation = 0
    self.bonus_income = 0
 
    self.story = self.book:random_story()
    self.story_display = self.story:story_string()
   
    self.job_list = Book(job_offers)
    self.gf_offer = Book(girlfriend_offer)
    self.funfact = Book(funfacts)
    self.money_gift = Book(gift_money)
    self.f_advisor = Book(financial_advisor)
    self.second_paycheck_stories = Book(second_paycheck_stories_bank)
    self.num_paychecks = 0
   
 
    self.funfact_display = self.funfact:random_funfact()
 
    self.offering_gf = false
    self.advisor_appearance = false
 
 
    self.choice_highlight = 'none'
    self.timer = 0
   
   
    -- images
    self.wood_bg = love.graphics.newImage('wood_texture.png')
    self.book_img = love.graphics.newImage('open_book.png')
    self.textbox = love.graphics.newImage('textbox.png')
    self.textbox_fill = love.graphics.newImage('textbox_fill.png')
    self.coffee = love.graphics.newImage('coffee.png')
    self.news = love.graphics.newImage('newspaper.png')
    self.fill = love.graphics.newImage('gauge_fill.png')
    self.indicator = love.graphics.newImage('indicator.png')
    self.yes_button = love.graphics.newImage('yes_button.png')
    self.no_button = love.graphics.newImage('no_button.png')
    self.enter_button = love.graphics.newImage('enter_button.png')
 
end
 
function PlayState:update(dt)
    sounds['main_theme']:setVolume(self.volume/10)
    if self.fade == true then
        self.volume = math.min(self.volume + dt/2, 1)
    end
    --checks game end condition if the objective bar is complete
 
 
    if self.nrec_gauge ~= self.rec_gauge then
        if self.rec_gauge < self.nrec_gauge then
            self.rec_gauge = self.rec_gauge + 0.5
        else
            self.rec_gauge = self.rec_gauge - 0.5
        end
    end
 
    if self.nhealth_gauge ~= self.health_gauge then
        if self.health_gauge < self.nhealth_gauge then
            self.health_gauge = self.health_gauge + 0.5
        else
            self.health_gauge = self.health_gauge - 0.5
        end
    end
 
    if self.nmoney_gauge ~= self.money_gauge then
        if self.money_gauge < self.nmoney_gauge then
            self.money_gauge = self.money_gauge + 0.5
        else
            self.money_gauge = self.money_gauge - 0.5
        end
    end
   
 
    if self.nobj_bar ~= self.obj_bar then
        if self.obj_bar < self.nobj_bar then
            self.obj_bar = self.obj_bar + 0.5
        else
            self.obj_bar = self.obj_bar - 0.5
        end
    end
 
 
    if self.obj_bar >= 100 then
        gStateMachine:change('score')
        obj_weeks = self.num_weeks
        game_cond = "obj"
        health = self.nhealth_gauge
        rec = self.nrec_gauge
        money = self.nmoney_gauge
        obj = self.nobj_bar
    end
 
    if love.keyboard.wasPressed('return') then
        if self.nmoney_gauge - 5 > 0 then
            a = sounds['coin']:clone()
            a:setVolume(0.05)
            a:play()
            self.nobj_bar = self.nobj_bar + 2.5
            self.nmoney_gauge = self.nmoney_gauge - 5
        end
    end
 
 
    --the user needs to press 'y' or 'n' twice to confirm their choice
    if love.keyboard.wasPressed('y') then
        if self.last_key_pressed ~= 'y' then
            b = sounds['selectA']:clone()
            b:play()
            b:setVolume(0.05) --0.04
        end
        choice_highlight = 'yes'
        if self.last_key_pressed == 'y'then
            c = sounds['selectB']:clone()
            c:play()
            c:setVolume(0.06)
            page = sounds['page_flip']:clone()
            page:setVolume(0.2)
            page:play()
            self.last_key_pressed = nil
 
            -- change story + affect gauges
            guage_list = self.story:choice(true)
            self.nhealth_gauge = self.nhealth_gauge + guage_list[1] * 5
            self.nrec_gauge = self.nrec_gauge + guage_list[2] * 5
            self.nmoney_gauge = self.nmoney_gauge + guage_list[3] * 5
 
            if guage_list[1] < 0 then
                self.nmoney_gauge = self.nmoney_gauge - self.inflation
            end
 
            if self.job then
                self.paycheck_counter = self.paycheck_counter + 1
                if self.paycheck_counter % 4 == 0 then
                    self.nhealth_gauge = self.nhealth_gauge - 3
                    self.nmoney_gauge = self.nmoney_gauge + 20 + self.bonus_income
                    self.display_paycheck = true
                    if self.num_paychecks == 0 then
                        self.first_paycheck = true
                    elseif self.num_paychecks == 1 then
                        self.second_paycheck = true
                    end
                    self.num_paychecks = self.num_paychecks + 1
                else
                    self.display_paycheck = false
                end
            end
 
            if self.num_weeks % 10 == 0 then
                self.inflation = self.inflation + 5
            end
           
 
            --setting the next story
            self.num_weeks = self.num_weeks + 1
 
            if self.offering_job then
                self.job = true
                self.book:merge_books(job_stories)
                self.offering_job = false
            end
 
            if self.offering_gf then
                self.book:merge_books(girlfriend_stories)
                self.offering_gf = false
            end
 
            if self.advisor_appearance then
                self.bonus_income = 5
                self.advisor_appearance = false
            end
 
            if self.second_paycheck then
                self.story = self.second_paycheck_stories:random_story()
                self.story_display = self.story:story_string()
                self.second_paycheck = false
 
            elseif self.first_paycheck then
                self.story = self.f_advisor:random_story()
                self.story_display = self.story:story_string()
                self.advisor_appearance = true
                self.first_paycheck = false
           
            elseif self.num_weeks == 7 then
                self.story = self.gf_offer:random_story()
                self.story_display = self.story:story_string()
               
            elseif self.num_weeks == 5 then
                self.story = self.money_gift:random_story()
                self.story_display = self.story:story_string()
 
            elseif self.num_weeks == 9 or self.num_weeks == 14 or self.num_weeks == 19 and self.job == false then
                self.story = self.job_list:random_story()
                self.story_display = self.story:story_string()
                self.offering_job = true
 
            else
                self.story = self.book:random_story()
                self.story_display = self.story:story_string()
            end
 
            choice_highlight = 'none'
 
            --setting the next story
            self.display_changes = false
 
            --setting the next funfact
            self.funfact_display = self.funfact:random_funfact()
 
        else
            self.last_key_pressed = 'y'
            self.display_changes = true
            -- display changes
           
        end
       
    end
 
    if love.keyboard.wasPressed('n') then
        if self.last_key_pressed ~= 'n' then
            d = sounds['selectA']:clone()
            d:play()
            d:setVolume(0.05)
        end
        choice_highlight = 'no'
        if self.last_key_pressed == 'n'then
            e = sounds['selectB']:clone()
            e:play()
            e:setVolume(0.06)
            page = sounds['page_flip']:clone()
            page:setVolume(0.2)
            page:play()
            self.last_key_pressed = nil
 
            -- change story + affect gauges
            guage_list = self.story:choice(false)
            self.nhealth_gauge = self.nhealth_gauge + guage_list[1] * 5
            self.nrec_gauge = self.nrec_gauge + guage_list[2] * 5
            self.nmoney_gauge = self.nmoney_gauge + guage_list[3] * 5
           
            if self.job then
                self.paycheck_counter = self.paycheck_counter + 1
                if self.paycheck_counter % 4 == 0 then
                    self.nhealth_gauge = self.nhealth_gauge - 3
                    self.nmoney_gauge = self.nmoney_gauge + 20 + self.bonus_income
                    self.display_paycheck = true
                    if self.num_paychecks == 0 then
                        self.first_paycheck = true
                    elseif self.num_paychecks == 1 then
                        self.second_paycheck = true
                    end
 
                    self.num_paychecks = self.num_paychecks + 1
                else
                    self.display_paycheck = false
                end
            end
 
            if self.num_weeks % 10 == 0 then
                self.inflation = self.inflation + 2
            end
 
            self.num_weeks = self.num_weeks + 1
           
            if self.offering_job then
                self.offering_job = false
            end
 
            if self.offering_gf then
                self.offering_gf = false
            end
 
            if self.advisor_appearance then
                self.advisor_appearance = false
            end
 
            if self.first_paycheck then
                self.story = self.f_advisor:random_story()
                self.story_display = self.story:story_string()
                self.advisor_appearance = true
                self.first_paycheck = false
 
            elseif self.second_paycheck then
                self.story = self.second_paycheck_stories:random_story()
                self.story_display = self.story:story_string()
                self.second_paycheck = false
 
            elseif self.num_weeks == 7 then
                self.story = self.gf_offer:random_story()
                self.story_display = self.story:story_string()
                self.offering_gf = true
 
            elseif self.num_weeks == 5 then
                self.story = self.money_gift:random_story()
                self.story_display = self.story:story_string()
 
            elseif self.num_weeks == 9 or self.num_weeks == 14 or self.num_weeks == 19 and self.job == false then
                self.story = self.job_list:random_story()
                self.story_display = self.story:story_string()
                self.offering_job = true
            else
                self.story = self.book:random_story()
                self.story_display = self.story:story_string()
            end
 
            choice_highlight = 'none'
 
            --setting the next story
            self.display_changes = false
 
            --setting the next funfact
            self.funfact_display = self.funfact:random_funfact()
 
        else
            self.last_key_pressed = 'n'
            self.display_changes = true
            -- display changes
           
        end
    end
 
    -- checks game end conditions
    if self.nhealth_gauge >= 100 then
        gStateMachine:change('score')
        game_cond = "health+"
        health = self.nhealth_gauge
        rec = self.nrec_gauge
        money = self.nmoney_gauge
        obj = self.nobj_bar
 
    elseif self.nhealth_gauge <= 0 then
        gStateMachine:change('score')
        game_cond = "health-"
        health = self.nhealth_gauge
        rec = self.nrec_gauge
        money = self.nmoney_gauge
        obj = self.nobj_bar
 
    elseif self.nrec_gauge >= 100 then
        gStateMachine:change('score')
        game_cond = "rec+"
        health = self.nhealth_gauge
        rec = self.nrec_gauge
        money = self.nmoney_gauge
        obj = self.nobj_bar
 
    elseif self.nrec_gauge <= 0 then
        gStateMachine:change('score')
        game_cond = "rec-"
        health = self.nhealth_gauge
        rec = self.nrec_gauge
        money = self.nmoney_gauge
        obj = self.nobj_bar
 
    elseif self.nmoney_gauge <= 0 then
        gStateMachine:change('score')
        game_cond = "money-"
        health = self.nhealth_gauge
        rec = self.nrec_gauge
        money = self.nmoney_gauge
        obj = self.nobj_bar
 
    elseif self.nmoney_gauge >= 100 then
        gStateMachine:change('score')
        game_cond = "money+"
        health = self.nhealth_gauge
        rec = self.nrec_gauge
        money = self.nmoney_gauge
        obj = self.nobj_bar
 
    end
 
    if self.fade and self.timer > -1  then
        self.timer = self.timer - dt
    end
end
 
 
function PlayState:render()
    love.graphics.draw(self.wood_bg, 0, 0, 0, 0.45, 0.45)
    love.graphics.draw(self.book_img, 256 - 1156*0.27/2, 17, 0, 0.27, 0.27)
    love.graphics.draw(self.textbox_fill, 15, 241, 0, 0.24, 0.22)
 
    --GAUGES
    --obj
    love.graphics.draw(self.fill, 18, 258, 0, 0.15 + (self.obj_bar/100)*3.67, 0.23) --0.15
 
    --money
    love.graphics.draw(self.fill, 363, 276 - (self.money_gauge/100)*34, 0, 0.3, 0.03 + (self.money_gauge/100)*0.38)
 
    --rec
    love.graphics.draw(self.fill, 395, 274 - (self.rec_gauge/100)*31, 0, 0.6, 0.03 + (self.rec_gauge/100)*0.34)
 
    --health
    love.graphics.draw(self.fill, 450, 272 - (self.health_gauge/100)*24, 0, 0.43, 0.03 + (self.health_gauge/100)*0.27)
 
   
    love.graphics.draw(self.textbox, 8, 234, 0, 0.23, 0.22)
 
 
    love.graphics.draw(self.coffee, -80, 35, 0, 0.235, 0.235)
    love.graphics.draw(self.news, 440, -25, 0, 0.4, 0.4)
   
   
 
    if self.display_changes then
        if self.last_key_pressed == 'n' then
            indicator_list = self.story:choice(false)
 
            if indicator_list[3] == 1 or indicator_list[3] == -1 then
                love.graphics.draw(self.indicator, 369, 221, 0, 0.12, 0.12)
           
            elseif indicator_list[3] == 2 or indicator_list[3] == -2 then
                love.graphics.draw(self.indicator, 365, 216, 0, 0.17, 0.17)
 
            elseif indicator_list[3] == 3 or indicator_list[3] == -3 then
                love.graphics.draw(self.indicator, 363, 216, 0, 0.22, 0.22)
            end
 
            if indicator_list[2] == 1 or indicator_list[2] == -1 then
                love.graphics.draw(self.indicator, 414, 221, 0, 0.12, 0.12)
           
            elseif indicator_list[2] == 2 or indicator_list[2] == -2 then
                love.graphics.draw(self.indicator, 411, 216, 0, 0.17, 0.17)
 
            elseif indicator_list[2] == 3 or indicator_list[2] == -3 then
                love.graphics.draw(self.indicator, 409, 216, 0, 0.22, 0.22)
            end
 
            if indicator_list[1] == 1 or indicator_list[1] == -1 then
                love.graphics.draw(self.indicator, 462, 221, 0, 0.12, 0.12)
           
            elseif indicator_list[1] == 2 or indicator_list[1] == -2 then
                love.graphics.draw(self.indicator, 459, 216, 0, 0.17, 0.17)
 
            elseif indicator_list[1] == 3 or indicator_list[1] == -3 then
                love.graphics.draw(self.indicator, 456, 216, 0, 0.22, 0.22)
 
            end
 
           
 
        else
            indicator_list = self.story:choice(true)
 
            if indicator_list[3] == 1 or indicator_list[3] == -1 then
                love.graphics.draw(self.indicator, 369, 221, 0, 0.12, 0.12)
           
            elseif indicator_list[3] == 2 or indicator_list[3] == -2 then
                love.graphics.draw(self.indicator, 365, 216, 0, 0.17, 0.17)
           
            elseif indicator_list[3] == 3 or indicator_list[3] == -3 then
                love.graphics.draw(self.indicator, 363, 216, 0, 0.22, 0.22)
            end
 
            if indicator_list[2] == 1 or indicator_list[2] == -1 then
                love.graphics.draw(self.indicator, 414, 221, 0, 0.12, 0.12)
           
            elseif indicator_list[2] == 2 or indicator_list[2] == -2 then
                love.graphics.draw(self.indicator, 411, 216, 0, 0.17, 0.17)
           
            elseif indicator_list[2] == 3 or indicator_list[2] == -3 then
                love.graphics.draw(self.indicator, 409, 216, 0, 0.22, 0.22)
            end
 
            if indicator_list[1] == 1 or indicator_list[1] == -1 then
                love.graphics.draw(self.indicator, 462, 221, 0, 0.12, 0.12)
           
            elseif indicator_list[1] == 2 or indicator_list[1] == -2 then
                love.graphics.draw(self.indicator, 459, 216, 0, 0.17, 0.17)
 
            elseif indicator_list[1] == 3 or indicator_list[1] == -3 then
                love.graphics.draw(self.indicator, 456, 216, 0, 0.22, 0.22)
            end
 
           
 
        end
 
    end
    --story_display
 
    love.graphics.setFont(pixelFontS)
    love.graphics.setColor(0,0,0,0.75)
   
    love.graphics.printf(self.story_display, 118, 55, page_width, "left")
    love.graphics.printf(self.funfact_display, 267, 53, page_width - 2, "left")
    love.graphics.printf('Decision ' .. tostring(self.num_weeks), 118, 35, page_width, "left")
    love.graphics.printf('Financial Fun Fact', 263, 35, page_width, "center")
    love.graphics.printf('-------------------------------', 263, 45, page_width + 2, "center")
    love.graphics.printf('------------ HELP -------------', 263, 132, page_width + 2, "center")
   
   
    if self.display_paycheck and self.num_weeks % 10 == 0 then
        love.graphics.printf('You got your paycheck today, but you are feeling tired...', 118, 161, page_width, 'center')
        love.graphics.printf('Inflation continues to drive prices up...', 118, 136, page_width, 'center')
    else
        if self.display_paycheck then
            love.graphics.printf('You got your paycheck today, but you are feeling tired...', 118, 161, page_width, 'center')
        end
 
        if self.num_weeks % 10 == 0 then
            love.graphics.printf('Inflation continues to drive prices up...', 118, 161, page_width, 'center')
        end
    end
 
    -- tutorial explanations
    love.graphics.printf("View changes for YES, press again to confirm", 292, 144, page_width - 18, 'left')
    love.graphics.printf("View changes for NO, press again to confirm", 292, 169, page_width - 18, 'left')
    love.graphics.printf("Contribute money into your financial objective", 292, 194, page_width - 18, 'left')
 
    -- render story and images
 
    --display yes and no
    if choice_highlight == 'yes' then
        love.graphics.setFont(pixelFontM)
        love.graphics.setColor(30/255,60/255,4/255)
        love.graphics.printf('YES', 125, 187, page_width, 'left')
        love.graphics.setFont(pixelFontS)
        love.graphics.setColor(0,0,0,0.5)
        love.graphics.printf('NO', 100, 190, page_width, 'right')
    elseif choice_highlight == 'no' then
        love.graphics.setFont(pixelFontS)
        love.graphics.setColor(0,0,0,0.5)
        love.graphics.printf('YES', 130, 190, page_width, 'left')
        love.graphics.setFont(pixelFontM)
        love.graphics.setColor(60/255,13/255,0/255)
        love.graphics.printf('NO', 105, 187, page_width, 'right')
    else
        love.graphics.setFont(pixelFontS)
        love.graphics.setColor(0,0,0,0.75)
        love.graphics.printf('YES', 130, 190, page_width, 'left')
        love.graphics.printf('NO', 100, 190, page_width, 'right')
    end
 
    love.graphics.setColor(0,0,0,0.8)
 
    love.graphics.draw(self.yes_button, 264, 140, 0, 0.05, 0.05)
    love.graphics.draw(self.no_button, 264, 165, 0, 0.05, 0.05)
    love.graphics.draw(self.enter_button, 261, 190, 0, 0.06, 0.05)
 
 
    -- fade, THIS SHOULD BE THE LAST 2 LINES OF RENDER
    love.graphics.setColor(0, 0, 0, self.timer)
    love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end
 
--[[
    Called when this state is transitioned to from another state.
]]
function PlayState:enter()
    -- if we're restarting the game, reset the list of choices
    self.book:reset()
    self.fade = true
    self.timer = 1.2
 
 
end
