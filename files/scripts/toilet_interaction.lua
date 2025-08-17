GamePrint("TOILET TEST: Script loaded!")
GamePrintImportant("TOILET TEST: Script loaded important!")
print("TOILET TEST: Print statement")

function time_step()
    GamePrint("TOILET TEST: time_step() called!")
    GamePrintImportant("TOILET TEST: time_step() important!")
    
    local entity_id = GetUpdatedEntityID()
    if entity_id then
        local x, y = EntityGetTransform(entity_id)
        GamePrint("TOILET TEST: Entity " .. entity_id .. " at " .. x .. ", " .. y)
    else
        GamePrint("TOILET TEST: No entity ID!")
    end
end

function collision_trigger()
    GamePrint("TOILET TEST: collision_trigger() called!")
end

function death()
    GamePrint("TOILET TEST: death() called!")
end

function init()
    GamePrint("TOILET TEST: init() called!")
end
