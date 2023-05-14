circle = svgCreate(15, 15, [[
    <svg width="15" height="15">
        <circle cx="7.5" cy="7.5" r="7.5" fill="white"/>
    </svg>
]])

backGround = svgCreate(366, 9, [[
    <svg width="366" height="9">
        <rect width="366" height="9" rx="4.5" fill="white"/>
    </svg>
]])

local slideBars = {};

function createSlideBar (id, backGroundX, backGroundY, backGroundW, backGroundH, circleW, circleH, colors)
    assert(type(id) == "string", "Bad argument @ createSlideBar at argument 1, expect string got "..type(id));
    assert(type(backGroundX) == "number", "Bad argument @ createSlideBar at argument 2, expect number got "..type(backGroundX));
    assert(type(backGroundY) == "number", "Bad argument @ createSlideBar at argument 3, expect number got "..type(backGroundY));
    assert(type(backGroundW) == "number", "Bad argument @ createSlideBar at argument 4, expect number got "..type(backGroundW));
    assert(type(backGroundH) == "number", "Bad argument @ createSlideBar at argument 5, expect number got "..type(backGroundH));
    assert(type(circleW) == "number", "Bad argument @ createSlideBar at argument 6, expect number got "..type(circleW));
    assert(type(circleH) == "number", "Bad argument @ createSlideBar at argument 7, expect number got "..type(circleH));
    assert(type(colors) == "table", "Bad argument @ createSlideBar at argument 8, expect table got "..type(colors));
    assert(colors.backGround or colors.circle, "Bad argument @ createSlideBar at argument 8, expected {backGround = {}; circle = {};}");

    if not (slideBars[id]) then
        slideBars[id] = {
            backGroundX = backGroundX;
            backGroundY = backGroundY;
            backGroundW = backGroundW;
            backGroundH = backGroundH;
            circleX = backGroundX - circleW / 2;
            circleY = backGroundY;
            circleW = circleW;
            circleH = circleH;
            assets = colors;
            state = false;
            tick = getTickCount();
            progress = 0;
            quantity = 0;
        };
    end

    local slide = slideBars[id];
    local progress_slide = interpolateBetween(0, 0, 0, slide.progress, 0, 0, (getTickCount() - slide.tick) / 550, 'Linear');
    
    dxDrawImage(slide.backGroundX, slide.backGroundY, slide.backGroundW, slide.backGroundH, backGround, 0, 0, 0, slide.assets.backGround);
    
    dxDrawImageSection(slide.backGroundX, slide.backGroundY, progress_slide, slide.backGroundH, 0, 0, progress_slide, slide.backGroundH, backGround, 0, 0, 0, slide.assets.circle);
    
    dxDrawImage((slide.circleX + 1*scale), slide.circleY - pi / 2, slide.circleW, slide.circleH, circle, 0, 0, 0, slide.assets.circle);
    
    if (slide.state) then
        if (isCursorShowing()) then
            local c = getCursorPosition();
            if (c) and ((c.x >= slide.backGroundX - slide.circleW / 2) and (c.x <= ((slide.backGroundX + slide.backGroundW) - slide.circleW))) then
                slide.circleX = c.x;
                slide.progress = min(max(c.x - slide.backGroundX+slide.circleW / 4, 0), slide.backGroundW);
                slide.quantity = ceil(1 + (slide.progress / slide.backGroundW * (100 + 2)));
            end
        end
    end
end

function deleteSlideBar (id)
    if not (slideBars[id]) then
        return false;
    end
    slideBars[id] = nil;
    return true;
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

function eventsSlideBar (...)
    if (getIndexTable(slideBars) == 0) then
        return false;
    end
    if (eventName == 'onClientClick') then
        local button, state = arg[1], arg[2];
        if (button == 'left' and state == 'down') then
            for id, values in pairs(slideBars) do
                if (isCursorInPosition(values.circleX, values.circleY, values.circleW, values.circleH)) then
                     if not (slideBars[id].state) then
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


addEventHandler('onClientRender', root, function ()
    dxDrawRectangle(parent.x, parent.y, parentWidth, parentHeight, tocolor(53, 56, 70, 255));
    createSlideBar('Teste', parent.x + 12*scale, parent.y + 120*scale, 369*scale, 9*scale, 15*scale, 15*scale, {backGround = tocolor(58, 64, 83, 255), circle = tocolor(2, 156, 242, 255)});
    dxDrawText(getSlideBarProgress('Teste'), parent.x + parentWidth / 2, parent.y + parentHeight / 2, 366*scale, 9*scale, tocolor(255, 255, 255, 255), 1.0, 'default', 'left', 'top');
end)
