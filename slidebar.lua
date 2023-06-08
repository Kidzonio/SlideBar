screen = Vector2(guiGetScreenSize());
scale = math.min(math.max (0.5, (screen.y / 1080)), 2);
ceil, min, max, pi = math.ceil, math.min, math.max, math.pi;

circle = svgCreate(15, 15, [[
    <svg width="15" height="15">
        <circle cx="7.5" cy="7.5" r="7.5" fill="white"/>
    </svg>
]])

local slideBars = {};

function createSlideBar (id, backGroundX, backGroundY, backGroundW, backGroundH, radiusScale, minValue, maxValue, colors)
    assert(type(id) == "string", "Bad argument @ createSlideBar at argument 1, expect string got "..type(id));
    assert(type(backGroundX) == "number", "Bad argument @ createSlideBar at argument 2, expect number got "..type(backGroundX));
    assert(type(backGroundY) == "number", "Bad argument @ createSlideBar at argument 3, expect number got "..type(backGroundY));
    assert(type(backGroundW) == "number", "Bad argument @ createSlideBar at argument 4, expect number got "..type(backGroundW));
    assert(type(backGroundH) == "number", "Bad argument @ createSlideBar at argument 5, expect number got "..type(backGroundH));
    assert(type(radiusScale) == "number", "Bad argument @ createSlideBar at argument 6, expect number got "..type(radiusScale));
    assert(type(minValue) == "number", "Bad argument @ createSlideBar at argument 7, expect number got "..type(minValue));
    assert(type(maxValue) == "number", "Bad argument @ createSlideBar at argument 8, expect number got "..type(maxValue));
    assert(type(colors) == "table", "Bad argument @ createSlideBar at argument 9, expect table got "..type(colors));
    assert(colors.backGround or colors.circle or colors.progress, "Bad argument @ createSlideBar at argument 9, expected {backGround = {}; circle = {};}");

    if not (slideBars[id]) then
        slideBars[id] = {
            backGroundX = backGroundX,
            backGroundY = backGroundY,
            backGroundW = backGroundW,
            backGroundH = backGroundH,
            circleX = backGroundX - radiusScale / 2,
            circleY = backGroundY + ((backGroundH / 2) - (radiusScale / 2)),
            radiusScale = radiusScale,
            minValue = minValue,
            maxValue = maxValue,
            assets = colors,
            state = false,
            tick = getTickCount(),
            progress = 0,
            quantity = 0,
            blocked = false,
            showing = true
        };
    end

    local slide = slideBars[id];
    local progress_slide = interpolateBetween(0, 0, 0, slide.progress, 0, 0, (getTickCount() - slide.tick) / 550, 'Linear');
    
    if (slide.showing) then
        dxDrawRectangle(slide.backGroundX, slide.backGroundY, slide.backGroundW, slide.backGroundH, slide.assets.backGround);
        
        dxDrawRectangle(slide.backGroundX, slide.backGroundY, progress_slide, slide.backGroundH, slide.assets.progress);
        
        dxDrawImage((slide.circleX + 1*scale), slide.circleY, slide.radiusScale, slide.radiusScale, circle, 0, 0, 0, slide.assets.circle);
        
        if (slide.state and not slide.blocked) then
            if (isCursorShowing()) then
                local c = getCursorPosition();
                if (c) and ((c.x >= slide.backGroundX - slide.radiusScale / 2) and (c.x <= ((slide.backGroundX + slide.backGroundW) - slide.radiusScale))) then
                    slide.circleX = c.x;
                    slide.progress = min(max(c.x - slide.backGroundX + slide.radiusScale / 4, 0), slide.backGroundW);
                    slide.quantity = ceil(slide.minValue + (slide.progress / slide.backGroundW * (slide.maxValue + (slide.maxValue / 50) + (slide.minValue == 0 and (slide.maxValue > 99 and 1 or 0) or 0) + (slide.maxValue ~= 100 and math.floor((slide.maxValue / 100)) or 0)))); 
                end
            end
        end
    end
