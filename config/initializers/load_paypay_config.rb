local_paypal_config = File.join(File.dirname(__FILE__), '../../tmp/paypal_config.yml')
default_paypal_config = File.join(File.dirname(__FILE__), '../../config/paypal_config.yml')

raw_config = File.read(File.exists?(local_paypal_config) ? local_paypal_config : default_paypal_config)

PAYPAL_CONFIG = YAML.load(raw_config)[RAILS_ENV].symbolize_keys
