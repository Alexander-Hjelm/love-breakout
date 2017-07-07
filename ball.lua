-- Class definition
Ball = Object:extend()

-- Constructor
function Ball.new(self, paddle, bricks)
  self:reset()

  self.width = 16
  self.height = 16

  self.v = 400

  self.paddle = paddle
  self.bricks = bricks

  -- Image definitions
  self.imgBall = love.graphics.newImage("ball.png")
end

function Ball.draw(self)
  love.graphics.draw(self.imgBall, self.x, self.y)
end

function Ball.update(self, dt)
  self.x = self.x + self.v * math.cos(self.theta) * dt
  self.y = self.y + self.v * math.sin(self.theta) * dt
end

function Ball.checkCollision(self, combo, lives)
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
    lives = lives - 1
    if lives == 0 then
      love.event.quit()
    end
    self:reset()
    -- self.theta = -self.theta --cheat
  end

  -- Collision check with paddle
  if self.y + 16 >= self.paddle:getY() then
    if self.x > self.paddle:getX() and self.x < self.paddle:getX() + self.paddle:getWidth() then
      -- Add spin
      local spin = 1 - (self.x - self.paddle:getX())/self.paddle:getWidth()
      -- local newTheta = - self.theta + math.pi * spin
      local newTheta = - math.pi * spin
      self.theta = math.max(math.min(newTheta, -0.14), -3)
      print(spin)



      self.y = self.paddle:getY() - 16
      combo = 1
    end
  end

  return combo, lives
end

function Ball.checkBricksCollision(self, score, combo)
  local collided = false

  for i=1,#bricks do
    local brick = bricks[i]

    local ball_left = self.x
    local ball_right = self.x + self.width
    local ball_top = self.y
    local ball_bottom = self.y + self.height

    local brick_left = brick.x
    local brick_right = brick.x + brick.width
    local brick_top = brick.y
    local brick_bottom = brick.y + brick.height

    if not brick.destroyed and
    --If Red's right side is further to the right than Blue's left side.
    ball_right > brick_left and
    --and Red's left side is further to the left than Blue's right side.
    ball_left < brick_right and
    --and Red's bottom side is further to the bottom than Blue's top side.
    ball_bottom > brick_top and
    --and Red's top side is further to the top than Blue's bottom side then..
    ball_top < brick_bottom then
        --There is collision!
      brick:setDestroyed(true)
        --If one of these statements is false, return false.

      -- Rebound
      local ball_center_x = self.x + self.width/2
      local ball_center_y = self.y + self.height/2

      local brick_center_x = brick.x + brick.width/2
      local brick_center_y = brick.y + brick.height/2

      local dist_x = ball_center_x - brick_center_x
      local dist_y = ball_center_y - brick_center_y

      local theta = math.atan(dist_y/dist_x)

      if (not collided) and math.abs(theta) <= .464 and dist_x > 0 then
        self.theta = - math.pi - self.theta
        collided = true
        score = score + 10 * combo
        combo = combo + 0.5
      end

      if (not collided) and math.abs(theta) <= .464 and dist_x < 0 then
        self.theta = math.pi - self.theta
        collided = true
        score = score + 10 * combo
        combo = combo + 0.5
      end

      if (not collided) and math.abs(theta) > .464 and dist_y > 0 then
        self.theta = -self.theta
        collided = true
        score = score + 10 * combo
        combo = combo + 0.5
      end

      if (not collided) and math.abs(theta) > .464 and dist_y < 0 then
        self.theta = -self.theta
        collided = true
        score = score + 10 * combo
        combo = combo + 0.5
      end

    end
  end

  return score, combo
end

function Ball.reset(self)
  self.x = 400
  self.y = 500

  self.theta = -0.785
end
