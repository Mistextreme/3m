Config = {}

Config.Framework = 'esx'              -- ESX/qb
Config.Locale    = 'en'               -- 'hr' / 'en'
Config.Currency  = 'bank'             
Config.UseNUIOnly = true              -- true: everything goes trought NUI/prompts; false: let  helptext overlay
Config.UseOxTarget = true
Config.Webhooks = {                   
  Purchase   = '', -- url
  Finance    = '',
  Repo       = '',
  Consign    = ''
}
Config.Notification = {
  provider = 'okok',   -- 'ox', 'esx', 'okok', 'brutal' you can add more in client/notify.lua 
  title = '3M Dealership',
}
Config.Dealer = Config.Dealer or {}
Config.Dealer.NpcCleanup = 'despawn'
-- Keys adapter
Config.Keys = {
  System = 'wasabi',                  -- 'wasabi' | 'qs' | 'custom'
  GiveKeyExport = {
    wasabi = { resource = 'wasabi_carlock', export = 'GiveKey' },    -- (plate)
    qs     = { resource = 'qs-vehiclekeys', export = 'GiveKeys' },   -- (src, plate) or (plate) depends on resource
    custom = { resource = '', export = '' }
  },
  RemoveKeyExport = {
    wasabi = { resource = 'wasabi_carlock', export = 'RemoveKey' },  -- (plate)
    qs     = { resource = 'qs-vehiclekeys', export = 'RemoveKeys' }, -- (src, plate) or (plate)
    custom = { resource = '', export = '' }
  }
}


-- ⬇ Multiple Cardealers
Config.Dealerships = {
  {
    id = 'town',   -- must be unique
    label = 'Town Cardealer',
    pedModel = 'a_m_y_bevhills_01',
    salesman = vec4(-50.9984, -1099.9661, 25.4224, 338.5514),
    keyNpc   = vec4(-56.3918, -1098.7140, 25.4223, 24.7776),
    blip = {
    enabled = true,
    sprite  = 225,      -- icon (ex. car showroom)
    color   = 1,        -- colour
    scale   = 0.6,      -- size
    shortRange = true,  -- show only close
    name    = 'Town Cardealer'  -- Name it however you want
    },
    preview  = {
      vehicle = vec4(-7.4991,  -1068.9972, 37.1520, 270.8226),
      camera  = vec4( 6.6876,  -1074.7871, 42.2384,  57.0593),
    },
    delivery = vec4(-59.9244, -1072.8881, 26.2115, 87.9973),
    testdrive = { spawn = vec4(-71.9186, -1088.0138, 26.6502, 340.4894) },
    -- Here you can add more or remove current showroom cars
    showroom = {
      { model='sultan',  coords=vec4(-48.3791, -1093.9758, 25.4224, 179.2308) },
      { model='kuruma',  coords=vec4(-43.2553, -1095.3300, 25.4223, 173.7430) },
      { model='burrito', coords=vec4(-38.6413, -1096.3271, 25.4223, 158.1018) },
      { model='phoenix', coords=vec4(-48.4437, -1101.4122, 25.4223, 340.3032) },
    },
    keyNpcWindowMinutes = 15, -- how much time you have to pick up keys for bought vehicle
    useCinematic = true,
  },

  {
    id = 'premium',  -- must be unique
    label = 'Premium Autosalon',
    pedModel = 'a_m_y_business_03',
    salesman = vec4(-801.0225, -1339.2755, 4.1503, 351.0551),
    keyNpc   = vec4(-804.3856, -1339.0571, 4.1503, 349.7329),
    blip = {
    enabled = true,
    sprite  = 225,
    color   = 5,
    scale   = 0.6,
    shortRange = true,
    name    = 'Premium Autos'
    },
    preview  = {
      vehicle = vec4(-800.1367, -1310.0168, 5.0004, 349.8256),
      camera  = vec4(-801.5651, -1320.7386, 10.0004, 351.5711),
    },
    delivery = vec4(-816.2618, -1326.8326, 5.0004, 262.5815),
    testdrive = { spawn = vec4(-809.1573, -1320.3594, 5.0004, 170.7536) },
    showroom = {
      { model='banshee', coords=vec4(-817.1800, -1312.0310, 5.0004, 351.5221) },
      { model='ninef',   coords=vec4(-814.1978, -1311.9993, 5.0004, 359.1230) },
    },
    keyNpcWindowMinutes = 15,
    useCinematic = true,
  },
}

