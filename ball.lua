-- Class definition
Ball = Object:extend()

-- Constructor
function Ball.new(self, x, y)
  self.x = x
  self.y = y

  self.v = 300
  self.theta = 0.3

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
  end
  if self.x <= 0 then
    self.theta = math.pi - self.theta
  end
  if self.x + 16 >= width then
    self.theta = - math.pi - self.theta
  end
  if self.y + 16 >= height then
    love.event.quit()
  end
end
