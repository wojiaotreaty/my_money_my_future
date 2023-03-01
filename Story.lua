--[[
    Story Class
 
    creates a story class that affects gauges accordingly
]]
 
Story = Class{}
 
 
function Story:init(sstring)
 
    self.string = ""
    
    self.string = string.sub(sstring, 13, string.len(sstring))

    ---------------------------------
    self.choice_yes = ""
    
    self.choice_yes = string.sub(sstring, 1, 6)
    
    ---------------------------------
    self.choice_no = ""
    
    self.choice_no = string.sub(sstring, 7, 12)
    
end
 
 
function Story:update(dt) end
 
function Story:choice(choice)
    gauge_list = {}
 
    if choice == true then
        if string.sub(self.choice_yes, 2, 2) == 'u' then
            gauge_list[1] = tonumber(string.sub(self.choice_yes, 1, 1))
        else
            gauge_list[1] = -1*tonumber(string.sub(self.choice_yes, 1, 1))
        end
 
        if string.sub(self.choice_yes, 4, 4) == 'u' then
            gauge_list[2] = tonumber(string.sub(self.choice_yes, 3, 3))
        else
            gauge_list[2] = -1*tonumber(string.sub(self.choice_yes, 3, 3))
        end
 
        if string.sub(self.choice_yes, 6, 6) == 'u' then
            gauge_list[3] = tonumber(string.sub(self.choice_yes, 5, 5))
        else
            gauge_list[3] = -1*tonumber(string.sub(self.choice_yes, 5, 5))
        end
 
 
    elseif choice == false then
        if string.sub(self.choice_no, 2, 2) == 'u' then
            gauge_list[1] = tonumber(string.sub(self.choice_no, 1, 1))
        else
            gauge_list[1] = -1*tonumber(string.sub(self.choice_no, 1, 1))
        end
 
        if string.sub(self.choice_no, 4, 4) == 'u' then
            gauge_list[2] = tonumber(string.sub(self.choice_no, 3, 3))
        else
            gauge_list[2] = -1*tonumber(string.sub(self.choice_no, 3, 3))
        end
 
        if string.sub(self.choice_no, 6, 6) == 'u' then
            gauge_list[3] = tonumber(string.sub(self.choice_no, 5, 5))
        else
            gauge_list[3] = -1*tonumber(string.sub(self.choice_no, 5, 5))
        end
    end
 
    return gauge_list
   
end
 
function Story:story_string() return self.string end
 
 
function Story:render() end
