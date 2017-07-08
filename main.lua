-- Additional class definitions
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

-- Sfx definitions
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

local currentLevel = 1 -- What level are we currently on?

function love.load()
  -- Init game objects
  paddle = Paddle()
  ball = Ball(paddle, bricks, sounds)

  -- Load first level
  loadLevel(currentLevel)

  sounds["new_level"]:play()
end

function love.draw()
  -- Draw all alive bricks on screen
  for i=1,#bricks do
    bricks[i]:draw()
  end

  -- UI text
  love.graphics.setColor(255, 255, 255, 255) -- Reset color after drawing bricks
  love.graphics.setFont(love.graphics.newFont(18))
  love.graphics.print("Freaköut!", 10, 10)
  love.graphics.print("Score: " .. score, 10, 30)
  love.graphics.print("Combo: " .. combo, 10, 50)
  love.graphics.print("Lives: " .. lives, 10, 70)

  -- Draw game objects
  paddle:draw()
  ball:draw()

  -- Max level is 10
  if currentLevel == 11 then
    -- Player has won
    love.graphics.print("You win! Final score: " .. score, 300, 200)
    sounds["win"]:play()
  end
end

function love.update(dt)
  paddle:update()
  ball:update(dt)

  -- Collision checks. score, combo and lives are updated inside these checks
  combo, lives = ball:checkCollision(combo, lives)
  score, combo = ball:checkBricksCollision(score, combo)

  -- Current level completed
  if checkCompleted() and currentLevel <= 10 then
    -- Advance to next level
    currentLevel = currentLevel + 1
    loadLevel(currentLevel)
    ball:reset() -- reset ball position and angle
    sounds["new_level"]:play()
  end
end

-- Has the current level been completed?
function checkCompleted()
  completed = true
  -- Are there any alive bricks?
  for i=1,#bricks do
    if not bricks[i].destroyed then
      completed = false
    end
  end
  return completed
end

-- Load a level from the appropriate .csv-file in /lvl/
function loadLevel(levelNum)
  local x = 0
  local y = 0

  -- Read file lines
  for line in love.filesystem.lines("/lvl/level" .. levelNum .. ".csv") do
    -- For each character in line
    for i=1, #line do
      local char = string.sub(line, i, i)
      -- "-" signifies an empty square
      if (char == "-") then
        x = x + 1
      end

      -- "e" signifies the end of a line
      if (char == "e") then
        x = 0
        y = y + 1
      end

      -- "r", "g", "b", "c", "m", "y", "w" signifies a brick of a certain color
      if not (char == "e" or char == "-" or char == ",") then
        -- insert a new brick into the table
        table.insert(bricks, Brick(40*x, 20*y, colors[char]))
        x = x + 1
      end

    end
  end
end
