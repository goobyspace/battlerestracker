local _, core = ...
core.Settings = {}

local localCategory = ""
local reloadButtonAdded = false;

local function AddReloadButton()
    if reloadButtonAdded then return end;
    reloadButtonAdded = true;
    local reloadButton = CreateSettingsButtonInitializer(
        "Your settings have changed",
        "Reload UI",
        function()
            C_UI.Reload();
        end,
        "Please reload your UI to have your changed settings take effect.",
        true
    )

    local addonLayout = SettingsPanel:GetLayout(localCategory)
    addonLayout:AddInitializer(reloadButton)
end

local function OnSettingChanged(setting, value)
    AddReloadButton();
end

-- can probably make this fully dynamic by grabbing the categories themselves from the tweaks array

function core.Settings:Initialize()
    local category, layout = Settings.RegisterVerticalLayoutCategory("Gooby Frame Tweaks")
    localCategory = category;

    local function createCheckbox(name, title, description)
        local defaultValue = true
        local setting = Settings.RegisterAddOnSetting(category, name, name,
            GoobyFrameTweaksVariables,
            type(defaultValue),
            title, defaultValue)
        setting:SetValueChangedCallback(OnSettingChanged)

        Settings.CreateCheckbox(category, setting,
            description)
    end

    local categories = core.Utils:MapUnique(core.Tweaks, function(tweak) return tweak.category end)
    for i = 1, # (categories) do
        local categoryCheckboxes = core.Utils:FilterToNewArray(core.Tweaks,
            function(tweak) return tweak.category == categories[i] end)
        layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(categories[i]));
        for x = 1, # (categoryCheckboxes) do
            createCheckbox(categoryCheckboxes[x].name, categoryCheckboxes[x].title, categoryCheckboxes[x].description)
        end
    end

    Settings.RegisterAddOnCategory(category)
end
