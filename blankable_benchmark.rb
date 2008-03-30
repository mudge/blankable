#!/usr/bin/env ruby

# Ruby Blankable Mixin Benchmark
# See http://mucur.name/posts/ruby-blankable-mixin for more information.
#
# Copyright (c) Paul Mucur (http://mucur.name), 2008.
# Licensed under the BSD License (LICENSE.txt).

require 'benchmark'

module Blankable
  def values_blank_loop?
    result = true
    for value in blankable_values
      result &&= if value.respond_to?(:values_blank?)
        value.values_blank?
      elsif value.respond_to?(:blank?)
        value.blank?
      elsif value.respond_to?(:empty?)
        value.empty?
      else
        value.nil?
      end
      break(result) unless result
    end
    result
  end
  
  def values_blank_inject?
    blankable_values.inject(true) do |result, value|
      result && if value.respond_to?(:values_blank?)
        value.values_blank?
      elsif value.respond_to?(:blank?)
        value.blank?
      elsif value.respond_to?(:empty?)
        value.empty?
      else
        value.nil?
      end
    end
  end
end

class Hash
  include Blankable
  def blankable_values
    values
  end
end

class Array
  include Blankable
  def blankable_values
    self
  end
end

n = 10_000
a = {}
1000.times do
  a[rand(1000)] = rand(1000)
end
Benchmark.bm do |x|
  x.report("inject") { n.times { a.values_blank_inject? } }
  x.report("loop  ") { n.times { a.values_blank_loop? } }
end