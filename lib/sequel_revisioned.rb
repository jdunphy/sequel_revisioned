$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module SequelRevisioned
  VERSION = '0.0.1'
end

module Sequel
  class InvalidRevisionError < StandardError; end
end

require 'sequel_revisioned/sequel_revisioned'