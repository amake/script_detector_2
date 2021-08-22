# ScriptDetector2

A simple utility for determining whether a string is Japanese, Simplified
Chinese, Traditional Chinese, or Korean. It is intended to be a more accurate
and more performant alternative to the [script_detector
gem](https://rubygems.org/gems/script_detector).

Unlike the original script_detector, this gem:

- Is optimized to reduce temporary garbage in favor of some constant memory
  usage
- Uses the
  [kUnihanCore2020](https://www.unicode.org/reports/tr38/#kUnihanCore2020)
  property of the Unicode Unihan database to determine which characters belong
  to which script (Unicode 13)
  ([details](http://www.unicode.org/L2/L2019/19388-unihan-core-2020.pdf))
- Uses [ISO 15924 script names](https://en.wikipedia.org/wiki/ISO_15924) in
  symbol form as return values (instead of English strings)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'script_detector_2'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install script_detector_2

## Usage

The main detection methods are:

- `ScriptDetector2.japanese?`
- `ScriptDetector2.chinese?`
- `ScriptDetector2.simplified_chinese?`
- `ScriptDetector2.traditional_chinese?`
- `ScriptDetector2.identify_script`

Regexp patterns are used to identify the script to which Han characters belong.
These can be used directly as well:

- `ScriptDetector2::JAPANESE_PATTERN`: matches all Han characters in the
  kUnihanCore2020 set marked as Japanese (J)
- `ScriptDetector2::SIMPLIFIED_CHINESE_PATTERN`: matches all Han characters in
  the kUnihanCore2020 set marked as PRC (G)
- `ScriptDetector2::TRADITIONAL_CHINESE_PATTERN`: matches all Han characters in
  the kUnihanCore2020 set marked as Hong Kong (H), Macau (M), or ROC (T)
- `ScriptDetector2::KOREAN_PATTERN`: matches all Han characters in the
  kUnihanCore2020 set marked as ROK (K) or DPRK (P)

To recreate the script_detector gem's extension of the String class, use the
supplied refinement like so:

```ruby
using ScriptDetector2::StringUtil
```

Then you can do:

```ruby
'こんにちは、世界！'.japanese? # => true
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake test` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and the created tag, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/amake/script_detector_2.

## License

The gem is available as open source under the terms of the [MIT
License](https://opensource.org/licenses/MIT).
