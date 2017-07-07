-- Class definition
Paddle = Object:extend()

-- Constructor
function Paddle.new(self)
  width, height = love.graphics.getDimensions()

  self.x = width / 2
  self.y = height - 30

  -- Image definitions
  self.imgPaddleL = love.graphics.newImage("/img/paddle_l.png")
  self.imgPaddleMid = love.graphics.newImage("/img/paddle_mid.png")
  self.imgPaddleR = love.graphics.newImage("/img/paddle_r.png")
end

function Paddle.draw(self)
  love.graphics.draw(self.imgPaddleL, self.x, self.y)
  love.graphics.draw(self.imgPaddleMid, self.x + 10, self.y)
  love.graphics.draw(self.imgPaddleR, self.x + 50, self.y)
end

function Paddle.update(self)
  self.x = love.mouse.getX() - 30
end

function Paddle.getX(self)
  return self.x
end

function Paddle.getY(self)
  return self.y
end

function Paddle.getWidth(self)
  return 60
end
