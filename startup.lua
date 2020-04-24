-- Configuation!
-- monitor - The monitor the main script will push logs to. Must be connected by a modem. Set to "none" for normal output.
-- errorURL - The URL the system will set the screen to if the main script encounters a fatal error.
local monitor = "monitor_3"
local errorURL = "https://legodevstudio.github.io/TheMedium/serverError.html"

-- API init
os.loadAPI("output")
local screen = peripheral.wrap("back")

print("Starting server OS on output monitor: "..monitor..".")

if monitor == "none" then
    shell.run("server.lua")
else
    shell.run("monitor "..monitor.." server.lua")
end

screen.setURL(errorURL)
output.alloff()
output.set("blue", true)

while true do
    if redstone.testBundledInput("front", colors.brown) then
        if monitor == "none" then
            shell.run("server.lua")
        else
            shell.run("monitor "..monitor.." server.lua")
        end
        screen.setURL(errorURL)
        output.alloff()
        output.set("blue", true)
    end
    sleep(1)
end
