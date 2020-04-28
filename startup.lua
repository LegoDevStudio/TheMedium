-- Configuation!
local modemLocation = "top"
local protocol = "control_music"

term.setCursorPos(1,1)
term.clear()
rednet.open(modemLocation)
os.loadAPI("json")

term.setTextColor(colors.purple)
print("Music Venue Controls - V2")
print("1 - Screen Controls")
print("2 - Pyrotechnics")

local input = read()

if input == "1" then
    term.setCursorPos(1,1)
    term.clear()
    print("Screen Controls")
    print("1 - Set Screen URL")
    print("2 - Idle screen")
    print("3 - Turn screen off")
    local subcmd = read()
    if subcmd == "1" then
        term.setCursorPos(1,1)
        term.clear()
        print("Please enter URL")
        local url = read()

        rednet.broadcast("{\"op\":0,\"data\":{\"url\":\""..url.."\"}}",protocol)
    elseif subcmd == "2" then
        rednet.broadcast("{\"op\":2,\"data\":{}}",protocol)
    elseif subcmd == "3" then
        rednet.broadcast("{\"op\":1,\"data\":{}}",protocol)
    else
        print("Sorry, "..subcmd.." was not an option.")
        sleep(2)
        os.reboot()
    end
elseif input == "2" then
    term.setCursorPos(1,1)
    term.clear()
    print("Pyrotechnics Controls")
    print("1 - Fireworks")
    print("2 - Smoke")
    local subcmd = read()
    if subcmd == "1" then
        term.setCursorPos(1,1)
        term.clear()
        print("Please enter amount of fireworks to fire.")
        local pulses = tonumber(read())
        if type(pulses) == "number" then
            rednet.broadcast("{\"op\":3,\"data\":{\"pulses\":"..pulses.."}}",protocol)
        else
            print("Amount must be a number.")
            sleep(2)
            os.reboot()
        end
    elseif subcmd == "2" then
        term.setCursorPos(1,1)
        term.clear()
        print("Please enter amount of pulses to fire.")
        local pulses = tonumber(read())
        if type(pulses) == "number" then
            rednet.broadcast("{\"op\":4,\"data\":{\"pulses\":"..pulses.."}}",protocol)
        else
            print("Amount must be a number.")
            sleep(2)
            os.reboot()
        end
    else
        print("Sorry, "..subcmd.." was not an option.")
        sleep(2)
        os.reboot()
    end
end

local sender, message, protocoll = rednet.receive()

local data = json.decode(message)

if data.op == 1 then
    if data.data == nil or data.data.code == nil then
    else
        if data.data.code == "INVALID_DATA" then
            term.setTextColor(colors.red)
            print("Invalid data was sent to the server by this device.")
            print("Possible counterfiet device detected. Wiping data...")
            shell.run("delete json")
            shell.run("delete startup.lua")
            shell.run("delete server.lua")
            print("Data has been wiped from this device. Shutting down in 5 seconds.")
            sleep(5)
            os.shutdown()
        elseif data.data.code == "INVALID_OP" then
            term.setTextColor(colors.red)
            print("Invalid OPCODE was sent to the server by this device.")
            print("Possible counterfiet device detected. Wiping data...")
            shell.run("delete json")
            shell.run("delete startup.lua")
            shell.run("delete server.lua")
            print("Data has been wiped from this device. Shutting down in 5 seconds.")
            sleep(5)
            os.shutdown()
        elseif data.data.code == "INVALID_URL" then
            term.setTextColor(colors.red)
            print("That's not a valid url! Try again.")
            sleep(2)
            os.reboot()
        end
    end
elseif data.op == 0 then
    if data.data == nil or data.data.code == nil then
    else
        if data.data.code == "SUCCESS" then
            term.setTextColor(colors.green)
            print("Success!")
            sleep(2)
            os.reboot()
        end
    end
end
