-- Class definition
Paddle = Object:extend()

-- Constructor
function Paddle.new(self)
  self.x = 10
  self.y = 10

  -- Image definitions
  self.imgPaddleL = love.graphics.newImage("paddle_l.png")
  self.imgPaddleMid = love.graphics.newImage("paddle_mid.png")
  self.imgPaddleR = love.graphics.newImage("paddle_r.png")
end

function Paddle.draw(self)
  love.graphics.draw(self.imgPaddleL, self.x, self.y)
  love.graphics.draw(self.imgPaddleMid, self.x + 10, self.y)
  love.graphics.draw(self.imgPaddleR, self.x + 50, self.y)
end
