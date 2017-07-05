Object = require("classic")
require("paddle")
require("ball")
require("brick")

local paddle

function love.load()
  paddle = Paddle()
  ball = Ball(100, 100, paddle)
end

function love.draw()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.print("Löve Breakout", 10, 10)
  paddle:draw()
  ball:draw()
end

function love.update(dt)
  paddle:update()
  ball:update(dt)
end
