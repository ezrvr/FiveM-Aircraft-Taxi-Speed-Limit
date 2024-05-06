-- CREATED BY EZRVR --
-- FIVEM TAXI SPEED LIMIT --

local taxiSpeedLimitActive = false
local taxiSpeedLimit = 15.0 -- Taxi speed limit in meters per second (15 mph)

-- Function to toggle taxi speed limit on/off
function ToggleTaxiSpeedLimit()
    taxiSpeedLimitActive = not taxiSpeedLimitActive

    if taxiSpeedLimitActive then
        print("Taxi speed limit activated (15 mph)")
    else
        print("Taxi speed limit deactivated")
        ResetTaxiSpeedLimit() -- Reset the taxi speed limit
    end
end

-- Function to reset the taxi speed limit
function ResetTaxiSpeedLimit()
    local playerPed = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    SetEntityMaxSpeed(vehicle, 9999.0) -- Reset max speed to default (9999.0 is the default max speed)
end

-- Function to limit taxi speed
function LimitTaxiSpeed()
    local altitude = GetEntityHeightAboveGround(GetVehiclePedIsIn(GetPlayerPed(-1), false))

    if altitude <= 5 then
        local playerPed = GetPlayerPed(-1)
        local vehicle = GetVehiclePedIsIn(playerPed, false)
