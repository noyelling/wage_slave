require 'xeroizer'
require 'aba'
require 'dotenv'

# Require config
require 'wage_slave/configuration'

# Require modules
require 'wage_slave/models/invoice'
require 'wage_slave/payroll'
require 'wage_slave/services/build_invoices'

# Require config script
Dotenv.load
require 'wage_slave/demo_config_script'