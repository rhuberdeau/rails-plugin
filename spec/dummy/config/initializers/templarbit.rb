Rails.configuration.templarbit = {
  :api_key => ENV['TB_API_KEY'],
  :property_id => ENV['TB_PROPERTY_ID']
}

Templarbit.api_key = Rails.configuration.templarbit[:api_key]
Templarbit.property_id = Rails.configuration.templarbit[:property_id]

