class RegExpert
  attr_accessor :steps

  def initialize
    @steps = []
  end

  def match(test_string)
    regex_for_steps.match(test_string)
  end

  def find(arg)
    steps << CharacterStep.new(arg)

    self
  end

  def digit(digit = nil)
    steps << DigitStep.new(digit)

    self
  end

  alias :digits :digit

  def exactly(count)
    @steps << Proc.new do |step|
      Step.new("#{step.regexp_string}{#{count}}")
    end

    self
  end

  def one
    exactly(1)
  end

  def at_least(count)
    @steps << Proc.new do |step|
      Step.new("#{step.regexp_string}{#{count},}")
    end

    self
  end

  def word
    @steps << Step.new("\\b")

    self
  end

  alias :end_of_word :word
  alias :beginning_of_word :word

  def character
    steps << CharacterStep.new

    self
  end

  def space
    @steps << Step.new("\\s")

    self
  end

  alias :characters :character

  def to_regex
    regex_for_steps
  end

  private

  def parsed_steps
    @steps = @steps.map.with_index do |step, index|
      if step.is_a?(Proc)
        parsed_val = step.call(steps[index + 1])

        steps.delete_at(index + 1)

        parsed_val
      else
        step
      end
    end
  end

  def regex_for_steps
    Regexp.new parsed_steps.collect(&:regexp_string).join
  end

  class Step
    attr_accessor :value

    def initialize(value = nil)
      @value = value
    end

    def regexp_string
      value
    end
  end

  class CharacterStep < Step
    def regexp_string
      return "." unless value

      "[#{value}]"
    end
  end

  class DigitStep < Step
    def regexp_string
      "\\d"
    end
  end
end