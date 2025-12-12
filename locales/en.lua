Locales = Locales or {}

Locales['en'] = {

  --------------------------------------------------------------------------
  -- Interactions / general labels
  --------------------------------------------------------------------------
  open_dealer      = 'Talk to the dealer',
  open_consign     = 'Sell used vehicle',
  view_vehicle     = 'View',
  test_drive       = 'Test drive',
  buy_cash         = 'Buy (Bank)',
  buy_finance      = 'Buy on finance',
  sign_contract    = 'Sign contract',

  --------------------------------------------------------------------------
  -- Financing / market
  --------------------------------------------------------------------------
  damage_fee_applied        = 'Damage fee: $%s',
  finance_created           = 'Loan created: %s installments',
  finance_paid              = 'Installment paid: $%s (%s/%s)',
  finance_repo              = 'Vehicle repossessed due to non-payment.',
  finance_missed            = 'Not enough money for the installment ($%s). Missed: %d (repo after %d).',
  finance_tick_executed     = 'Finance tick executed.',
  market_badge              = 'Popular: +%s%%',
  finance_invalid_installments = 'Invalid number of installments. Allowed: %s�%s.',

  --------------------------------------------------------------------------
  -- Purchase / status
  --------------------------------------------------------------------------
  consigned_ok              = 'Vehicle listed on the used lot.',
  purchased_ok              = 'Purchased: %s [%s]',
  not_enough_money          = 'Not enough money.',
  desc_too_long             = 'Description too long (max %s characters).',
  admin_only                = 'Admins only.',
  not_in_dealer_catalog     = 'Model is not offered at this dealership.',
  price_unavailable         = 'Price for this model is currently unavailable.',

  --------------------------------------------------------------------------
  -- Keys / pickup
  --------------------------------------------------------------------------
  key_pickup_tip            = 'Approach the seller to pick up keys for %s (valid for ~%d min).',
  no_keys_ready             = 'No keys ready to pick up or the time has expired.',
  expired                   = 'Key pickup time has expired.',
  keys_given                = 'Keys handed over for %s.',
  take_keys                 = 'Take Keys',

  --------------------------------------------------------------------------
  -- Test drive
  --------------------------------------------------------------------------
  td_timeout                = 'Test drive ended: time expired. Keys removed.',
  td_removed                = 'Keys have been removed.',

  --------------------------------------------------------------------------
  -- Consign (used cars)  messages (server & client)
  --------------------------------------------------------------------------
  consign_disabled              = 'Used sales are currently unavailable.',
  consign_invalid_data          = 'Invalid data.',
  consign_no_slots              = 'No slots defined.',
  consign_identity_error        = 'Identity error.',
  consign_limit_reached         = 'You reached the limit of active listings (%d).',
  consign_not_owner_or_missing  = "That vehicle isn't yours or it doesn't exist.",
  consign_all_slots_busy        = 'All slots are occupied.',
  consign_save_failed           = 'Failed to save listing.',
  consign_listed_ok             = 'Vehicle %s listed for $%d (slot #%d).',
  consign_not_found_or_inactive = 'Listing not found or not active.',
  consign_not_your_listing      = 'This is not your listing.',
  consign_removed_ok            = 'Listing removed. Vehicle returned to your garage list.',
  consign_buy_not_available     = 'Listing not available.',
  consign_price_invalid         = 'Invalid price.',
  consign_no_funds              = 'Not enough funds in bank.',
  consign_bought_ok             = 'You bought %s for $%d.',
  consign_seller_sold           = 'Your vehicle %s was sold. Collect payout from the seller at the dealership.',
  consign_no_payouts            = 'No payouts to collect.',
  consign_payout_ok             = 'You collected a payout: $%d.',
  consign_id_error              = "Error: couldn't read your identifier",
  consign_no_valid_payouts      = 'No valid payouts.',
  consign_payout_cash_ok        = 'You collected $%d in cash (commission %d%%). Thank you!',
  consign_nav_to_slot           = 'Navigation to slot #%d set.',

  -- Payout NPC (label + hint)
  consign_claim_label           = 'Collect sale earnings',
  consign_claim_hint            = '[E] Collect sale earnings',

  --------------------------------------------------------------------------
  -- Consign  Target/NUI helper labels (UI consistency)
  --------------------------------------------------------------------------
  ponuda                       = '%s [%s] � open offer',
  buy_used                     = 'Buy',
  remove_consign               = 'Remove vehicle from sale',
  show_list_consign            = 'Show vehicle offers',
  show_mine_consing            = 'My vehicles for sale', -- key kept as-is


  ------------
  -- NUi
  ----------
  -- ===== NUI (UI) =====
ui_search              = 'Search…',
ui_sort_name           = 'Name',
ui_sort_price          = 'Price',
ui_hint_controls       = 'Tip: scroll=zoom • click&drag=rotate',
ui_pick_vehicle        = 'Select a vehicle',
ui_exit                = 'Exit',

ui_primary             = 'Primary',
ui_secondary           = 'Secondary',
ui_apply               = 'Apply',

ui_all_categories      = 'All categories',
ui_cat_other           = 'Other',

ui_view_title          = 'Vehicle preview',
ui_model               = 'Model',
ui_category            = 'Category',
ui_price               = 'Price',
ui_close               = 'Close',

ui_buy_title           = 'Purchase',
ui_cancel              = 'Cancel',
ui_confirm             = 'Confirm',

ui_vehicle             = 'Vehicle',
ui_duration            = 'Duration',
ui_start               = 'Start',

ui_pay_now             = 'Pay now',
ui_installments_count  = 'Installments',
ui_simulation          = 'Simulation',
ui_method              = 'Method',
ui_method_cash         = 'Cash',
ui_method_finance      = 'Finance',
ui_price_with_markup   = 'Price (with markup)',
ui_installment         = 'Installment',

ui_loading             = 'Loading…',
ui_no_desc             = 'No description.',
ui_no_vehicles         = 'You have no vehicles',
ui_no_listings         = 'You have no active listings.',
ui_refresh             = 'Refresh',

-- Used market (NUI)
ui_used_title          = 'Used Market',
ui_used_tab_browse     = 'Browse',
ui_used_tab_sell       = 'Sell vehicle',
ui_used_tab_mine       = 'My listings',
ui_price_usd           = 'Price ($)',
ui_price_placeholder   = 'e.g. 35000',
ui_description         = 'Description',
ui_desc_placeholder    = 'Up to 300 characters…',
ui_slot                = 'Slot',
ui_slot_hint           = 'If occupied, the system auto-selects the first free one.',
ui_put_on_sale         = 'Put on sale',
ui_used_empty          = 'No active listings.',
consign_slot_num       = 'Slot #%s',
ui_slot_and_price      = 'Slot #%s • %s',

-- Buttons/actions already referenced by NUI
buy_cash               = 'Buy',
buy_finance            = 'Finance',
test_drive             = 'Test drive',
buy_used               = 'Buy',
remove_consign         = 'Remove from sale',
podigni_isplatu        = 'Claim payout',

}
