describe OffsetProcessor do

  it 'should tell data should not be stored' do
    OffsetProcessor.store?.should == false
  end

  it 'should tell its description' do
    OffsetProcessor.description.should == 'Offset'
  end

  it 'should multiply a given value' do
    processor = OffsetProcessor.new(12.25, 2)
    processor.perform.should == 14.25
  end
end
