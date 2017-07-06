Object = require("classic")
require("paddle")
require("ball")
require("brick")

-- Color definitions
rCol = {255, 30, 30}
gCol = {30, 255, 30}
bCol = {30, 30, 255}
cCol = {30, 255, 255}
mCol = {255, 30, 255}
yCol = {255, 255, 30}

-- level definitions
bricks = {}


local paddle
local ball

local score = 0
local combo = 1

function love.load()
  paddle = Paddle()
  ball = Ball(100, 100, paddle, bricks)
  loadLevel()
end

function love.draw()
  for i=1,#bricks do
    bricks[i]:draw()
  end

  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.setFont(love.graphics.newFont(18))
  love.graphics.print("Löve Breakout", 10, 10)
  love.graphics.print("Score: " .. score, 10, 30)
  love.graphics.print("Combo: " .. combo, 10, 50)
  paddle:draw()
  ball:draw()
end

function love.update(dt)
  paddle:update()
  ball:update(dt)
  combo = ball:checkCollision(combo)
  score, combo = ball:checkBricksCollision(score, combo)
end

function loadLevel()
  -- Load level
  --str = love.filesystem.read("level1.csv")
  local x = 0
  local y = 0

  for line in love.filesystem.lines("level1.csv") do

    for i=1, #line do
      local char = string.sub(line, i, i)

      if (char == "r") then
        table.insert(bricks, Brick(40*x, 20*y, rCol))
        x = x + 1
      end

      if (char == "b") then
        table.insert(bricks, Brick(40*x, 20*y, bCol))
        x = x + 1
      end

      if (char == "c") then
        table.insert(bricks, Brick(40*x, 20*y, cCol))
        x = x + 1
      end

      if (char == "g") then
        table.insert(bricks, Brick(40*x, 20*y, gCol))
        x = x + 1
      end

      if (char == "m") then
        table.insert(bricks, Brick(40*x, 20*y, mCol))
        x = x + 1
      end

      if (char == "y") then
        table.insert(bricks, Brick(40*x, 20*y, yCol))
        x = x + 1
      end

      if (char == "-") then
        x = x + 1

      end

      if (char == "e") then
        x = 0
        y = y + 1
      end
    end
  end
end
