window.EmonGauges = class EmonGauges

  constructor: () ->
    @actualElectra = new JustGage
      id: 'actual_electra'
      value: 0
      min: 0
      max: 2000
      title: 'Elektra'
      label: 'Watt'  

    @gasUsage = new JustGage
      id: 'gas_usage'
      value: 0
      min: 0
      max: 1000
      title: 'Gas'
      label: 'liter'

  autoUpdate: (actual_electra) ->
    self = @
    setInterval (-> self.getvalues()), 5000

  getvalues: () ->
    self = @
    $.ajax
      url: '/feeds/'
      dataType: 'json'
      success: (data) ->
        self.gasUsage.refresh Math.round(data['gas_usage'] * 1000)
        self.actualElectra.refresh Math.round(data['actual_electra'] * 1000) / 1000
