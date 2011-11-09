describe ScaleProcessor do
  it 'should multiply a given value' do
    processor = ScaleProcessor.new(12.25, 2)
    processor.perform.should == 24.5
  end
end
