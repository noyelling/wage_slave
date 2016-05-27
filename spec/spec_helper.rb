$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

# Load gem and all of its dependencies
require 'wage_slave'

# Load a testable environment
require 'dotenv'
Dotenv.load

require 'mocha'
require 'minitest'
require 'minitest/spec'
require 'mocha/mini_test'
require 'minitest/autorun'
require 'minitest/pride'
