-- Class definition
Ball = Object:extend()

-- Constructor
function Ball.new(self, paddle, bricks, sounds)
  self:reset() -- Reset ball position and angle

  -- Geometry definitions
  self.width = 16
  self.height = 16
  self.v = 400

  -- Object references
  self.paddle = paddle
  self.bricks = bricks
  self.sounds = sounds

  -- Image definitions
  self.imgBall = love.graphics.newImage("/img/ball.png")
end

function Ball.draw(self)
  love.graphics.draw(self.imgBall, self.x, self.y)
end

function Ball.update(self, dt)
  -- Update position on screen
  self.x = self.x + self.v * math.cos(self.theta) * dt
  self.y = self.y + self.v * math.sin(self.theta) * dt
end

-- Collision check with paddle and screen edges. Lives and combo may be modified
function Ball.checkCollision(self, combo, lives)
  width, height = love.graphics.getDimensions() -- Screen dimensions
  -- Top of screen
  if self.y <= 0 then
    self.theta = -self.theta
    self.y = 0
    sounds["hit_brick"]:play()
  end
  -- Left of Screen
  if self.x <= 0 then
    self.theta = math.pi - self.theta
    self.x = 0
    sounds["hit_brick"]:play()
  end
  -- Right of screen
  if self.x + 16 >= width then
    self.theta = - math.pi - self.theta
    self.x = width - 16
    sounds["hit_brick"]:play()
  end
  -- Bottom of screen
  if self.y + 16 >= height then
    -- Player has failed
    lives = lives - 1
    if lives == 0 then
      love.event.quit() -- Quit if all lives are gone
    end
    self:reset() -- Reset ball position and angle
    combo = 1
    sounds["death"]:play()

    -- Enable this line, and disable "lives = lives - 1" to cheat
    -- self.theta = -self.theta
  end

  -- Collision check with paddle
  if self.y + 16 >= self.paddle:getY() then
    if self.x > self.paddle:getX() and self.x < self.paddle:getX() + self.paddle:getWidth() then
      -- Add spin
      local spin = 1 - (self.x - self.paddle:getX())/self.paddle:getWidth()
      local newTheta = - math.pi * spin
      self.theta = math.max(math.min(newTheta, -0.14), -3)

      -- Move the ball to the edge of the paddle to eliminate further interference
      self.y = self.paddle:getY() - 16
      combo = 1 -- reset combo counter
      sounds["hit_paddle"]:play()
    end
  end

  return combo, lives
end

-- Collision check with bricks. Score and combo may be modified
function Ball.checkBricksCollision(self, score, combo)
  local collided = false -- Has the ball collided with any brick this frame?

  -- For every brick in the level, do
  for i=1,#bricks do
    local brick = bricks[i]

    -- Geometry definitions
    local ball_left = self.x
    local ball_right = self.x + self.width
    local ball_top = self.y
    local ball_bottom = self.y + self.height

    local brick_left = brick.x
    local brick_right = brick.x + brick.width
    local brick_top = brick.y
    local brick_bottom = brick.y + brick.height

    -- Do the collision check
    if not brick.destroyed and ball_right > brick_left and
    ball_left < brick_right and ball_bottom > brick_top and
    ball_top < brick_bottom then
        -- There was collision with the brick
      brick:setDestroyed(true)

      -- Calculate in which direction the ball should go after bouncing
      -- Geometry definitions
      local ball_center_x = self.x + self.width/2
      local ball_center_y = self.y + self.height/2

      local brick_center_x = brick.x + brick.width/2
      local brick_center_y = brick.y + brick.height/2

      local dist_x = ball_center_x - brick_center_x
      local dist_y = ball_center_y - brick_center_y

      local theta = math.atan(dist_y/dist_x)

      -- Ball is right of brick
      if (not collided) and math.abs(theta) <= .464 and dist_x > 0 then
        self.theta = - math.pi - self.theta
        collided = true
        score = score + 10 * combo
        combo = combo + 0.5
      end

      -- Ball is left of brick
      if (not collided) and math.abs(theta) <= .464 and dist_x < 0 then
        self.theta = math.pi - self.theta
        collided = true
        score = score + 10 * combo
        combo = combo + 0.5
      end

      -- Ball is above brick
      if (not collided) and math.abs(theta) > .464 and dist_y > 0 then
        self.theta = -self.theta
        collided = true
        score = score + 10 * combo
        combo = combo + 0.5
      end

      -- Ball is below brick
      if (not collided) and math.abs(theta) > .464 and dist_y < 0 then
        self.theta = -self.theta
        collided = true
        score = score + 10 * combo
        combo = combo + 0.5
      end
      sounds["hit_brick"]:play()
    end
  end

  return score, combo
end

-- Reset ball position and angle
function Ball.reset(self)
  self.x = 400
  self.y = 500

  self.theta = -0.785
end
