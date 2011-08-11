# -*- encoding : utf-8 -*-
PAYMENT_CONFIG = YAML.load(ERB.new(File.read("#{Rails.root}/config/payment_config.yml")).result)[Rails.env].symbolize_keys

