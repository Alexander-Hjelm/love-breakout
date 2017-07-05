-- Class definition
Ball = Object:extend()

-- Constructor
function Ball.new(self, x, y, paddle)
  self.x = x
  self.y = y

  self.v = 400
  self.theta = 1.3

  self.paddle = paddle

  -- Image definitions
  self.imgBall = love.graphics.newImage("ball.png")
end

function Ball.draw(self)
  love.graphics.draw(self.imgBall, self.x, self.y)
end

function Ball.update(self, dt)
  self:checkCollision()
  self.x = self.x + self.v * math.cos(self.theta) * dt
  self.y = self.y + self.v * math.sin(self.theta) * dt
end

function Ball.checkCollision(self)
  width, height = love.graphics.getDimensions()
  if self.y <= 0 then
    self.theta = -self.theta
    self.y = 0
  end
  if self.x <= 0 then
    self.theta = math.pi - self.theta
    self.x = 0
  end
  if self.x + 16 >= width then
    self.theta = - math.pi - self.theta
    self.x = width - 16
  end
  if self.y + 16 >= height then
    love.event.quit()
  end

  -- Collision check with paddle
  if self.y + 16 >= self.paddle:getY() then
    if self.x > self.paddle:getX() and self.x < self.paddle:getX() + self.paddle:getWidth() then
      self.theta = - self.theta
      self.y = self.paddle:getY() - 16
    end
  end
end
