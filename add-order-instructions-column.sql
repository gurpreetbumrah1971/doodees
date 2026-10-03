-- Adds the special-instructions field customers can fill in at checkout.
-- Safe to run on production: ADD COLUMN only, no data is touched.

ALTER TABLE `order` ADD COLUMN `instructions` text DEFAULT NULL AFTER `address`;
