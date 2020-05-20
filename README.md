












[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/denistreshchev/Voiles/blob/master/LICENSE.txt)




First, install it:

```bash
$ gem install Voiles
```

Then, use it like this:

```ruby
require 'Voiles'
obj = Veil.new(obj, to_r: 'Hello, world!')
```

The method `to_r` will return `Hello, world!` until some other
method is called and the Voiles is "pierced."

Take into account that `Veil` is thread-safe.

You can also use `Impenetrable` decorator, which can sometimes be treated differently:
a very good instrument for data memoization.

You can also try `AlterOut`, which lets you modify the output
of object methods on fly:

```ruby
require 'alterout'
obj = AlterOut.new(obj, to_r: proc { |s| s + 'extra tail' })
```

There is also `AlterIn` decorator, to modify incoming method arguments
(the result of the `proc` will replace the list of input arguments):

```ruby
require 'alterin'
obj = AlterIn.new(obj, print: proc { |i| [i + 1] })
```

## How to contribute


Make sure you build is green before you contribute
your pull request. You will need to have [Ruby](https://www.ruby-lang.org/en/) 2.3+ and
[Bundler](https://bundler.io/) installed. Then:

```
$ bundle update
$ bundle exec rake
```

If it's clean and you don't see any error messages, submit your pull request.
