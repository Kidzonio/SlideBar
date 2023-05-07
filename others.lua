screen = Vector2(guiGetScreenSize());
scale = math.min(math.max (0.5, (screen.y / 1080)), 2);
parent = Vector2((screen.x - (409 * scale)) / 2, (screen.y - (370 * scale)) / 2);
parentWidth, parentHeight = 409*scale, 370*scale;

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

local svgRectangles = {};

function dxDrawSvgRectangle(x, y, w, h, radius, ...)
    if (not svgRectangles[w]) then
        svgRectangles[w] = {}
    end

    if (not svgRectangles[w][h]) then
        svgRectangles[w][h] = {}
    end

    if (not svgRectangles[w][h][radius]) then
        local raw = format([[
            <svg width='%s' height='%s' fill='none'>
                <mask id='path_inside' fill='white' >
                    <rect width='%s' height='%s' rx='%s' />
                </mask>
                <rect width='%s' height='%s' rx='%s' fill='white' mask='url(#path_inside)'/>
            </svg>
        ]], w, h, w, h, radius, w, h, radius)
        svgRectangles[w][h][radius] = svgCreate(w, h, raw, function(e)
            if (not e or not isElement(e)) then 
                return
            end
            dxSetTextureEdge(e, 'border')
        end)
    end

    if (svgRectangles[w][h][radius]) then
        DrawImage(x, y, w, h, svgRectangles[w][h][radius], ...)
    end
end