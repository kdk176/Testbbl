if not GetResourceState('qbx_core'):find('start') then return end

local QBXPlayerData = exports.qbx_core:GetPlayerData()
local serverId = cache.serverId

PlayerData = {
    isLoggedIn = LocalPlayer.state.isLoggedIn,
    isDead = IsEntityDead(cache.ped) or QBXPlayerData?.metadata?.inlaststand or QBXPlayerData?.metadata?.isdead,
    job = QBXPlayerData?.job,
    gang = QBXPlayerData?.gang,
    money = QBXPlayerData?.money,
    hunger = 100,
    thirst = 100,
    stress = 0
}

local function updateStatus()
    SendUIAction('status:set', {
        hunger = PlayerData.hunger,
        thirst = PlayerData.thirst,
        stress = Config.EnableStress and PlayerData.stress,
    })
end

local function updateHUDData()
    if not Config.ShowPlayerInfo then return end

    SendUIAction('hud:updateData', {
        id = serverId,
        job = PlayerData.job.label,
        jobGrade = PlayerData.job.grade.name,
        gang = PlayerData.gang.name ~= 'none' and PlayerData.gang.label,
        gangGrade = PlayerData.gang.grade.name,
        cash = PlayerData.money.cash,
        bank = PlayerData.money.bank,
    })
end

local function initializePlayerData()
    QBXPlayerData = exports.qbx_core:GetPlayerData()
    PlayerData.hunger = QBXPlayerData.metadata.hunger
    PlayerData.thirst = QBXPlayerData.metadata.thirst
    PlayerData.stress = QBXPlayerData.metadata.stress

    PlayerData.job = QBXPlayerData.job
    PlayerData.gang = QBXPlayerData.gang
    PlayerData.money = QBXPlayerData.money

    updateStatus()
    updateHUDData()
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    Wait(2000)
    PlayerData.isLoggedIn = true
    InitializeHUD()

    while not HUDLoaded do Wait(100) end

    initializePlayerData()
end)

RegisterNetEvent('qbx_core:client:playerLoggedOut', function()
    PlayerData.isLoggedIn = false
    HUDLoaded = false
    SendUIAction('hud:toggle', HUDLoaded)
end)

AddEventHandler('onResourceStart', function(resourceName)
    if cache.resource ~= resourceName then return end
    if not PlayerData.isLoggedIn then return end
    while not HUDLoaded do Wait(100) end

    initializePlayerData()
end)

RegisterNetEvent('hud:client:UpdateNeeds', function(newHunger, newThirst)
    PlayerData.hunger = newHunger
    PlayerData.thirst = newThirst

    updateStatus()
end)

RegisterNetEvent('hud:client:UpdateStress', function(newStress)
    PlayerData.stress = newStress

    updateStatus()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
    PlayerData.job = job

    updateHUDData()
end)

RegisterNetEvent('QBCore:Client:OnGangUpdate', function(gang)
    PlayerData.gang = gang

    updateHUDData()
end)

RegisterNetEvent('QBCore:Client:OnMoneyChange', function(moneytype, amount, operation, reason)
    if operation == 'add' then
        PlayerData.money[moneytype] = PlayerData.money[moneytype] + amount
    elseif operation == 'remove' then
        PlayerData.money[moneytype] = PlayerData.money[moneytype] - amount
    elseif operation == 'set' then
        PlayerData.money[moneytype] = amount
    end

    updateHUDData()
end)

AddStateBagChangeHandler('isDead', ('player:%s'):format(serverId), function(_, _, value)
    PlayerData.isDead = value or false
end)
