-- CREATED BY EZRD DEV --
-- V2 / FINAL -- 

local taxiSpeedLimitActive = false
local taxiSpeedLimit = 15.0 -- Taxi speed limit in meters per second (15 mph)

-- Function to toggle taxi speed limit on/off
function ToggleTaxiSpeedLimit()
    local playerPed = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    local vehicleClass = GetVehicleClass(vehicle)
    
    if vehicleClass == 16 then -- Vehicle class 16 corresponds to planes
        taxiSpeedLimitActive = not taxiSpeedLimitActive

        if taxiSpeedLimitActive then
            print("Taxi speed limit activated (15 mph)")
        else
            print("Taxi speed limit deactivated")
            ResetTaxiSpeedLimit() -- Reset the taxi speed limit
        end
    else
        print("Taxi speed limit unavailable")
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
        local currentSpeed = GetEntitySpeed(vehicle)

        if taxiSpeedLimitActive then
            if currentSpeed > (taxiSpeedLimit * 0.447) then -- Convert mph to m/s
                SetEntityMaxSpeed(vehicle, taxiSpeedLimit * 0.447) -- Set max speed in m/s
            end
        else
            ResetTaxiSpeedLimit() -- Reset the taxi speed limit if not active
        end
    end
end

-- Function to draw taxi limit status
function DrawTaxiLimitStatus()
    local playerPed = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    local vehicleClass = GetVehicleClass(vehicle)
    local altitude = GetEntityHeightAboveGround(vehicle)
    local status = ""
    
    if vehicleClass ~= 16 then
        status = "~c~UNAVAILABLE"
    elseif altitude > 5 then
        status = "NOT AVAILABLE"
    else
        status = taxiSpeedLimitActive and "~g~ON" or "~r~OFF"
    end
    
    local text = "Taxi Limit: " .. status

    SetTextFont(4) -- Font used for the other resource
    SetTextProportional(0)
    SetTextScale(0.45, 0.45)
    SetTextColour(255, 255, 255, 255, 50)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(0.175, 0.905)
end

-- Bind key to toggle taxi speed limit
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(0, 131) then -- Key Control for Taxi Limit (example: "K" key)
            ToggleTaxiSpeedLimit()
        end

        LimitTaxiSpeed()
        DrawTaxiLimitStatus()
    end
end)
