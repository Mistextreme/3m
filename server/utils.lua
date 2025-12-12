Utils = Utils or {}


Utils.FW = 'esx'  
local ESX, QBCore = nil, nil

local function started(name) return GetResourceState(name) == 'started' end

CreateThread(function()
  if Config and Config.Framework then
    local fw = string.lower(Config.Framework)
    if fw == 'qb' or fw == 'qbc' or fw == 'qbcore' then
      Utils.FW = 'qb'
    elseif fw == 'esx' then
      Utils.FW = 'esx'
    end
  end

  if started('qb-core') then
    local ok, core = pcall(function() return exports['qb-core']:GetCoreObject() end)
    if ok and core then
      QBCore = core
      if Utils.FW ~= 'esx' then
        Utils.FW = 'qb'
      end
    end
  end

  if started('es_extended') then
    if ESX == nil then
      local ok1, so = pcall(function() return exports['es_extended']:getSharedObject() end)
      if ok1 and so then ESX = so end
      if not ESX then
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
      end
    end
    if ESX and Utils.FW ~= 'qb' then
      Utils.FW = 'esx'
    end
  end

end)

function Utils.PlayerFromSrc(src)
  if Utils.FW == 'qb' and QBCore and QBCore.Functions and QBCore.Functions.GetPlayer then
    return QBCore.Functions.GetPlayer(src)
  end
  if ESX and ESX.GetPlayerFromId then
    return ESX.GetPlayerFromId(src)
  end
  return nil
end

function Utils.GetIdentifier(xPlayer)
  if not xPlayer then return nil end
  if Utils.FW == 'qb' then
    return xPlayer.PlayerData and xPlayer.PlayerData.citizenid
  else
    return xPlayer.identifier
  end
end

function Utils.GetName(xPlayer)
  if not xPlayer then return nil end
  if Utils.FW == 'qb' then
    return xPlayer.PlayerData and xPlayer.PlayerData.name
  else
    if xPlayer.getName then return xPlayer.getName() end
    return xPlayer.name
  end
end

function Utils.GetBank(xPlayer)
  if not xPlayer then return 0 end
  if Utils.FW == 'qb' then
    local f = xPlayer.Functions
    if f and f.GetMoney then
      return tonumber(f.GetMoney('bank') or 0) or 0
    end
    return 0
  else
    local acc = xPlayer.getAccount and xPlayer.getAccount('bank')
    return (acc and tonumber(acc.money) or 0) or 0
  end
end

function Utils.RemoveBank(xPlayer, amount, reason)
  amount = math.floor(tonumber(amount) or 0)
  if amount <= 0 or not xPlayer then return false end
  if Utils.FW == 'qb' then
    if xPlayer.Functions and xPlayer.Functions.RemoveMoney then
      xPlayer.Functions.RemoveMoney('bank', amount, reason or '3M Dealership')
      return true
    end
    return false
  else
    if xPlayer.removeAccountMoney then
      xPlayer.removeAccountMoney('bank', amount)
      return true
    end
    return false
  end
end

function Utils.TryRemoveBank(xPlayer, amount)
  local bal = Utils.GetBank(xPlayer)
  if bal >= (tonumber(amount) or 0) then
    return Utils.RemoveBank(xPlayer, amount, '3M Dealership')
  end
  return false
end

function Utils.AddBank(identifier, amount)
  amount = math.floor(tonumber(amount) or 0)
  if amount <= 0 or not identifier then return end

  if Utils.FW == 'qb' then
    MySQL.update(
      'UPDATE players SET money = JSON_SET(money, "$.bank", JSON_EXTRACT(money, "$.bank") + ?) WHERE citizenid = ?',
      { amount, identifier }
    )
  else
    MySQL.update('UPDATE users SET bank = bank + ? WHERE identifier = ?', { amount, identifier })
  end
end

function Utils.NormalizePlate(p)
  if not p or type(p) ~= 'string' then return p end
  return (string.gsub(string.upper(p), "%s+", "")) 
end

function Utils.RandomPlate()
  return ('3M%03d%s'):format(math.random(0,999), string.char(65+math.random(0,25),65+math.random(0,25)))
end

function Utils.EncodeVehicleJson(model, plate, extra)
  local data = { model = model, plate = plate }
  if type(extra) == 'table' then
    for k,v in pairs(extra) do data[k] = v end
  end
  return json.encode(data)
end

function Utils.DecodeVehicleJson(raw)
  if not raw or raw == '' then return nil, nil, nil, raw end
  if type(raw) == 'table' then
    return raw.model, raw.plate, raw, raw
  end
  if type(raw) == 'string' then
    local ok, parsed = pcall(json.decode, raw)
    if ok and type(parsed) == 'table' then
      return parsed.model, parsed.plate, parsed, raw
    else
      return raw, nil, nil, raw
    end
  end
  return nil, nil, nil, raw
end


function Utils.FreezeVehicle(entity, freeze)
  SetEntityCanBeDamaged(entity, not freeze)
  FreezeEntityPosition(entity, freeze)
  SetVehicleDoorsLocked(entity, 2)
  if Config.Consignment and Config.Consignment.ShowBulletproof then
    SetVehicleTyresCanBurst(entity, false)
    SetVehicleStrong(entity, true)
  end
end

local function _truthy(x) return x == true or x == 1 end

