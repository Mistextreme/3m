Locales = Locales or {}

Locales['hr'] = {

  --------------------------------------------------------------------------
  -- Interakcije / opći labeli
  --------------------------------------------------------------------------
  open_dealer      = 'Razgovaraj s prodavačem',
  open_consign     = 'Prodaj rabljeno vozilo',
  view_vehicle     = 'Pogledaj',
  test_drive       = 'Probna vožnja',
  buy_cash         = 'Kupi (Banka)',
  buy_finance      = 'Kupi na kredit',
  sign_contract    = 'Potpiši ugovor',

  --------------------------------------------------------------------------
  -- Financiranje / tržište
  --------------------------------------------------------------------------
  damage_fee_applied        = 'Naplata štete: $%s',
  finance_created           = 'Kredit kreiran: %s rata',
  finance_paid              = 'Uplaćena rata: $%s (%s/%s)',
  finance_repo              = 'Vozilo oduzeto zbog neplaćanja.',
  finance_missed            = 'Nemaš dovoljno novca za ratu ($%s). Propuštene rate: %d (repo nakon %d).',
  finance_tick_executed     = 'Finance tick izvršen.',
  market_badge              = 'Popularno: +%s%%',
  finance_invalid_installments = 'Nevažeći broj rata. Dozvoljeno: %s–%s.',

  --------------------------------------------------------------------------
  -- Kupnja / stanje
  --------------------------------------------------------------------------
  consigned_ok              = 'Vozilo stavljeno na rabljeni lot.',
  purchased_ok              = 'Kupljeno: %s [%s]',
  not_enough_money          = 'Nemaš dovoljno novca.',
  desc_too_long             = 'Opis predugačak (max %s znakova).',
  admin_only                = 'Samo za admine.',
  not_in_dealer_catalog     = 'Model nije u ponudi ovog salona.',
  price_unavailable         = 'Cijena za ovaj model trenutno nije dostupna.',

  --------------------------------------------------------------------------
  -- Ključevi / preuzimanje
  --------------------------------------------------------------------------
  key_pickup_tip            = 'Priđi prodavaču i preuzmi ključeve za %s (vrijedi ~%d min).',
  no_keys_ready             = 'Nemaš ključeve spremne za preuzimanje ili je isteklo vrijeme.',
  expired                   = 'Vrijeme za preuzimanje ključeva je isteklo.',
  take_keys                = 'Preuzmi ključeve',

  --------------------------------------------------------------------------
  -- Testna vožnja
  --------------------------------------------------------------------------
  td_timeout                = 'Probna vožnja je završila: vrijeme je isteklo. Ključevi oduzeti.',
  td_removed                = 'Ključevi su oduzeti.',

  --------------------------------------------------------------------------
  -- Consign (rabljena vozila) 
  --------------------------------------------------------------------------
  consign_disabled              = 'Prodaja rabljenih je trenutno nedostupna.',
  consign_invalid_data          = 'Neispravni podaci.',
  consign_no_slots              = 'Nema definiranih slotova.',
  consign_identity_error        = 'Greška s identitetom.',
  consign_limit_reached         = 'Dosegao si limit aktivnih oglasa (%d).',
  consign_not_owner_or_missing  = 'To vozilo nije tvoje ili ne postoji.',
  consign_all_slots_busy        = 'Svi slotovi su zauzeti.',
  consign_save_failed           = 'Greška pri spremanju oglasa.',
  consign_listed_ok             = 'Vozilo %s stavljeno na prodaju za $%d (slot #%d).',
  consign_not_found_or_inactive = 'Oglas nije pronađen ili nije aktivan.',
  consign_not_your_listing      = 'To nije tvoj oglas.',
  consign_removed_ok            = 'Oglas uklonjen. Vozilo je vraćeno u tvoj garažni popis.',
  consign_buy_not_available     = 'Oglas nije dostupan.',
  consign_price_invalid         = 'Neispravna cijena.',
  consign_no_funds              = 'Nemaš dovoljno sredstava na banci.',
  consign_bought_ok             = 'Kupio si %s za $%d.',
  consign_seller_sold           = 'Tvoje vozilo %s je prodano. Preuzmi isplatu kod prodavača u salonu.',
  consign_no_payouts            = 'Nema isplata za preuzeti.',
  consign_payout_ok             = 'Preuzeo si isplatu: $%d.',
  consign_id_error              = 'Greška: ne mogu očitati tvoj identifikator',
  consign_no_valid_payouts      = 'Nema valjanih isplata.',
  consign_payout_cash_ok        = 'Preuzeo si $%d u gotovini (provizija %d%%). Hvala!',
  consign_nav_to_slot           = 'Navigacija do slota #%d postavljena.',

  -- Payout NPC (label + hint)
  consign_claim_label           = 'Preuzmi zaradu od prodaje',
  consign_claim_hint            = '[E] Preuzmi zaradu od prodaje',

  --------------------------------------------------------------------------
  -- Consign — Target/NUI 
  --------------------------------------------------------------------------
  ponuda                       = '%s [%s] — otvori ponudu',
  buy_used                     = 'Kupi',
  remove_consign               = 'Ukloni vozilo sa prodaje',
  show_list_consign            = 'Pokaži ponudu vozila',
  show_mine_consing            = 'Moja vozila na prodaju', 

  -------------------------------------------------------------------------
  -- NUI
  -------------------------------------------------------------------------
ui_search              = 'Pretraži…',
ui_sort_name           = 'Naziv',
ui_sort_price          = 'Cijena',
ui_hint_controls       = 'Savjet: scroll=zoom • klik&vuci=rotacija',
ui_pick_vehicle        = 'Odaberi vozilo',
ui_exit                = 'Izađi',

ui_primary             = 'Primarna',
ui_secondary           = 'Sekundarna',
ui_apply               = 'Primijeni',

ui_all_categories      = 'Sve kategorije',
ui_cat_other           = 'Ostalo',

ui_view_title          = 'Pregled vozila',
ui_model               = 'Model',
ui_category            = 'Kategorija',
ui_price               = 'Cijena',
ui_close               = 'Zatvori',

ui_buy_title           = 'Kupnja',
ui_cancel              = 'Odustani',
ui_confirm             = 'Potvrdi',

ui_vehicle             = 'Vozilo',
ui_duration            = 'Trajanje',
ui_start               = 'Pokreni',

ui_pay_now             = 'Plaćaš odmah',
ui_installments_count  = 'Broj rata',
ui_simulation          = 'Simulacija',
ui_method              = 'Način',
ui_method_cash         = 'Gotovina',
ui_method_finance      = 'Financiranje',
ui_price_with_markup   = 'Cijena s maržom',
ui_installment         = 'Rata',

ui_loading             = 'Učitavam…',
ui_no_desc             = 'Nema opisa.',
ui_no_vehicles         = 'Nemaš vozila',
ui_no_listings         = 'Nemaš aktivnih oglasa.',
ui_refresh             = 'Osvježi',

-- Used market (NUI)
ui_used_title          = 'Used Market',
ui_used_tab_browse     = 'Ponuda',
ui_used_tab_sell       = 'Prodaj vozilo',
ui_used_tab_mine       = 'Moji oglasi',
ui_price_usd           = 'Cijena ($)',
ui_price_placeholder   = 'npr. 35000',
ui_description         = 'Opis',
ui_desc_placeholder    = 'Do 300 znakova…',
ui_slot                = 'Slot',
ui_slot_hint           = 'Ako je zauzet, sustav automatski bira prvi slobodan.',
ui_put_on_sale         = 'Stavi na prodaju',
ui_used_empty          = 'Nema aktivnih oglasa.',
consign_slot_num       = 'Slot #%s',
ui_slot_and_price      = 'Slot #%s • %s',

-- Gumbi/akcije koji su već postojali, ali ih NUI koristi
buy_cash               = 'Kupi',
buy_finance            = 'Financiranje',
test_drive             = 'Probna vožnja',
buy_used               = 'Kupi',
remove_consign         = 'Ukloni vozilo sa prodaje',
podigni_isplatu        = 'Podigni isplatu',

}
