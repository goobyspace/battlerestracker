local _, core = ...

function core:TweaksSetter()
    for i = 1, # (core.Tweaks) do
        if GoobyFrameTweaksVariables[core.Tweaks[i].name] then
            core.Tweaks[i].func()
        end
    end
end

function core:InitEventHandler(event, name)
    if name ~= "GoobyFrameTweaks" then return end
    if GoobyFrameTweaksVariables == nil then GoobyFrameTweaksVariables = {} end
    core.Settings:Initialize()
    core:TweaksSetter()
end

local events = CreateFrame("Frame")
events:RegisterEvent("ADDON_LOADED")
events:SetScript("OnEvent", core.InitEventHandler)
