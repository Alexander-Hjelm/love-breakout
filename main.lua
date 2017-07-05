Object = require("classic")
require("paddle")
require("ball")

local paddle

function love.load()
  paddle = Paddle()
  ball = Ball(100, 100)
end

function love.draw()
  love.graphics.print("Löve Breakout", 10, 10)
  paddle:draw()
  ball:draw()
end

function love.update(dt)
  paddle:update()
  ball:update(dt)
end
