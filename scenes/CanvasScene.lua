local CanvasScene = {}

local plateCanvas
local dirtCanvas
local brush
local plate
local size
local mode = 'paint'

local CURSOR_COLOR_PAINT = { 0.6, 0, 0, 0.8 }
local CURSOR_COLOR_CLEAN = { 0.2, 0.2, 0.5, 0.8 }
local CURSOR_SCALE = 3

function CanvasScene:load(config)
    config.title = 'canvas'
    
    -- love.graphics.setColor(1, 1, 1, 1)

    plate = love.graphics.newImage('assets/plate128.png')
    brush = love.graphics.newImage('assets/brush8.png')
    size = plate:getWidth()
    plateCanvas = love.graphics.newCanvas(size, size)
    dirtCanvas = love.graphics.newCanvas(size, size)

    love.mouse.setVisible(false)
    love.mouse.setGrabbed(true)

    love.graphics.setCanvas(plateCanvas)
        love.graphics.clear()
        love.graphics.setBlendMode('alpha')
        love.graphics.draw(plate, 0, 0, 0, 1, 1)
    love.graphics.setCanvas()
end

function CanvasScene:update(dt)
    if love.mouse.isDown(1) then
        local mx, my = love.mouse.getPosition()
        local cx, cy = WINDOW_WIDTH / 2 - size / 2 - size, WINDOW_HEIGHT / 2 - size / 2
        local x, y = mx - cx, my - cy

        -- love.graphics.setColor(1, 1, 1, 1)

        love.graphics.setCanvas(dirtCanvas)
        if mode == 'paint' then
            love.graphics.setBlendMode('add')
            love.graphics.draw(brush, x, y, 0, CURSOR_SCALE, CURSOR_SCALE)
        elseif mode == 'clean' then
            love.graphics.setBlendMode('subtract')
            love.graphics.draw(brush, x, y, 0, CURSOR_SCALE, CURSOR_SCALE)
        end
        love.graphics.setCanvas()
    end
end

function CanvasScene:keypressed(key)
    if key == 'c' then
        mode = 'clean'
    elseif key == 'p' then
        mode = 'paint'
    end
end

function CanvasScene:draw()
    local blendMode = love.graphics.getBlendMode()
    local r, g, b, a = love.graphics.getColor()

    love.graphics.setBlendMode('add')
    love.graphics.draw(plateCanvas, WINDOW_WIDTH / 2 - size / 2 - size, WINDOW_HEIGHT / 2 - size / 2)
    
    love.graphics.setBlendMode('alpha')
    love.graphics.draw(plateCanvas, WINDOW_WIDTH / 2 - size / 2, WINDOW_HEIGHT / 2 - size / 2)
 
    love.graphics.setBlendMode('subtract')
    -- love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.draw(plateCanvas, WINDOW_WIDTH / 2 - size / 2 + size, WINDOW_HEIGHT / 2 - size / 2)

    love.graphics.setBlendMode(blendMode)
    -- love.graphics.setColor(r, g, b, a)

    -- render cursor
    local x, y = love.mouse.getPosition()
    -- love.graphics.setColor(mode == 'paint' and CURSOR_COLOR_PAINT or CURSOR_COLOR_CLEAN)
    love.graphics.draw(brush, x, y, 0, CURSOR_SCALE, CURSOR_SCALE)
end

return CanvasScene