describe TimesInputProcessor do

  it 'should tell data should not be stored' do
    TimesInputProcessor.store?.should == false
  end

  it 'should tell its description' do
    TimesInputProcessor.description.should == 'x Input'
  end

  it 'should multiply the value with the value of the given input' do
    Input.create!(:name => 'water', :last_value => 100)
    processor = TimesInputProcessor.new(12.25, Input.first.id)
    processor.perform.should == 1225
  end
end
