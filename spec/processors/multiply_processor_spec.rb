describe MultiplyProcessor do
  it 'should multiply a given value' do
    processor = MultiplyProcessor.new(12.25, [2])
    processor.perform.should == 24.5
  end
end
