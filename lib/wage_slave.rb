require 'xeroizer'
require 'aba'
require 'dotenv'

# Require config
require 'wage_slave/configuration'

# Require modules
require 'wage_slave/payroll'

# Require services
require 'wage_slave/services/base'
require 'wage_slave/services/build_invoices'
require 'wage_slave/services/save_invoices'
require 'wage_slave/services/build_payments'
require 'wage_slave/services/save_payments'