-- Test drive
Config.TestDrive = {
  Enabled = true,
  DurationSec = 120,
  Mode = 'normal',   -- leave it as it is, in next updates here you will be able to change mode 
  ExitEnds = true,
  CleanReturnBonus = 0,    -- same here, this is just preparation for update
  Spawn = vec4(-71.9186, -1088.0138, 26.6502, 340.4894), -- <<< spawn of vehicle
  AntiExploit = {
    BlockGarageStore = true,
    BlockModShop     = true,
    DespawnOnLeave   = true
  }
}

-- Dynamic store (48h popularity)
Config.Market = {
  Enabled = true,
  WindowHours = 48,  -- means if same car is sold more than TriggerSoldThreshold = x it will change price of car for StepPercent
  TriggerSoldThreshold = 5,   -- after >5 of same model, changing delta
  StepPercent = 5,            -- +5% per jump (configurable)
  CapUp = 30,                 -- max +30%
  CapDown = 20,               -- max -20% 
  RecomputeIntervalMin = 1,  -- soft interval za re-calc (server tick)
}

-- Finance (credit)
Config.Finance = {
  Enabled = true,
  DownPaymentPct = 20,        -- advance 20%
  FinanceMarkupPct = 5,       -- Vehicle on financing is 5% more expensive
  MinInstallments    = 1,      -- min installments
  MaxInstallments    = 12,     --  max installments
  DuePerPlaytimeHours = 1,    -- 0 means 1min its for testing, every other number is 1h so : =5 means 5 hours
  GraceMisses = 1,            -- 1 missed installment = ok; 2 = repo
  Repo = {
    ScanIntervalSec = 60,    -- 10 min scan
    DespawnOnRepo = true      -- delete from owned_vehicles 
  },
  EarlyPayoffDiscountPct = 0  -- 0 = discount if payed early
}
Config.Finance.Debug = true
-- Consignment (used vehicles)
Config.Consignment = {
  Enabled = true,
  NPC = vec4(-1600.9108, -872.8520, 9.8142, 138.0111),
  LotSlots = {
    vec4(-1602.6682, -867.6185, 10.0347, 142.9096),
    vec4(-1605.0168, -865.4246, 10.0464, 144.8811),
    vec4(-1607.4432, -863.6309, 10.0343, 143.1172),
    vec4(-1609.8699, -861.7395, 10.0281, 145.5727),
    vec4(-1612.4432, -859.9300, 10.0197, 145.1201),
    vec4(-1614.8862, -858.0505, 10.0151, 140.6133),
    vec4(-1617.2540, -855.9250, 10.0227, 143.4549),
  },
  MaxPerPlayer = 5,
  --CommissionPct = 10,         -- script commision
  MaxDescLen = 300,
  ShowBulletproof = true,     -- car lot
  AllowMileage = true,
  AllowService = true
}
Config.ConsignTable = 'consign_stock'
Config.HouseCut = 0.10           -- 10% script commision
Config.PayoutAsCash = true       -- always on hands (cash)
Config.MinClaimNotify = 0        -- min for notify (leave 0)
Config.PayoutNpc = vec4(-1602.0427, -871.3299, 9.8614, 135.5478)




-- prices (JSON) + fallback per class
Config.PriceData = 'data/prices.json'
Config.PriceFallbackByClass = {  -- if there is no car in  JSON
  compacts = { min=20000,  max=50000 },
  sedans   = { min=30000,  max=80000 },
  suvs     = { min=50000,  max=120000 },
  coupes   = { min=60000,  max=140000 },
  muscle   = { min=50000,  max=130000 },
  sports   = { min=120000, max=350000 },
  super    = { min=250000, max=500000 },
  motorcycles = { min=15000, max=70000 },
  offroad  = { min=50000,  max=150000 },
  vans     = { min=30000,  max=90000 }
}
if Config.Dealer and not Config.Dealerships then
  local d = Config.Dealer
  Config.Dealerships = {{
    id='legacy', label='Autosalon', pedModel=d.PedModel or 'a_m_y_bevhills_01',
    salesman = d.Salesman, keyNpc = d.KeyNpcCoords,
    preview  = { vehicle = (d.Preview and d.Preview.Vehicle) or d.PreviewVehicle or d.Vehicle,
                 camera  = (d.Preview and d.Preview.Camera)  or d.Camera },
    delivery = d.Delivery, cinematic = d.Cinematic or {}, testdrive = Config.TestDrive or {},
    showroom = d.ShowroomVehicles or {}, keyNpcWindowMinutes = d.KeyNpcWindowMinutes or 15,
    useCinematic = d.UseCinematic ~= false,
  }}
end