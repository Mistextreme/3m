local function Lc(key, ...)
  local lang = (Config.Locale or 'hr')
  local dict = (Locales and Locales[lang]) or {}
  local str  = dict[key] or key
  if select('#', ...) > 0 then
    local ok, out = pcall(string.format, str, ...)
    if ok then str = out end
  end
  return str
end

local function mapTypeForCommon(lvl)
  if lvl == 'success' then
    return 'success'
  elseif lvl == 'error' then
    return 'error'
  else
    return 'info'
  end
end

local function mapTypeForOx(lvl)
  -- ox_lib: success | error | inform
  if lvl == 'success' then
    return 'success'
  elseif lvl == 'error' then
    return 'error'
  else
    return 'inform'
  end
end

local Providers = {}

-- ox_lib
Providers.ox = function(title, msg, lvl)
  if lib and lib.notify then
    lib.notify({ title = title, description = msg, type = mapTypeForOx(lvl) })
  else
    BeginTextCommandThefeedPost('STRING')
    AddTextComponentSubstringPlayerName(('%s: %s'):format(title, msg))
    EndTextCommandThefeedPostTicker(false, false)
  end
end

Providers.esx = function(title, msg, lvl)
  local ok = false
  if ESX and ESX.ShowNotification then
    ok = pcall(function() ESX.ShowNotification(('[%s] %s'):format(title, msg)) end)
    if not ok then
      ok = pcall(function() ESX.ShowNotification(('[%s] %s'):format(title, msg), mapTypeForCommon(lvl)) end)
    end
  end
  if not ok then
    SetNotificationTextEntry('STRING')
    AddTextComponentSubstringPlayerName(('%s: %s'):format(title, msg))
    DrawNotification(false, false)
  end
end

-- okokNotify
Providers.okok = function(title, msg, lvl)
  local ok = pcall(function()
    exports['okokNotify']:Alert(title, msg, 5000, mapTypeForCommon(lvl))
  end)
  if not ok then Providers.ox(title, msg, lvl) end
end

Providers.brutal = function(title, msg, lvl)
  local ok = pcall(function()
    TriggerEvent('brutal_notify:send', title, msg, mapTypeForCommon(lvl))
  end)
  if not ok then Providers.ox(title, msg, lvl) end
end


local function dispatch(lvl, rawKey, replacements)
  local notifCfg = (type(Config.Notification) == 'table') and Config.Notification or {}
  local title    = notifCfg.title or '3M'
  local provider = notifCfg.provider or 'ox'


  provider = tostring(provider):gsub('^%s+', ''):gsub('%s+$', ''):lower()


  local args = {}
  if type(replacements) == 'table' then
    args = replacements
  elseif replacements ~= nil then
    args = { replacements }
  end

  local msg = (next(args) and Lc(rawKey, table.unpack(args))) or Lc(rawKey)

  local fn = Providers[provider]
  if type(fn) ~= 'function' then
    fn = Providers.ox
  end

  if type(fn) == 'function' then
    local ok, err = pcall(fn, title, msg, mapTypeForCommon(lvl))
    if not ok then
      BeginTextCommandThefeedPost('STRING')
      AddTextComponentSubstringPlayerName(('%s: %s'):format(title, msg))
      EndTextCommandThefeedPostTicker(false, false)
    end
  else
    BeginTextCommandThefeedPost('STRING')
    AddTextComponentSubstringPlayerName(('%s: %s'):format(title, msg))
    EndTextCommandThefeedPostTicker(false, false)
  end
end


RegisterNetEvent('3m:notify', function(lvl, rawKey, ...)
  dispatch(lvl or 'info', rawKey, { ... })
end)


exports('Notify', function(lvl, rawKey, ...)
  dispatch(lvl or 'info', rawKey, { ... })
end)


