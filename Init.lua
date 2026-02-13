local _, core = ...

function core:InitEventHandler(event, name)
    if name ~= 'BattleResTracker' then return end
    if BattleResTrackerVariables == nil then BattleResTrackerVariables = {} end
    core:InitFrame()
    core.Logic:Init();
end

local events = CreateFrame('Frame')
events:RegisterEvent('ADDON_LOADED')
events:SetScript('OnEvent', core.InitEventHandler)
