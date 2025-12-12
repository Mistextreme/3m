
---@class VehicleEntry
---@field model string
---@field price number
---@field label string|nil
---@field category string|nil
---@field brand string|nil

---@class DealerCatalog
---@field vehicles VehicleEntry[]

local M = {
  dealers = {
    -- == town dealership ==
    bas = {
      vehicles = {
        { model = 'blista',   price = 12000,  label = 'Blista',       category = 'Compacts',   brand = 'Dinka'     },
        { model = 'panto',    price = 9000,   label = 'Panto',        category = 'Compacts',   brand = 'Benefactor'},
        { model = 'asea',     price = 14000,  label = 'Asea',         category = 'Sedans',     brand = 'Declasse'  },
        { model = 'primo',    price = 18000,  label = 'Primo',        category = 'Sedans',     brand = 'Albany'    },
        { model = 'stanier',  price = 22000,  label = 'Stanier',      category = 'Sedans',     brand = 'Vapid'     },
        { model = 'rebel',    price = 25000,  label = 'Rebel',        category = 'Off-Road',   brand = 'Karin'     },
        { model = 'bison',    price = 26000,  label = 'Bison',        category = 'Utility',    brand = 'Bravado'   },
        { model = 'jackal',   price = 32000,  label = 'Jackal',       category = 'Coupes',     brand = 'Ocelot'    },
        { model = 'futo',     price = 28000,  label = 'Futo',         category = 'Sports',     brand = 'Karin'     },
        { model = 'sultan',   price = 42000,  label = 'Sultan',       category = 'Sedans',     brand = 'Karin'     },
      }
    },

    -- == PREMIUM dealership ==
    premium = {
      vehicles = {
        { model = 'ninef',     price = 120000, label = '9F',           category = 'Sports',       brand = 'Obey'      },
        { model = 'feltzer2',  price = 135000, label = 'Feltzer',      category = 'Sports',       brand = 'Benefactor'},
        { model = 'massacro',  price = 160000, label = 'Massacro',     category = 'Sports',       brand = 'Dewbauchee'},
        { model = 'banshee',   price = 180000, label = 'Banshee',      category = 'Sports',       brand = 'Bravado'   },
        { model = 'carbonizzare', price = 210000, label='Carbonizzare', category='Sports',        brand = 'Grotti'    },
        { model = 'jester',    price = 190000, label = 'Jester',       category = 'Sports',       brand = 'Dinka'     },
        { model = 'entityxf',  price = 350000, label = 'Entity XF',    category = 'Super',        brand = 'Overflod'  },
        { model = 't20',       price = 480000, label = 'T20',          category = 'Super',        brand = 'Progen'    },
        { model = 'osiris',    price = 430000, label = 'Osiris',       category = 'Super',        brand = 'Pegassi'   },
        { model = 'adder',     price = 520000, label = 'Adder',        category = 'Super',        brand = 'Truffade'  },
      }
    },
  }
}

function M.mergeAll()
  local seen, out = {}, {}
  for _, d in pairs(M.dealers) do
    if d and d.vehicles then
      for _, v in ipairs(d.vehicles) do
        if v.model and not seen[v.model] then
          out[#out+1] = v
          seen[v.model] = true
        end
      end
    end
  end
  return out
end

return M
