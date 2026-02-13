local _, core = ...
local LibEditMode = core.LibEditMode
core.editModeActive = false;

local LibSharedMedia = LibStub('LibSharedMedia-3.0')

local fontsDropdownValues = core.Utils:MapUnique(LibSharedMedia:HashTable(LibSharedMedia.MediaType.FONT),
    function(key, value)
        return {
            text = key,
            value = value
        }
    end)

local classIcons = {
    ['Death Knight'] = 136143, -- raise ally
    ['Druid'] = 136080,        -- rebirth
    ['Paladin'] = 4726195,     -- Intercession
    ['Warlock'] = 136210,      -- Soulstone
    ['Engineering'] = 4548869, -- Convincingly Realistic Jumper Cables
}

local classIconDropdownValues = core.Utils:MapUnique(classIcons, function(key, value)
    return {
        text = key,
        value = value
    }
end)

local textOutlinedDropdownValues = {
    {
        text = 'None',
        value = ''
    },
    {
        text = 'Outlined',
        value = 'OUTLINE'
    },
    {
        text = 'Thick Outline',
        value = 'THICKOUTLINE'
    }
}

local defaultValues = {
    -- frame
    point = 'CENTER',
    x = 0,
    y = 60,
    -- charges
    chargesEnabled = true,
    chargesFont = fontsDropdownValues[2].value,
    chargesFontSize = 16,
    chargesOutlined = textOutlinedDropdownValues[3].value,
    chargesX = -22,
    chargesY = 18,
    -- cooldown
    cooldownEnabled = true,
    cooldownFont = fontsDropdownValues[2].value,
    cooldownFontSize = 16,
    cooldownOutlined = textOutlinedDropdownValues[3].value,
    cooldownX = 0,
    cooldownY = -16,
    --icon
    iconEnabled = true,
    icon = classIcons['Druid'],
    width = 48,
    height = 48,
}

function core:SetChargesText(text)
    local layoutName = LibEditMode:GetActiveLayoutName()
    if (BattleResTrackerVariables['BRFrameSettings'][layoutName].chargesEnabled) then
        core.frame.charges:SetText(text)
    else
        core.frame.charges:SetText("")
    end
end

function core:SetCooldownText(text)
    local layoutName = LibEditMode:GetActiveLayoutName()
    if (BattleResTrackerVariables['BRFrameSettings'][layoutName].cooldownEnabled) then
        core.frame.cooldownText:SetText(text)
    else
        core.frame.cooldownText:SetText("")
    end
end

function core:SetCooldown(cooldownStartTime, cooldownDuration)
    local layoutName = LibEditMode:GetActiveLayoutName()
    if (BattleResTrackerVariables['BRFrameSettings'][layoutName].iconEnabled) then
        core.frame.cooldown:SetCooldown(cooldownStartTime, cooldownDuration)
    else
        core.frame.cooldown:Clear()
    end
end

