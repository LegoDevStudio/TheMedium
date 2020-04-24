-- Configuation!
-- idleURL - The URL used when the screen is set to idle.
-- protocol - The protocol the system will listen for requests on.
local idleURL  = "https://legodevstudio.github.io/TheMedium/music.html"
local protocol = "control_music"

-- API load
os.loadAPI("output")
os.loadAPI("json")
local screen = peripheral.wrap("back")


-- Startup tasks.
term.setCursorPos(1,1)
term.clear()
output.setside("front")
output.alloff()
rednet.open("top")

term.setTextColor(colors.magenta)
print("Music Venue Control System - Version 2.0.0")

term.setTextColor(colors.lightBlue)
print("Running system check...")

if screen.isLinked() then
    print("WebDisplay Link: Success")
else
    print("WebDisplay Link: Failure")
    error("Failed to establish link to WebDisplay: Interface not linked.")
end

if screen.can("click") and screen.can("seturl") then
    print("WebDisplay Permissions: Correct")
else
    print("WebDisplay Permissions: Incorrect")
    error("Failed to establish link to WebDisplay: Missing permissions.")
end

function setIdle ()
    screen.setURL(idleURL)
end

function blackout ()
    screen.setURL("about:blank")
    sleep(.1)
    screen.runJS('document.body.style.backgroundColor = "black";')
end

function url (url)
    screen.setURL(url)
end

function fireworks (pulses)
    for i = 1, pulses, 1 do
        output.set("pink", true)
        sleep(.1)
        output.set("pink", false)
        sleep(.2)
    end
end

function smoke (pulses)
    for i = 1, pulses, 1 do
        output.set("grey", true)
        sleep(.1)
        output.set("grey", false)
        sleep(.2)
    end
end

function sendSuccess (sender)
    rednet.send(sender, "{\"op\":0,\"data\":{\"code\":\"SUCCESS\"}}")
    term.setTextColor(colors.purple)
    print("Sent: 0 Content: {\"code\":\"SUCCESS\"}}")
end

function sendFail (sender, code)
    rednet.send(sender, "{\"op\":1,\"data\":{\"code\":\""..code.."\"}}")
    term.setTextColor(colors.purple)
    print("Sent: 1 Content: {\"code\":\""..code.."\"}}")
end

term.setTextColor(colors.lime)
print("Setting WebDisplay to idle.")
setIdle()

term.setTextColor(colors.purple)
print("Success. Printing protocol.")

term.setTextColor(colors.white)
print(protocol)

term.setTextColor(colors.orange)
print("System ready. Awaiting input.")

while true do
    local sender, message, protocol = rednet.receive(protocol)

    local data = json.decode(message)

    term.setTextColor(colors.purple)
    print("Recieved: "..data.op.." Content: "..json.encode(data.data))

    if data.op == 0 then
        if data.data == nil or data.data.url == nil then
            sendFail(sender, "INVALID_DATA")
        else
            url(data.data.url)
            sendSuccess(sender)
        end
    elseif data.op == 1 then
        if data.data == nil then
            sendFail(sender, "INVALID_DATA")
        else
            blackout()
            sendSuccess(sender)
        end
    elseif data.op == 2 then
        if data.data == nil then
            sendFail(sender, "INVALID_DATA")
        else
            setIdle()
            sendSuccess(sender)
        end
    elseif data.op == 3 then
        if data.data == nil or data.data.pulses == nil then
            sendFail(sender, "INVALID_DATA")
        else
            fireworks(data.data.pulses)
            sendSuccess(sender)
        end
    elseif data.op == 4 then
        if data.data == nil or data.data.pulses == nil then
            sendFail(sender, "INVALID_DATA")
        else
            smoke(data.data.pulses)
            sendSuccess(sender)
        end
    else
        sendFail(sender, "INVALID_OP")
    end
end
