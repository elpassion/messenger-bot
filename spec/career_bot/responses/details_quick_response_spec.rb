describe DetailsQuickResponse do

  let(:shortcode_1) { 'shortcode1' }
  let(:shortcode_2) { 'shortcode2' }
  let(:shortcode_3) { 'shortcode3' }
  let(:title_1) { 'Senior Ruby on Rails developer' }
  let(:title_2) { 'Ruby on Rails developer' }
  let(:title_3) { 'UX/UI designer' }
  let(:active_jobs) {
    [
      {
        'title' => title_1,
        'shortcode' => shortcode_1
      },
      {
        'title' => title_2,
        'shortcode' => shortcode_2
      },
      {
        'title' => title_3,
        'shortcode' => shortcode_3
      }
    ]
  }


  before do
    allow_any_instance_of(WorkableService).to receive(:get_jobs).and_return(active_jobs)
  end

  describe '#reply' do
    it 'should return proper data for first job' do
      quick_response = described_class.new(code: shortcode_1, details: 'requirements')
      expect(quick_response.reply).to eq(
                                          {
                                            content_type: 'text',
                                            title: title_1,
                                            payload: "requirements|#{shortcode_1}"
                                          }
                                      )
    end

    it 'should return proper data for another job' do
      quick_response = described_class.new(code: shortcode_3, details: 'benefits')
      expect(quick_response.reply).to eq(
                                          {
                                              content_type: 'text',
                                              title: title_3,
                                              payload: "benefits|#{shortcode_3}"
                                          }
                                      )
    end

    it 'should return when there is no active job with given code' do
      quick_response = described_class.new(code: 'rendom code', details: 'benefits')
      expect(quick_response.reply).to eq(nil)
    end
  end
end