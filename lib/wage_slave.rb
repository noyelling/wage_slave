require 'xeroizer'
require 'aba'
require 'dotenv'

# Require config
require 'wage_slave/configuration'

# Require modules
require 'wage_slave/models/invoice'
require 'wage_slave/payroll'

# Require config script
Dotenv.load
require 'wage_slave/demo_config_script'