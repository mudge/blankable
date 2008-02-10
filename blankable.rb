# Ruby Blankable Mixin
# A mixin to add a `values_blank?` method to objects to determine whether their
# values are blank or not.
# 
# e.g.
#  {:a => '', :b => {:c => nil}}.values_blank?  #=> true
#  ['', nil, '', ''].values_blank?              #=> true
# 
# See http://mucur.name/posts/ruby-blankable-mixin for more information.
#
# Copyright (c) Paul Mucur (http://mucur.name), 2008.
# Licensed under the BSD License (LICENSE.txt).

module Blankable
  def values_blank?
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
