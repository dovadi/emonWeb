describe 'Processor' do

  it 'should return an array of all processors from with the result needs to be stored' do
    Processor.data_stores.should == [:gas_storage, :log_to_feed, :power_to_kwh, :power_to_kwh_per_day]
  end

  it 'should return an array of all descriptions' do
    Processor.descriptions.should == ['Log to Feed', 'Offset', 'Power to kWh', 'Power to kWh/d', 'Scale',
                                      'Store gas usage once an hour', 'x Input']
  end

end