end

---- ! SlideBar Functions !

function deleteSlideBar (id)
    if not (slideBars[id]) then
        return false;
    end
    slideBars[id] = nil;
    return true;
end

function deleteAllSlideBars()
    for i in pairs(slideBars) do
        slideBars[i] = nil;
    end
end

function getAllSlideBars ()
    local sb = {};
    for i, v in pairs(slideBars) do
        table.insert(sb, #sb + 1, i);
    end
    return sb;
end

function getSlideBarProgress (id)
    if (slideBars[id]) then
        return slideBars[id].quantity;
    end
end

function setSlideBarBlocked(id, state)
    if (slideBars[id]) then
        slideBars[id].blocked = (state and state or not slideBars[id].blocked);
    end
end

function setSlideBarShowing(id, state)
    if (slideBars[id]) then
        slideBars[id].showing = (state and state or not slideBars[id].showing);
    end
end

---- Events SlideBar 

function eventsSlideBar (...)
    if (getIndexTable(slideBars) == 0) then
        return false;
    end
    if (eventName == 'onClientClick') then
        local button, state = arg[1], arg[2];
        if (button == 'left' and state == 'down') then
            for id, values in pairs(slideBars) do
                if (isCursorInPosition(values.circleX, values.circleY, values.radiusScale, values.radiusScale)) then
                     if not (slideBars[id].state and slideBars[id].blocked) then
                        slideBars[id].state = true;
                     end   
                end
            end
            return true;
        end
        if (button == 'left' and state == 'up') then
            for id in pairs(slideBars) do
                if (slideBars[id].state) then
                    slideBars[id].state = false;
                end   
            end
            return true;
        end
        return true;
    end
end
addEventHandler('onClientClick', root, eventsSlideBar);

------- Example

parent = Vector2((screen.x - (409 * scale)) / 2, (screen.y - (370 * scale)) / 2);
parentWidth, parentHeight = 409*scale, 370*scale;

addEventHandler('onClientRender', root, function ()
    dxDrawRectangle(parent.x, parent.y, parentWidth, parentHeight, tocolor(53, 56, 70, 255));
    createSlideBar('Teste', parent.x + 12*scale, parent.y + 120*scale, 369*scale, 9*scale, 30*scale, 0, 155, {backGround = tocolor(255, 255, 255, 255), circle = tocolor(255, 255, 255, 255), progress = tocolor(2, 156, 242, 255)});
    createSlideBar('Teste2', parent.x + 12*scale, parent.y + 320*scale, 369*scale, 9*scale, 15*scale, 1, 200, {backGround = tocolor(58, 64, 83, 255), circle = tocolor(255, 255, 255, 255), progress = tocolor(2, 156, 242, 255)});
    dxDrawText(getSlideBarProgress('Teste'), parent.x + parentWidth / 2, parent.y + parentHeight / 2, 366*scale, 9*scale, tocolor(255, 255, 255, 255), 1.0, 'default', 'left', 'top');
end)

-- Utils

_getCursorPosition = getCursorPosition
function getCursorPosition()
    if (not isCursorShowing()) then
		return false;
	end
	local cursor = Vector2(_getCursorPosition());
	local cursor = Vector2((cursor.x * screen.x), (cursor.y * screen.y));
	
	return cursor;
end

function getIndexTable(table)
    local count = 0;
    for _, v in pairs(table) do
        count = count + 1;
    end
    return count;
end

function isCursorInPosition(x, y, w, h)
    if (not isCursorShowing()) then
		return false;
	end
	local cursor = Vector2(_getCursorPosition());
	local cursor = Vector2((cursor.x * screen.x), (cursor.y * screen.y));
	
	return ((cursor.x >= x and cursor.x <= x + w) and (cursor.y >= y and cursor.y <= y + h));
end