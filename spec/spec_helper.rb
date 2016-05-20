$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'wage_slave'
require 'wage_slave/models/invoice'
require 'wage_slave/services/build_invoices'

# Configure testable environment
require 'dotenv'
Dotenv.load

require 'minitest'
require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/pride'
