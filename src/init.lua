--init.lua
print("Starting...")
print("Version 1.0.3")
wifi.setmode(wifi.STATION)
wifi.sta.config {ssid="Gorun_mob",pwd="sinisterkid"}
wifi.sta.connect()
tmr.alarm(1, 1000, 1, function()
    if wifi.sta.getip() == nil then
        print("IP unavaiable, Waiting...")
    else
        tmr.stop(1)
        print("Started")
        print("ESP8266 mode is: " .. wifi.getmode())
        print("The module MAC address is: " .. wifi.ap.getmac())
        print("Config done, IP is "..wifi.sta.getip())
        dofile("main.lua")
    end
end)
