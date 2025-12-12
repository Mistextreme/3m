CREATE TABLE IF NOT EXISTS vehicle_market (
  model VARCHAR(50) PRIMARY KEY,
  base_price INT NOT NULL,
  delta_pct INT NOT NULL DEFAULT 0,
  sold_48h INT NOT NULL DEFAULT 0,
  last_sale_ts INT NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS vehicle_loans (
  id INT AUTO_INCREMENT PRIMARY KEY,
  identifier VARCHAR(60) NOT NULL,
  plate VARCHAR(12) NOT NULL,
  model VARCHAR(50) NOT NULL,
  principal INT NOT NULL,
  installment INT NOT NULL,
  total_installments INT NOT NULL,
  paid_installments INT NOT NULL DEFAULT 0,
  markup_pct INT NOT NULL DEFAULT 0,
  last_progress_playtime INT NOT NULL DEFAULT 0,
  due_per_hours INT NOT NULL DEFAULT 5,
  misses INT NOT NULL DEFAULT 0,
  status VARCHAR(16) NOT NULL DEFAULT 'active'
);

CREATE TABLE IF NOT EXISTS vehicle_consignment (
  id INT AUTO_INCREMENT PRIMARY KEY,
  seller_identifier VARCHAR(60) NOT NULL,
  seller_name VARCHAR(64) NOT NULL,
  plate VARCHAR(12) NOT NULL,
  model VARCHAR(50) NOT NULL,
  price INT NOT NULL,
  description TEXT,
  mileage INT NOT NULL DEFAULT 0,
  serviced TINYINT(1) NOT NULL DEFAULT 0,
  slot_index INT NOT NULL DEFAULT -1,
  state VARCHAR(16) NOT NULL DEFAULT 'listed',
  ts INT NOT NULL
);

CREATE TABLE IF NOT EXISTS payouts_offline (
  id INT AUTO_INCREMENT PRIMARY KEY,
  identifier VARCHAR(60) NOT NULL,
  amount INT NOT NULL,
  reason VARCHAR(64),
  meta TEXT,
  ts INT NOT NULL
);
