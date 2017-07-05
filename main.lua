Object = require("classic")
require("paddle")

function love.load()
end

function love.draw()
  love.graphics.print("Hello World!", 10, 10)
  paddle = Paddle()
  paddle:draw();
end

function love.update(dt)
end
