local min, max, floor = math.min, math.max, math.floor;

slidebar = {};

function slidebar:Create (positions, colors, dataSlide)
    assert (type(positions) == 'table', 'Syntax Error! "slidebar:Create" function expects "positions" argument to be a "table" value. got ' .. type(positions));
    assert (type(colors) == 'table', 'Syntax Error! "slidebar:Create" function expects "colors" argument to be a "table" value. got ' .. type(colors));
    assert (type(dataSlide) == 'table', 'Syntax Error! "slidebar:Create" function expects "dataSlide" argument to be a "table" value. got ' .. type(dataSlide));

    local self = setmetatable ({}, {__index = slidebar});


    self.x = positions.x;
    self.y = positions.y;
    self.width = positions.w;
    self.height = positions.h;
    self.circle = {};
    self.circle.x = positions.circle.x;
    self.circle.y = positions.circle.y;
    self.circle.w = positions.circle.w;
    self.circle.h = positions.circle.h;
    self.color = {};
    self.color.background = colors.background;
    self.color.progress = colors.progress;
    self.color.circle = colors.circle;
    self.state = false;
    self.value = dataSlide.defaultValue;
    self.minValue = dataSlide.minimum;
    self.maxValue = dataSlide.maximum;
    self.radius = dataSlide.radius;

    self.circleSVG = svgCreate(positions.circle.w, positions.circle.h, [[
        <svg width="]]..(positions.circle.w)..[[" height="]]..(positions.circle.h)..[[">
        <circle cx="]]..(positions.circle.w/2)..[[" cy="]]..(positions.circle.h/2)..[[" r="]]..(positions.circle.w/2)..[[" fill="white"/>
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
end

function slidebar:setValue (newValue)
    self.value = min(max(newValue, self.minValue), self.maxValue);
end

function slidebar:getValue ()
    return (floor(self.value));
end

function slidebar:click (button, state, absoluteX, absoluteY)
    if (button == "left" and state == "down") then
        local value = self.circle.x + ((self.value - self.minValue) / (self.maxValue - self.minValue)) * (self.width - self.circle.w)
        if absoluteX >= value and absoluteX <= value + self.circle.w and absoluteY >= self.y and absoluteY <= self.y + self.circle.h then
            self.state = true;
            self.dgOffsetX = absoluteX - value;
        end
    elseif (button == "left" and state == "up") then
        self.state = false;
    end
end

function slidebar:mouseMove (absoluteX, absoluteY)
    if (self.state) then
        local value = absoluteX - self.dgOffsetX;
        value = max(self.x, min(value, self.x + self.width - self.circle.w));
        local progress = (value - self.x) / (self.width - self.circle.w);
        self.value = self.minValue + progress * (self.maxValue - self.minValue);
    end
end

---- Example

local slide = slidebar:Create (
    {
        x = 815;
        y = 543;
        w = 285;
        h = 5;
        radius = 5;
        circle = {
            x = 813;
            y = 540;
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
    dxDrawText (slide:getValue(), 300, 300, 300, 300);
end)

addEventHandler ('onClientClick', root, function (button, state, absoluteX, absoluteY)
    slide:click (button, state, absoluteX, absoluteY);
end)

addEventHandler ('onClientCursorMove', root, function (_, _, absoluteX, absoluteY)
    slide:mouseMove (absoluteX, absoluteY);
end)