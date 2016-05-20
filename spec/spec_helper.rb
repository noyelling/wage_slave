$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

# Load gem and all of its dependencies
require 'wage_slave'

# Load a testable environment
require 'dotenv'
Dotenv.load

require 'minitest'
require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/pride'
