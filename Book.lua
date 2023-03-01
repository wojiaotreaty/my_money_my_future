--[[
    Book class
 
    creates a table that sorts and distributes random Story object
]]
require 'stories'
--------------------------------------------------------------------
function inTable(tbl, item)
    for key, value in pairs(tbl) do
        if value == item then return true end
    end
    return false
end
 
 
--------------------------------------------------------------------
 
Book = Class{}
 
function Book:init(path, pathcopy)
    self.path = pathcopy
    self.unused = path
    self.used = {}
end
 
function Book:list()
    return self.unused
end
 
function Book:reset()
   
    for i, choice in ipairs(self.unused) do
        self.unused[i] = nil
    end
 
    for i, choice in ipairs(self.path) do
        table.insert(self.unused, choice)
    end
 
    self.used = {}
end
 
function Book:random_story()
 
    index = math.random(1, table.getn(self.unused))
    while inTable(self.used, self.unused[index]) == true do
        index = math.random(1, table.getn(self.unused))
    end
 
    if table.getn(self.used) == table.getn(self.unused)-1 then
        self.used = {}
    end
    cStory = self.unused[index]
    table.insert(self.used, cStory)
 
    return Story(cStory)
   
end
 
function Book:random_funfact()
   
    index = math.random(1, table.getn(self.unused))
    while inTable(self.used, self.unused[index]) == true do
        index = math.random(1, table.getn(self.unused))
    end
 
    if table.getn(self.used) == table.getn(self.unused)-1 then
        self.used = {}
    end
 
    funfact = self.unused[index]
    table.insert(self.used, funfact)
 
    return funfact
   
end
 
function Book:merge_books(book)
    for i, choice in ipairs(book) do
        table.insert(self.unused, choice)
    end
end
 
function Book:update(dt) end
 
function Book:render() end
 
 
 
 
 
 
 
 
