Object = require("classic")
require("paddle")

local paddle

function love.load()
  paddle = Paddle()
end

function love.draw()
  love.graphics.print("Löve Breakout", 10, 10)
  paddle:draw()
end

function love.update(dt)
  paddle:update()
end
