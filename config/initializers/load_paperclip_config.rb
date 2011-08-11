# -*- encoding : utf-8 -*-
PAPERCLIP_CONFIG = YAML.load(ERB.new(File.read("#{Rails.root}/config/paperclip_config.yml")).result)[Rails.env].symbolize_keys
