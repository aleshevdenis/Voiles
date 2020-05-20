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

# Decorator to modify method inputs.
#
# For more information read
# {README}[https://github.com/denistreshchev/Voiles/blob/master/README.md] file.
#
# Author:: Denis Treshchev (denistreshchev@gmail.com)
# Copyright:: Copyright (c) 2020 Denis Treshchev
# License:: MIT
class AlterIn
  def initialize(origin, methods = {})
    @originaldata = origin
    @methods = methods
  end

  def to_r
    method_missing(:to_r)
  end

  def to_json(options = nil)
    return @originaldata.to_a.to_json(options) if @originaldata.is_a?(Array)
    method_missing(:to_json, options)
  end

  def method_missing(*args)
    method = args[0]
    unless @originaldata.respond_to?(method)
      raise "Method #{method} is absent in #{@originaldata}"
    end
    inputs = args[1..-1]
    inputs = @methods[method].call(inputs) if @methods.key?(method)
    if block_given?
      @originaldata.__send__(*([method] + inputs)) do |*a|
        yield(*a)
      end
    else
      @originaldata.__send__(*([method] + inputs))
    end
  end

  def respond_to?(method, include_private = false)
    @originaldata.respond_to?(method, include_private) || @methods[method]
  end

  def respond_to_missing?(_method, _include_private = false)
    true
  end
end
