module Api::V1::InputsHelper

  def name_of_processor(processor)
    if data_store?(processor[0])
      'Feed'
    else
      (processor[0].to_s+ '_processor').camelcase.constantize.description
    end
  end

  def argument_of_processor(processor)
    if data_store?(processor[0]) 
      begin Feed.find(processor[1]).name rescue ActiveRecord::RecordNotFound end
    else
      processor[1]
    end
  end

  private

  def data_store?(processor_type)
    Processor.data_stores.include?(processor_type)
  end
end
