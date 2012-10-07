describe 'Processor' do

  it 'should return an array of all processors from with the result needs to be stored' do
    Processor.data_stores.should == [:difference, :gas_storage, :log_to_feed, :power_to_kwh, :power_to_kwh_per_day]
  end

  it 'should return an array of all descriptions' do
    Processor.descriptions.should == ['Deprecated', 'Log to Feed', 'Offset', 'Only store the value is different than last one',
                                      'Power to kWh', 'Power to kWh/d', 'Scale', 'x Input']
  end

  it 'should return an selection_options' do
    Processor.selection_options.should == [['Deprecated', 'gas_storage'],
                                           ['Log to Feed', 'log_to_feed'],
                                           ['Offset','offset'],
                                           ['Only store the value is different than last one', 'difference'],
                                           ['Power to kWh', 'power_to_kwh'],
                                           ['Power to kWh/d','power_to_kwh_per_day'],
                                           ['Scale', 'scale'],
                                           ['x Input', 'times_input']
                                          ]
  end

end