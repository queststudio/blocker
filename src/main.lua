i2c = require("i2c")
local SOLVED, NOT_SOLVED = 1, 0
local id = i2c.HW0
local address = 7

print("Starting I2C... ")

i2c.slave.setup(id, {scl=5, sda=4, addr=address})
i2c.slave.on(id, "receive", function(err, data)
    print("asked for data")
    i2c.slave.send(id, SOLVED)
end)