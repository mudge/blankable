require 'test/unit'
require 'blankable'

class BlankableTest < Test::Unit::TestCase
  def test_module_included
    assert Array.ancestors.include?(Blankable)
    assert Hash.ancestors.include?(Blankable)
    assert Array.new.respond_to?(:values_blank?)
    assert Hash.new.respond_to?(:values_blank?)
    assert Array.new.respond_to?(:blankable_values)
    assert Hash.new.respond_to?(:blankable_values)
  end
  
  def test_blank_array
    assert ([].values_blank?)
    assert ([''].values_blank?)
    assert ([nil].values_blank?)
    assert (['', nil].values_blank?)
    assert ([[]].values_blank?)
    assert (['', nil, []].values_blank?)
    assert (['', nil, [], {}].values_blank?)
    assert (['', nil, [], {:a => [{:b => ''}]}].values_blank?)
  end
  
  def test_blank_hashes
    assert ({}.values_blank?)
    assert ({:a => ''}.values_blank?)
    assert ({:a => nil}.values_blank?)
    assert ({:a => '', :b => nil}.values_blank?)
    assert ({:a => {:b => ''}}.values_blank?)
    assert ({:a => nil, :b => '', :c => {:a => ''}}.values_blank?)
  end
  
  def test_non_blank_array
    assert !([1].values_blank?)
    assert !([Object.new].values_blank?)
    assert !(['allo'].values_blank?)
    assert !(['', 1].values_blank?)
    assert !([nil, '', ['', 2]].values_blank?)
    assert !([nil, '', ['', {:a => 'a', :b => []}]].values_blank?)
  end
  
  def test_non_blank_hash
    assert !({:a => 'a'}.values_blank?)
    assert !({:a => Object.new}.values_blank?)
    assert !({:a => '', :b => 1}.values_blank?)
    assert !({:a => ['', ''], :b => {:a => [1]}}.values_blank?)
  end
end