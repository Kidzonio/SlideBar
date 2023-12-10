--[[
    Info:
    Author: Kidzonio
    Github: https://github.com/Kidzonio
    Discord: kidzonio
]]

local min, max, floor, pi = math.min, math.max, math.floor, math.pi;

local screen = Vector2 (guiGetScreenSize ());

slidebar = {};

function slidebar:Create (positions, colors, dataSlide)
    assert (type(positions) == 'table', 'Syntax Error! "slidebar:Create" function expects "positions" argument to be a "table" value. got ' .. type(positions));
    assert (type(colors) == 'table', 'Syntax Error! "slidebar:Create" function expects "colors" argument to be a "table" value. got ' .. type(colors));
    assert (type(dataSlide) == 'table', 'Syntax Error! "slidebar:Create" function expects "dataSlide" argument to be a "table" value. got ' .. type(dataSlide));

    local self = setmetatable ({}, {__index = slidebar});
    
    self.circle = {};
    self.color = {};
    self.x = positions.x;
    self.y = positions.y;
    self.width = positions.w;
    self.height = positions.h;
    self.circle.x = positions.x - 2;
    self.circle.y = positions.y - (positions.circle.h / pi);
    self.circle.w = positions.circle.w;
    self.circle.h = positions.circle.h;
    self.color.background = colors.background;
    self.color.progress = colors.progress;
    self.color.circle = colors.circle;
    self.value = dataSlide.defaultValue ~= dataSlide.minimum and dataSlide.minimum or dataSlide.defaultValue;
    self.minValue = dataSlide.minimum;
    self.maxValue = dataSlide.maximum;
    self.state = false;

    self.circleSVG = svgCreate(positions.circle.w, positions.circle.h, [[
        <svg width=']]..(positions.circle.w)..[[' height=']]..(positions.circle.h)..[['>
        <circle cx=']]..(positions.circle.w/2)..[[' cy=']]..(positions.circle.h/2)..[[' r=']]..(positions.circle.w/2)..[[' fill='white'/>
        </svg>
    ]])

    return self;
end

function slidebar:render ()
    local progress = (self.value - self.minValue) / (self.maxValue - self.minValue);
    local valueX = self.x + (progress * (self.width - self.circle.w));
    
    dxDrawRectangle (self.x, self.y, self.width, self.height, self.color.background);
    dxDrawRectangle (self.x, self.y, (self.width/1*progress), self.height, self.color.progress);
    dxDrawImage(valueX, self.circle.y, self.circle.w, self.circle.h, self.circleSVG, 0, 0, 0, self.color.circle);

    if (self.state) then
        local cursor = getCursorPosition ();
        local absoluteX = cursor * screen.x;
        local value = absoluteX - (self.dgOffsetX or 0);
        value = max(self.x, min (value, self.x + self.width - self.circle.w));
        local _progress = (value - self.x) / (self.width - self.circle.w);
        self.value = self.minValue + _progress * (self.maxValue - self.minValue);
    end

end

function slidebar:setValue (newValue)
    if not (newValue) then
        return error ('Syntax Error! "slidebar:setValue" function expects "newValue" argument to be a "number" value. got ' .. type(newValue));
    end
    self.value = min(max(newValue, self.minValue), self.maxValue);
end

function slidebar:getValue ()
    return (floor(self.value));
end

function slidebar:click (button, state, absoluteX, absoluteY)
    if (button == 'left' and state == 'down') then
        local value = self.circle.x + ((self.value - self.minValue) / (self.maxValue - self.minValue)) * (self.width - self.circle.w)
        if absoluteX >= value and absoluteX <= value + self.circle.w and absoluteY >= self.y and absoluteY <= self.y + self.circle.h then
            self.dgOffsetX = absoluteX - value;
            self.state = true;
            return true;
        end
        if ((absoluteX > self.x and absoluteX < (self.x + self.width)) and (absoluteY > self.y and absoluteY < (self.y + self.height))) then
            _value = max(self.x, min(absoluteX, self.x + self.width - self.circle.w));
            local _progress = (_value - self.x) / (self.width - self.circle.w);
            self.value = self.minValue + _progress * (self.maxValue - self.minValue);
            self.state = true;
            return true;
        end
    elseif (button == 'left' and state == 'up') then
        self.state = false;
        return false;
    end
end

---- Example

local slide = slidebar:Create (
    {
        x = 815;
        y = 543;
        w = 285;
        h = 5;
        circle = {
            w = 12;
            h = 12;
        };
    },
    {
        background = tocolor(30, 30, 30, 255),
        progress = tocolor(147, 227, 84, 255),
        circle = tocolor(255, 255, 255, 255),
    },
    {
        minimum = 0,
        maximum = 7,
        defaultValue = 0,
    }
);

addEventHandler ('onClientRender', root, function ()
    slide:render();
    dxDrawText (slide:getValue(), 600, 300, 300, 300, tocolor (255, 255, 255, 255), 3);
end)

addEventHandler ('onClientClick', root, function (button, state, absoluteX, absoluteY)
    slide:click (button, state, absoluteX, absoluteY);
end)