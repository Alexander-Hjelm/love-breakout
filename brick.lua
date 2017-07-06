-- Class definition
Brick = Object:extend()

function Brick.new(self, x, y, col)
  self:new(x, y, col[0], col[1], col[2])
end

-- Constructor
function Brick.new(self, x, y, red, green, blue)
  self.x = x
  self.y = y
  self.red = red
  self.green = green
  self.blue = blue

  -- Image definitions
  self.imgBrick = love.graphics.newImage("brick.png")
end



function Brick.draw(self)
  love.graphics.setColor(self.red, self.green, self.blue)
  love.graphics.draw(self.imgBrick, self.x, self.y)
end
