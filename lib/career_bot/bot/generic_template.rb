class GenericTemplate
  
  def to_hash
    {
      type: 'template',
      payload: {
        template_type: 'generic',
        elements: elements
      }
    }
  end

  private
  
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def elements
    @elements = data.reduce([]) do |result, job|
      result << GenericTemplateElement.new(job).to_hash
    end
  end
end
