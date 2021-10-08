# frozen_string_literal: true

# (The MIT License)
#
# Copyright (c) 2020 Denis Treshchev
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the 'Software'), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

require 'minitest/autorun'
require 'json'
require_relative '../lib/Voiles'

# Veil test.
# Author:: Denis Treshchev (denistreshchev@gmail.com)
# Copyright:: Copyright (c) 2020 Denis Treshchev
# License:: MIT
class VeilTest < Minitest::Test
  def test_simple
    obj = Object.new
    def obj.read(foo)
      foo
    end

    def obj.touch; end
    foo = Veil.new(obj, read: 1)
    assert_equal(1, foo.read(5))
    foo.to_r
    foo.touch
    assert_equal(5, foo.read(5))
  end

  def test_behaves_like_array_with_json
    origin = [1, 2, 3]
    foo = Veil.new(origin)
    assert(foo.respond_to?(:to_json))
    assert_equal(JSON.pretty_generate(origin), JSON.pretty_generate(foo))
  end

  def test_iterates_array
    origin = [1, 2, 3]
    foo = Veil.new(origin, count: 1)
    assert_equal(1, foo.count)
    assert(!foo.empty?)
    assert_equal(3, foo.count)
    observed = 0
    foo.each { |_| observed += 1 }
    assert_equal(3, observed)
  end

  def test_iterates_array_twice
    origin = [1, 2, 3]
    foo = Veil.new(origin, count: 1)
    assert_equal(1, foo.count)
    observed = 0
    foo.each { |_| observed += 1 }
    assert_equal(3, observed)
  end

  def test_respond_to
    foo = Veil.new(Object.new)
    assert_equal(false, foo.respond_to?(:undefine_method))

    foo = Veil.new(Object.new, method_return_object: Object.new)
    assert_equal(true, foo.respond_to?(:method_return_object))

    foo = Veil.new(Object.new, method_return_false: false)
    assert_equal(true, foo.respond_to?(:method_return_false))

    foo = Veil.new(Object.new, method_return_nil: nil)
    assert_equal(true, foo.respond_to?(:method_return_nil))
  end
end