function Utils.GiveKey(src, plate)
  local sys = Config.Keys and Config.Keys.System
  plate = Utils.NormalizePlate(plate)
  if not sys or not plate or not src then return false, 'bad-args' end

  if sys == 'wasabi' then
    if GetResourceState('wasabi_carlock') ~= 'started' then
      return false, 'wasabi-not-started'
    end
    local ok, err = pcall(function()
      exports['wasabi_carlock']:GiveKey(src, plate)
    end)
    if ok then
      if Config.Keys.Debug then
      end
      return true
    end
    if Config.Keys.Debug then
    end
    TriggerClientEvent('3m_dealership:cl_givekey', src, plate, 'wasabi')
    return true

  elseif sys == 'qs' then
    if GetResourceState('qs-vehiclekeys') ~= 'started' then
      return false, 'qs-not-started'
    end
    local ok, err = pcall(function()
      exports['qs-vehiclekeys']:GiveKeys(src, plate)
    end)
    if ok then return true end
    if Config.Keys.Debug then
    end
    TriggerClientEvent('3m_dealership:cl_givekey', src, plate, 'qs')
    return true

  elseif sys == 'custom' then
    local map = Config.Keys.GiveKeyExport and Config.Keys.GiveKeyExport.custom
    if map and map.resource ~= '' and map.export ~= '' and GetResourceState(map.resource) == 'started' then
      local ok = pcall(function()
        exports[map.resource][map.export](src, plate)
      end)
      if ok then return true end
      if Config.Keys.Debug then
      end
    end
    return false, 'custom-missing'
  end

  return false, 'unknown-system'
end

function Utils.RemoveKey(src, plate)
  local sys = Config.Keys and Config.Keys.System
  plate = Utils.NormalizePlate(plate)
  if not sys or not plate or not src then return false, 'bad-args' end

  if sys == 'wasabi' then
    if GetResourceState('wasabi_carlock') ~= 'started' then
      return false, 'wasabi-not-started'
    end
    local ok = pcall(function() exports['wasabi_carlock']:RemoveKey(src, plate) end)
    if ok then
      if Config.Keys.Debug then
      end
      return true
    end
    ok = pcall(function() exports['wasabi_carlock']:RemoveKey(plate) end)
    if ok then
      if Config.Keys.Debug then
      end
      return true
    end
    return false, 'wasabi-remove-failed'

  elseif sys == 'qs' then
    if GetResourceState('qs-vehiclekeys') ~= 'started' then
      return false, 'qs-not-started'
    end
    local ok = pcall(function() exports['qs-vehiclekeys']:RemoveKeys(src, plate) end)
    if ok then return true end
    ok = pcall(function() exports['qs-vehiclekeys']:RemoveKeys(plate) end)
    if ok then return true end
    return false, 'qs-remove-failed'

  elseif sys == 'custom' then
    local map = Config.Keys.RemoveKeyExport and Config.Keys.RemoveKeyExport.custom
    if map and map.resource ~= '' and map.export ~= '' and GetResourceState(map.resource) == 'started' then
      local ok = pcall(function() exports[map.resource][map.export](src, plate) end)
      if ok then return true end
      ok = pcall(function() exports[map.resource][map.export](plate) end)
      if ok then return true end
    end
    return false, 'custom-remove-missing'
  end

  return false, 'unknown-system'
end

local function postWebhook(url, embeds)
  if not url or url == '' then return end
  PerformHttpRequest(url, function() end, 'POST', json.encode({ embeds = embeds }), { ['Content-Type']='application/json' })
end

function Utils.LogPurchase(data)
  if not Config.Webhooks or not Config.Webhooks.Purchase or Config.Webhooks.Purchase == '' then return end
  postWebhook(Config.Webhooks.Purchase, {
    {
      title = 'Vehicle Purchased',
      color = 56108,
      fields = {
        { name='Player', value=(data.name or '?')..' ('..(data.identifier or '?')..')', inline=false },
        { name='Model', value=tostring(data.model or '?'), inline=true },
        { name='Plate', value=tostring(data.plate or '?'), inline=true },
        { name='Price', value='$'..tostring(data.price or 0), inline=true },
        { name='Dealer', value=tostring(data.dealerId or '?'), inline=true },
      },
      timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ')
    }
  })
end

function Utils.LogFinance(data)
  if not Config.Webhooks or not Config.Webhooks.Finance or Config.Webhooks.Finance == '' then return end
  postWebhook(Config.Webhooks.Finance, {
    {
      title = 'Finance Event',
      color = 3447003,
      fields = {
        { name='Player', value=(data.name or '?')..' ('..(data.identifier or '?')..')', inline=false },
        { name='Model', value=tostring(data.model or '?'), inline=true },
        { name='Plate', value=tostring(data.plate or '?'), inline=true },
        { name='Action', value=tostring(data.action or '?'), inline=true },
        { name='Amount', value='$'..tostring(data.amount or 0), inline=true }
      },
      timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ')
    }
  })
end

function Utils.LogRepo(data)
  if not Config.Webhooks or not Config.Webhooks.Repo or Config.Webhooks.Repo == '' then return end
  postWebhook(Config.Webhooks.Repo, {
    {
      title = 'Vehicle Repossessed',
      color = 15548997,
      fields = {
        { name='Player', value=(data.name or '?')..' ('..(data.identifier or '?')..')', inline=false },
        { name='Model', value=tostring(data.model or '?'), inline=true },
        { name='Plate', value=tostring(data.plate or '?'), inline=true }
      },
      timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ')
    }
  })
end

function Utils.LogConsign(data)
  if not Config.Webhooks or not Config.Webhooks.Consign or Config.Webhooks.Consign == '' then return end
  postWebhook(Config.Webhooks.Consign, {
    {
      title = 'Consignment',
      color = 15844367,
      fields = {
        { name='Seller', value=(data.sellerName or '?')..' ('..(data.sellerId or '?')..')', inline=false },
        { name='Model', value=tostring(data.model or '?'), inline=true },
        { name='Plate', value=tostring(data.plate or '?'), inline=true },
        { name='Price', value='$'..tostring(data.price or 0), inline=true }
      },
      timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ')
    }
  })
end
