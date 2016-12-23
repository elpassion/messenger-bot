class GenericTemplate
  def attachment
    @attachment ||= {
      type: 'template',
      payload: {
        template_type: 'generic',
        elements: elements
      }
    }
  end

  private

  def offers
    @offers = WorkableService.new.get_active_jobs
  end

  def elements
    @elements = offers.reduce([]) do |result, job|
      result << GenericTemplateElement.new(job).element
    end
  end
end
