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
    for oldIndex, v in ipairs(arr) do
        local newValue = func(v, oldIndex)
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
