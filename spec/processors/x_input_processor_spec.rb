describe XInputProcessor do

  it 'should tell data should not be stored' do
    XInputProcessor.store?.should == false
  end

  it 'should tell its description' do
    XInputProcessor.description.should == 'x Input'
  end

end
