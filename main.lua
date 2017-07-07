Object = require("classic")
require("paddle")
require("ball")
require("brick")

-- Color definitions
colors = {}
colors['r'] = {255, 30, 30}
colors['g'] = {30, 255, 30}
colors['b'] = {30, 30, 255}
colors['c'] = {30, 255, 255}
colors['m'] = {255, 30, 255}
colors['y'] = {255, 255, 30}
colors['w'] = {255, 255, 255}

-- level definitions
bricks = {}

-- sfx definitions
sounds = {
  ["death"] = love.audio.newSource("/sfx/death.wav", "stream"),
  ["hit_brick"] = love.audio.newSource("/sfx/hit_brick.wav", "stream"),
  ["hit_paddle"] = love.audio.newSource("/sfx/hit_paddle.wav", "stream"),
  ["new_level"] = love.audio.newSource("/sfx/new_level.wav", "stream"),
  ["win"] = love.audio.newSource("/sfx/win.wav", "stream"),
}

local paddle
local ball

local score = 0
local combo = 1
local lives = 3

local currentLevel = 1

function love.load()
  paddle = Paddle()
  ball = Ball(paddle, bricks, sounds)
  loadLevel(currentLevel)
  sounds["new_level"]:play()
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
  love.graphics.print("Lives: " .. lives, 10, 70)
  paddle:draw()
  ball:draw()

  if currentLevel == 11 then
    love.graphics.print("You win! Final score: " .. score, 300, 200)
    sounds["win"]:play()
  end
end

function love.update(dt)
  paddle:update()
  ball:update(dt)
  combo, lives = ball:checkCollision(combo, lives)
  score, combo = ball:checkBricksCollision(score, combo)
  if checkCompleted() and currentLevel <= 10 then
    currentLevel = currentLevel + 1
    loadLevel(currentLevel)
    ball:reset()
    sounds["new_level"]:play()
  end
end

function checkCompleted()
  completed = true
  for i=1,#bricks do
    if not bricks[i].destroyed then
      completed = false
    end
  end
  return completed
end

function loadLevel(levelNum)
  -- Load level
  --str = love.filesystem.read("level1.csv")
  local x = 0
  local y = 0

  for line in love.filesystem.lines("/lvl/level" .. levelNum .. ".csv") do

    for i=1, #line do
      local char = string.sub(line, i, i)

      if (char == "-") then
        x = x + 1
      end

      if (char == "e") then
        x = 0
        y = y + 1
      end

      if not (char == "e" or char == "-" or char == ",") then
        table.insert(bricks, Brick(40*x, 20*y, colors[char]))
        x = x + 1
      end

    end
  end
end
