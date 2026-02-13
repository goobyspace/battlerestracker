local _, core = ...

core.Logic = {}

local inRaid = false
local inRaidCombat = false
local inMythicPlus = false

local timer = nil;

function core.Logic:Init()
    --reloads
    core.frame:RegisterEvent('PLAYER_ENTERING_WORLD')
    -- raid
    core.frame:RegisterEvent('ZONE_CHANGED_NEW_AREA')
    core.frame:RegisterEvent('PLAYER_REGEN_ENABLED')
    core.frame:RegisterEvent('PLAYER_REGEN_DISABLED')
    -- m+
    core.frame:RegisterEvent('CHALLENGE_MODE_START')
    -- spell itself
    core.frame:RegisterEvent('SPELL_UPDATE_CHARGES')

    core.frame:SetScript('OnEvent', function(self, event)
        if event == 'SPELL_UPDATE_CHARGES' then
            if inRaidCombat or inMythicPlus then
                core.Logic:UpdateCharges()
            end
        elseif event == 'ZONE_CHANGED_NEW_AREA' or event == 'CHALLENGE_MODE_START' or event == 'PLAYER_ENTERING_WORLD' then
            core.Logic:ZoneCheck()
        elseif inRaid and event == 'PLAYER_REGEN_ENABLED' then
            inRaidCombat = true
            core.Logic:UpdateCharges()
        elseif event == 'PLAYER_REGEN_DISABLED' then
            inRaidCombat = false
            core.Logic:UpdateCharges()
        end
    end)
end

function core.Logic:ZoneCheck()
    local _, instanceType = GetInstanceInfo()
    if instanceType == 'raid' then
        inRaid = true
        core.Logic:Show()
    else
        inRaid = false
    end

    if C_ChallengeMode.IsChallengeModeActive() then
        inMythicPlus = true
        core.Logic:Show()
    else
        inMythicPlus = false
    end

    if not inMythicPlus and not inRaid then
        core.Logic:Hide()
    end
end

function core.Logic:Hide()
    if InCombatLockdown() then return end
    core.frame:Hide()
    if timer ~= nil and not timer:IsCancelled() then timer:Cancel() end
end

function core.Logic:Show()
    core.Logic:UpdateCharges()
    if InCombatLockdown() then return end
    core.frame:Show()
end

function core.Logic:UpdateCharges()
    -- raise ally spell id
    local chargeInfo = C_Spell.GetSpellCharges(61999)
    local currentCharges = nil
    local cooldownStartTime = nil
    local cooldownDuration = nil
    local chargeModRate = nil

    if core.editModeActive then
        currentCharges = 1
        cooldownStartTime = GetTime()
        cooldownDuration = 60
        chargeModRate = 1
    elseif chargeInfo then
        currentCharges = chargeInfo.currentCharges
        cooldownStartTime = chargeInfo.cooldownStartTime
        cooldownDuration = chargeInfo.cooldownDuration
        chargeModRate = chargeInfo.chargeModRate
    end

    if chargeInfo or core.editModeActive then
        core:SetChargesText(currentCharges)
        local timeLeft = cooldownDuration - (GetTime() - cooldownStartTime)
        core:SetCooldownText(timeLeft > 0 and floor(timeLeft) or '')
        core:SetCooldown(cooldownStartTime, cooldownDuration)

        if timeLeft < 0 then
            if timer and not timer:IsCancelled() then timer:Cancel() end
            return
        end


        if (timer == nil or timer:IsCancelled()) and not core.editModeActive then
            timer = C_Timer.NewTicker(chargeModRate, function()
                chargeInfo = C_Spell.GetSpellCharges(61999)
                timeLeft = not chargeInfo and 0 or
                    chargeInfo.cooldownDuration - (GetTime() - chargeInfo.cooldownStartTime)
                core:SetCooldownText(timeLeft > 0 and floor(timeLeft) or '')
                if timeLeft < 0 and timer then
                    timer:Cancel()
                end
            end)
        end
    end
end
