-- source: extensions/car_instruments/scriptable_display.cpp
-- namespace: carscriptabledisplay

ffi.cdef [[ DEFINITIONS ]]
EXPORT

car = nil
sim = nil
function __init__()
  car = ac.getCarState(__carindex__)
  sim = ac.getSimState()
end

display = {}

function display.rect(params)
  local pos = params.pos      -- rect position
  local size = params.size    -- rect size
  local color = params.color  -- rect color
  ac.uiDrawRectFilled(pos, pos + size, color)
end

function display.image(params)
  local image = params.image      -- image source
  local pos = params.pos          -- image position
  local size = params.size        -- image size
  local color = params.color      -- image tint
	local uvStart = params.uvStart  -- UV for upper left corner, optional
	local uvEnd = params.uvEnd      -- UV for bottom right corner, optional
  ac.uiDrawImage(image, pos, pos + size, color, uvStart, uvEnd)
end

function display.text(params)
  local text = tostring(params.text)   -- text to draw
  local pos = params.pos               -- text position, optional
  local letter = params.letter         -- size of each letter
  local font = params.font             -- name of font, optional
  local color = params.color           -- color, optional
  local width = params.width or 0      -- width, optional
  local alignment = params.alignment   -- alignment, optional (0.5 for center, 1 for right)
  local spacing = params.spacing or 0  -- extra spacing between letters

  local textLen = #text
  if textLen == 0 then return end
  
  local actualWidth = letter.x * textLen + (textLen > 0 and spacing * (textLen - 1) or 0)
  if width > actualWidth then
    pos.x = pos.x + (width - actualWidth) * alignment
  end

  if font ~= nil then ac.uiPushACFont(font) end
  if pos ~= nil then ac.uiSetCursor(pos) end  
  ac.uiACText(text, letter, spacing, color)
  if font ~= nil then ac.uiPopACFont() end
end