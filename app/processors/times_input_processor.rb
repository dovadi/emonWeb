class TimesInputProcessor < Processor

  def self.description
    'x Input'
  end

  def perform
    input = Input.find(@argument)
    input.last_value * @value
  end

end
