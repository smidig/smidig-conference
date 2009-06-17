local_price_config = File.join(File.dirname(__FILE__), '../../tmp/price_config.yml')
default_price_config = File.join(File.dirname(__FILE__), '../../config/price_config.yml')

raw_config = File.read(File.exists?(local_price_config) ? local_price_config : default_price_config)

PRICE_CONFIG = YAML.load(raw_config)[RAILS_ENV].symbolize_keys
