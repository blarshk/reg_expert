# RegExpert: An Expressive DSL for Creating Regular Expressions

RegExpert is a tiny Ruby library for creating regular expressions of varying complexity with an easy-to-understand syntax suitable for all applications!

### How to Use It

```ruby
  test_string = '2014-01-01'

  regexp = RegExpert.new
    .exactly(4).digits
    .find('-')
    .exactly(2).digits
    .find('-')
    .exactly(2).digits

  regexp.to_regex # => /\d{4}[-]\d{2}[-]\d{2}\b/

  regexp.match('2014-01-01') # => #<MatchData "2014-01-01">

  regexp.match("They're taking the hobbits to Isengard!") # => nil
```