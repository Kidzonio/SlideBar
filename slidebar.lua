local slideBars = {};

function createSlideBar (id, backGroundX, backGroundY, backGroundW, backGroundH, circleX, circleY, circleW, circleH, colors)
    assert(type(id) == "string", "Bad argument @ createSlideBar at argument 1, expect string got "..type(id));
    assert(type(backGroundX) == "number", "Bad argument @ createSlideBar at argument 2, expect number got "..type(backGroundX));
    assert(type(backGroundY) == "number", "Bad argument @ createSlideBar at argument 3, expect number got "..type(backGroundY));
    assert(type(backGroundW) == "number", "Bad argument @ createSlideBar at argument 4, expect number got "..type(backGroundW));
    assert(type(backGroundH) == "number", "Bad argument @ createSlideBar at argument 5, expect number got "..type(backGroundH));
    assert(type(circleX) == "number", "Bad argument @ createSlideBar at argument 6, expect number got "..type(circleX));
    assert(type(circleY) == "number", "Bad argument @ createSlideBar at argument 7, expect number got "..type(circleY));
    assert(type(circleW) == "number", "Bad argument @ createSlideBar at argument 8, expect number got "..type(circleW));
    assert(type(circleH) == "number", "Bad argument @ createSlideBar at argument 9, expect number got "..type(circleH));
    assert(type(colors) == "table", "Bad argument @ createSlideBar at argument 10, expect table got "..type(colors));
    assert(colors.backGround or colors.circle, "Bad argument @ createSlideBar at argument 10, expected {backGround = {}; circle = {};}");

    if not (slideBars[id]) then
        slideBars[id] = {
            backGroundX = backGroundX;
            backGroundY = backGroundY;
            backGroundW = backGroundW;
            backGroundH = backGroundH;
            circleX = circleX;
            circleY = circleY;
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

    slide.quantity = math.ceil( 1 + (slide.progress / slide.backGroundW * (100 + 2)) ) 

    dxDrawImage(slide.backGroundX, slide.backGroundY, slide.backGroundW, slide.backGroundH, backGround, 0, 0, 0, tocolor(unpack(slide.assets.backGround)));

    dxDrawImageSection(slide.backGroundX, slide.backGroundY, progress_slide, slide.backGroundH, 0, 0, progress_slide, slide.backGroundH, backGround, 0, 0, 0, tocolor(unpack(slide.assets.circle)));

    dxDrawImage((slide.circleX + 1*scale), slide.circleY, slide.circleW, slide.circleH, circle, 0, 0, 0, tocolor(unpack(slide.assets.circle)));

    if (slide.state) then
        if (isCursorShowing()) then
            local c = getCursorPosition();
            if (c) and ((c.x >= slide.backGroundX - slide.circleW / 2) and (c.x <= ((slide.backGroundX + slide.backGroundW) - slide.circleW))) then
                slide.circleX = c.x;
                slide.progress = math.min(math.max(c.x - slide.backGroundX+slide.circleW/4, 0), slide.backGroundW);
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
    for i, v in pairs(slideBars) do
        print(i);
    end
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

addEventHandler('onClientRender', root, function ()
    dxDrawRectangle(parent.x, parent.y, parentWidth, parentHeight, tocolor(53, 56, 70, 255))
    createSlideBar('Teste', parent.x + 12*scale, parent.y + 120*scale, 366*scale, 9*scale, parent.x + 12*scale, parent.y + 117*scale, 15*scale, 15*scale, {backGround = {58, 64, 83, 255}; circle = {2, 156, 242, 255};})
end)