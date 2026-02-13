local _, core = ...
core.Utils = {}

function core.Utils:FilterToNewArray(arr, func)
    local newArray = {}
    local newIndex = 1
    for oldIndex, v in ipairs(arr) do
        if func(v, oldIndex) then
            newArray[newIndex] = v
            newIndex = newIndex + 1
        end
    end
    return newArray
end

function core.Utils:MapUnique(arr, func)
    local newArray = {}
    local newIndex = 1
    -- pairs instead of ipairs for dictionary support
    for key, value in pairs(arr) do
        local newValue = func(key, value)
        local newValueFound = false;
        for i = 0, # newArray do
            if newArray[i] == newValue then
                newValueFound = true
            end
        end
        if not newValueFound then
            newArray[newIndex] = newValue
            newIndex = newIndex + 1
        end
    end
    return newArray
end

function core.Utils:DefaultsTableChecker(current, defaults)
    for key, value in pairs(defaults) do
        if current[key] == nil then
            current[key] = value;
        end
    end
end