-- create frame, set it up in edit mode, update default values, add edit mode settings
function core:InitFrame()
    -- set up basics
    core.frame = CreateFrame('frame', 'BattleResTracker', UIParent, 'SecureHandlerStateTemplate')
    core.frame.icon = core.frame:CreateTexture()
    core.frame.icon:SetAllPoints()
    core.frame.cooldown = CreateFrame('Cooldown', 'BattleResTrackerCooldown', core.frame, 'CooldownFrameTemplate')
    core.frame.cooldown:SetHideCountdownNumbers(true)
    core.frame.cooldown:SetFrameLevel(core.frame:GetFrameLevel() + 1)
    core.frame.cooldown:SetAllPoints()

    core.frame.textFrame = CreateFrame('frame', 'BattleResTrackerTextContainer', core.frame)
    core.frame.textFrame:SetFrameLevel(core.frame:GetFrameLevel() + 2)
    core.frame.textFrame:SetAllPoints()

    core.frame.charges = core.frame.textFrame:CreateFontString('BattleResTrackerCharges', 'OVERLAY', 'GameTooltipText')
    core.frame.charges:SetText('0')
    core.frame.cooldownText = core.frame.textFrame:CreateFontString('BattleResTrackerCooldownText', 'OVERLAY',
        'GameTooltipText')
    core.frame.cooldownText:SetPoint('CENTER')
    core.frame.cooldownText:SetText('')

    -- this just updates the main position
    local function onPositionChanged(frame, layoutName, point, x, y)
        BattleResTrackerVariables['BRFrameSettings'][layoutName].point = point
        BattleResTrackerVariables['BRFrameSettings'][layoutName].x = x
        BattleResTrackerVariables['BRFrameSettings'][layoutName].y = y
    end

    -- these settings are all for the actual edit mode settings, if you turned the icon off we turn the icon settings off, et cetera

    -- these currently do not seem to work, todo for later
    -- local function setChargesSettings(enabled)
    --     if enabled then
    --         LibEditMode:EnableFrameSetting(core.frame, 'Charges X')
    --         LibEditMode:EnableFrameSetting(core.frame, 'Charges Y')
    --         LibEditMode:EnableFrameSetting(core.frame, 'Charges Font')
    --         LibEditMode:EnableFrameSetting(core.frame, 'Charges Font Size')
    --         LibEditMode:EnableFrameSetting(core.frame, 'Charges Font Outline')
    --     else
    --         LibEditMode:DisableFrameSetting(core.frame, 'Charges X')
    --         LibEditMode:DisableFrameSetting(core.frame, 'Charges Y')
    --         LibEditMode:DisableFrameSetting(core.frame, 'Charges Font')
    --         LibEditMode:DisableFrameSetting(core.frame, 'Charges Font Size')
    --         LibEditMode:DisableFrameSetting(core.frame, 'Charges Font Outline')
    --     end
    -- end

    -- local function setIconSettings(enabled)
    --     if enabled then
    --         LibEditMode:EnableFrameSetting(core.frame, 'Class Icon')
    --         LibEditMode:EnableFrameSetting(core.frame, 'Icon Width')
    --         LibEditMode:EnableFrameSetting(core.frame, 'Icon Height')
    --     else
    --         LibEditMode:DisableFrameSetting(core.frame, 'Class Icon')
    --         LibEditMode:DisableFrameSetting(core.frame, 'Icon Width')
    --         LibEditMode:DisableFrameSetting(core.frame, 'Icon Height')
    --     end
    -- end

    -- local function setCooldownSettings(enabled)
    --     if enabled then
    --         LibEditMode:EnableFrameSetting(core.frame, 'Cooldown X')
    --         LibEditMode:EnableFrameSetting(core.frame, 'Cooldown Y')
    --         LibEditMode:EnableFrameSetting(core.frame, 'Cooldown Font')
    --         LibEditMode:EnableFrameSetting(core.frame, 'Cooldown Font Size')
    --         LibEditMode:EnableFrameSetting(core.frame, 'Cooldown Font Outline')
    --     else
    --         LibEditMode:DisableFrameSetting(core.frame, 'Cooldown X')
    --         LibEditMode:DisableFrameSetting(core.frame, 'Cooldown Y')
    --         LibEditMode:DisableFrameSetting(core.frame, 'Cooldown Font')
    --         LibEditMode:DisableFrameSetting(core.frame, 'Cooldown Font Size')
    --         LibEditMode:DisableFrameSetting(core.frame, 'Cooldown Font Outline')
    --     end
    -- end

    -- we should make it so that instead of editing the settings straight away
    -- you only edit a temp version of the settings until you actually press save
    -- and otherwise it resets
    LibEditMode:RegisterCallback('enter', function()
        core.editModeActive = true
        core.Logic:Show()
        core.Logic:UpdateCharges(true)
        -- local layoutName = LibEditMode:GetActiveLayoutName()
        -- if layoutName then
        --     setIconSettings(BattleResTrackerVariables['BRFrameSettings'][layoutName].iconEnabled)
        --     setChargesSettings(BattleResTrackerVariables['BRFrameSettings'][layoutName].chargesEnabled)
        --     setCooldownSettings(BattleResTrackerVariables['BRFrameSettings'][layoutName].cooldownEnabled)
        -- end
    end)
    LibEditMode:RegisterCallback('exit', function()
        -- zone check so we don't hide it if you open edit mode in a m+ or something
        core.editModeActive = false
        core.Logic:ZoneCheck()
    end)
    LibEditMode:RegisterCallback('delete', function(layoutName)
        BattleResTrackerVariables['BRFrameSettings'][layoutName] = nil
    end)
    LibEditMode:RegisterCallback('layout', function(layoutName)
        -- this will be called every time the Edit Mode layout is changed (which also happens at login),
        -- use it to load the saved button position from savedvariables and position it
        if not BattleResTrackerVariables['BRFrameSettings'] then
            BattleResTrackerVariables['BRFrameSettings'] = {}
        end

        if not BattleResTrackerVariables['BRFrameSettings'][layoutName] then
            BattleResTrackerVariables['BRFrameSettings'][layoutName] = CopyTable(defaultValues)
        end

        core.Utils:DefaultsTableChecker(BattleResTrackerVariables['BRFrameSettings'][layoutName], defaultValues)

        -- all these settings are duplicated below, make sure to update them if you add any
        core.frame:ClearAllPoints()
        core.frame.icon:SetShown(BattleResTrackerVariables['BRFrameSettings'][layoutName].iconEnabled)
        core.frame.cooldown:SetShown(BattleResTrackerVariables['BRFrameSettings'][layoutName].iconEnabled)
        core.frame.icon:SetTexture(BattleResTrackerVariables['BRFrameSettings'][layoutName].icon)
        core.frame:SetSize(BattleResTrackerVariables['BRFrameSettings'][layoutName].width,
            BattleResTrackerVariables['BRFrameSettings'][layoutName].height)
        core.frame:SetPoint(BattleResTrackerVariables['BRFrameSettings'][layoutName].point,
            BattleResTrackerVariables['BRFrameSettings'][layoutName].x,
            BattleResTrackerVariables['BRFrameSettings'][layoutName].y)

        core.frame.charges:SetShown(BattleResTrackerVariables['BRFrameSettings'][layoutName].chargesEnabled)
        core.frame.charges:SetPoint('CENTER', BattleResTrackerVariables['BRFrameSettings'][layoutName].chargesX,
            BattleResTrackerVariables['BRFrameSettings'][layoutName].chargesY);
        core.frame.charges:SetFont(BattleResTrackerVariables['BRFrameSettings'][layoutName].chargesFont,
            BattleResTrackerVariables['BRFrameSettings'][layoutName].chargesFontSize,
            BattleResTrackerVariables['BRFrameSettings'][layoutName].chargesOutlined)

        core.frame.cooldownText:SetShown(BattleResTrackerVariables['BRFrameSettings'][layoutName].cooldownEnabled)
        core.frame.cooldownText:SetPoint('CENTER', BattleResTrackerVariables['BRFrameSettings'][layoutName].cooldownX,
            BattleResTrackerVariables['BRFrameSettings'][layoutName].cooldownY);
        core.frame.cooldownText:SetFont(BattleResTrackerVariables['BRFrameSettings'][layoutName].cooldownFont,
            BattleResTrackerVariables['BRFrameSettings'][layoutName].cooldownFontSize,
            BattleResTrackerVariables['BRFrameSettings'][layoutName].cooldownOutlined)

        core.Logic:Hide()
    end)

    LibEditMode:AddFrame(core.frame, onPositionChanged, defaultValues)

    LibEditMode:AddFrameSettings(core.frame, {
        {
            name = 'Charges',
            kind = LibEditMode.SettingType.Divider,
        },
        {
            name = 'Enable Charges Text',
            kind = LibEditMode.SettingType.Checkbox,
            default = defaultValues.chargesEnabled,
            get = function(layoutName)
                return BattleResTrackerVariables['BRFrameSettings'][layoutName].chargesEnabled
            end,
            set = function(layoutName, value)
                BattleResTrackerVariables['BRFrameSettings'][layoutName].chargesEnabled = value
                -- setChargesSettings(value)
                core.frame.charges:SetShown(value)
            end,
        },
        {
            name = 'Charges X',
            kind = LibEditMode.SettingType.Slider,
            default = defaultValues.chargesX,
            get = function(layoutName)
                return BattleResTrackerVariables['BRFrameSettings'][layoutName].chargesX
            end,
            set = function(layoutName, value)
                BattleResTrackerVariables['BRFrameSettings'][layoutName].chargesX = value
                core.frame.charges:SetPoint('CENTER', value, BattleResTrackerVariables['BRFrameSettings'][layoutName]
                    .chargesY)
            end,
            minValue = -512,
            maxValue = 512,
            valueStep = 1,
        },
        {
            name = 'Charges Y',
            kind = LibEditMode.SettingType.Slider,
            default = defaultValues.chargesY,
            get = function(layoutName)
                return BattleResTrackerVariables['BRFrameSettings'][layoutName].chargesY
            end,
            set = function(layoutName, value)
                BattleResTrackerVariables['BRFrameSettings'][layoutName].chargesY = value
                core.frame.charges:SetPoint('CENTER', BattleResTrackerVariables['BRFrameSettings'][layoutName].chargesX,
                    value)
            end,
            minValue = -512,
            maxValue = 512,
            valueStep = 1,
        },
        {
            name = 'Charges Font',
            kind = LibEditMode.SettingType.Dropdown,
            default = defaultValues.chargesFont,
            get = function(layoutName)
                return BattleResTrackerVariables['BRFrameSettings'][layoutName].chargesFont
            end,
            set = function(layoutName, value)
                BattleResTrackerVariables['BRFrameSettings'][layoutName].chargesFont = value
                core.frame.charges:SetFont(value,
                    BattleResTrackerVariables['BRFrameSettings'][layoutName].chargesFontSize,
                    BattleResTrackerVariables['BRFrameSettings'][layoutName].chargesOutlined)
            end,
            values = fontsDropdownValues
        },
        {
            name = 'Charges Font Size',
            kind = LibEditMode.SettingType.Slider,
            default = defaultValues.chargesFontSize,
            get = function(layoutName)
                return BattleResTrackerVariables['BRFrameSettings'][layoutName].chargesFontSize
            end,
            set = function(layoutName, value)
                BattleResTrackerVariables['BRFrameSettings'][layoutName].chargesFontSize = value
                core.frame.charges:SetFont(BattleResTrackerVariables['BRFrameSettings'][layoutName].chargesFont,
                    value,
                    BattleResTrackerVariables['BRFrameSettings'][layoutName].chargesOutlined)
            end,
            minValue = 4,
            maxValue = 128,
            valueStep = 1,
        },
        {
            name = 'Charges Font Outline',
            kind = LibEditMode.SettingType.Dropdown,
            default = defaultValues.chargesOutlined,
            get = function(layoutName)
                return BattleResTrackerVariables['BRFrameSettings'][layoutName].chargesOutlined
            end,
            set = function(layoutName, value)
                BattleResTrackerVariables['BRFrameSettings'][layoutName].chargesOutlined = value
                core.frame.charges:SetFont(BattleResTrackerVariables['BRFrameSettings'][layoutName].chargesFont,
                    BattleResTrackerVariables['BRFrameSettings'][layoutName].chargesFontSize,
                    value)
            end,
            values = textOutlinedDropdownValues
        },
        {
            name = 'Cooldown',
            kind = LibEditMode.SettingType.Divider,
        },
        {
            name = 'Enable Cooldown Text',
            kind = LibEditMode.SettingType.Checkbox,
            default = defaultValues.cooldownEnabled,
            get = function(layoutName)
                return BattleResTrackerVariables['BRFrameSettings'][layoutName].cooldownEnabled
            end,
            set = function(layoutName, value)
                BattleResTrackerVariables['BRFrameSettings'][layoutName].cooldownEnabled = value
                -- setCooldownSettings(value)
                core.frame.cooldownText:SetShown(value)
            end,
        },
        {
            name = 'Cooldown X',
            kind = LibEditMode.SettingType.Slider,
            default = defaultValues.cooldownX,
            get = function(layoutName)
                return BattleResTrackerVariables['BRFrameSettings'][layoutName].cooldownX
            end,
            set = function(layoutName, value)
                BattleResTrackerVariables['BRFrameSettings'][layoutName].cooldownX = value
                core.frame.cooldownText:SetPoint('CENTER', value,
                    BattleResTrackerVariables['BRFrameSettings'][layoutName].cooldownY)
            end,
            minValue = -512,
            maxValue = 512,
            valueStep = 1,
        },
        {
            name = 'Cooldown Y',
            kind = LibEditMode.SettingType.Slider,
            default = defaultValues.cooldownY,
            get = function(layoutName)
                return BattleResTrackerVariables['BRFrameSettings'][layoutName].cooldownY
            end,
            set = function(layoutName, value)
                BattleResTrackerVariables['BRFrameSettings'][layoutName].cooldownY = value
                core.frame.cooldownText:SetPoint('CENTER', BattleResTrackerVariables['BRFrameSettings'][layoutName]
                    .cooldownX,
                    value)
            end,
            minValue = -512,
            maxValue = 512,
            valueStep = 1,
        },
        {
            name = 'Cooldown Font',
            kind = LibEditMode.SettingType.Dropdown,
            default = defaultValues.cooldownFont,
            get = function(layoutName)
                return BattleResTrackerVariables['BRFrameSettings'][layoutName].cooldownFont
            end,
            set = function(layoutName, value)
                BattleResTrackerVariables['BRFrameSettings'][layoutName].cooldownFont = value
                core.frame.cooldownText:SetFont(value,
                    BattleResTrackerVariables['BRFrameSettings'][layoutName].cooldownFontSize,
                    BattleResTrackerVariables['BRFrameSettings'][layoutName].cooldownOutlined)
            end,
            values = fontsDropdownValues
        },
        {
            name = 'Cooldown Font Size',
            kind = LibEditMode.SettingType.Slider,
            default = defaultValues.cooldownFontSize,
            get = function(layoutName)
                return BattleResTrackerVariables['BRFrameSettings'][layoutName].cooldownFontSize
            end,
            set = function(layoutName, value)
                BattleResTrackerVariables['BRFrameSettings'][layoutName].cooldownFontSize = value
                core.frame.cooldownText:SetFont(BattleResTrackerVariables['BRFrameSettings'][layoutName].cooldownFont,
                    value,
                    BattleResTrackerVariables['BRFrameSettings'][layoutName].cooldownOutlined)
            end,
            minValue = 4,
            maxValue = 128,
            valueStep = 1,
        },
        {
            name = 'Cooldown Font Outline',
            kind = LibEditMode.SettingType.Dropdown,
            default = defaultValues.cooldownOutlined,
            get = function(layoutName)
                return BattleResTrackerVariables['BRFrameSettings'][layoutName].cooldownOutlined
            end,
            set = function(layoutName, value)
                BattleResTrackerVariables['BRFrameSettings'][layoutName].cooldownOutlined = value
                core.frame.cooldownText:SetFont(BattleResTrackerVariables['BRFrameSettings'][layoutName].cooldownFont,
                    BattleResTrackerVariables['BRFrameSettings'][layoutName].cooldownFontSize,
                    value)
            end,
            values = textOutlinedDropdownValues
        },
        {
            name = 'Icon',
            kind = LibEditMode.SettingType.Divider,
        },
        {
            name = 'Enable Icon',
            kind = LibEditMode.SettingType.Checkbox,
            default = defaultValues.iconEnabled,
            get = function(layoutName)
                return BattleResTrackerVariables['BRFrameSettings'][layoutName].iconEnabled
            end,
            set = function(layoutName, value)
                BattleResTrackerVariables['BRFrameSettings'][layoutName].iconEnabled = value
                core.frame.cooldown:SetShown(value)
                -- setIconSettings(value)
                core.frame.icon:SetShown(value)
            end,
        },
        {
            name = 'Class Icon',
            kind = LibEditMode.SettingType.Dropdown,
            default = defaultValues.icon,
            get = function(layoutName)
                return BattleResTrackerVariables['BRFrameSettings'][layoutName].icon
            end,
            set = function(layoutName, value)
                BattleResTrackerVariables['BRFrameSettings'][layoutName].icon = value
                core.frame.icon:SetTexture(value)
            end,
            values = classIconDropdownValues
        },
        {
            name = 'Icon Width',
            kind = LibEditMode.SettingType.Slider,
            default = defaultValues.width,
            get = function(layoutName)
                return BattleResTrackerVariables['BRFrameSettings'][layoutName].width
            end,
            set = function(layoutName, value)
                BattleResTrackerVariables['BRFrameSettings'][layoutName].width = value
                core.frame:SetSize(value, BattleResTrackerVariables['BRFrameSettings'][layoutName].height)
            end,
            minValue = 1,
            maxValue = 500,
            valueStep = 1,
        },
        {
            name = 'Icon Height',
            kind = LibEditMode.SettingType.Slider,
            default = defaultValues.height,
            get = function(layoutName)
                return BattleResTrackerVariables['BRFrameSettings'][layoutName].height
            end,
            set = function(layoutName, value)
                BattleResTrackerVariables['BRFrameSettings'][layoutName].height = value
                core.frame:SetSize(BattleResTrackerVariables['BRFrameSettings'][layoutName].width, value)
            end,
            minValue = 1,
            maxValue = 500,
            valueStep = 1,
        }
    })
end
