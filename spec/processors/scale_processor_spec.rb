describe ScaleProcessor do

  it 'should tell data should not be stored' do
    ScaleProcessor.store?.should == false
  end

  it 'should tell its description' do
    ScaleProcessor.description.should == 'Scale'
  end

  it 'should multiply a given value' do
    processor = ScaleProcessor.new(12.25, 2)
    processor.perform.should == 24.5
  end
end
