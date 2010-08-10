local_payment_config = File.join(File.dirname(__FILE__), '../../tmp/payment_config.yml')
default_payment_config = File.join(File.dirname(__FILE__), '../../config/payment_config.yml')

config = File.read(File.exists?(local_payment_config) ? local_payment_config : default_payment_config)

PAYMENT_CONFIG = YAML.load(config)[RAILS_ENV].symbolize_keys
