ImpressionistController::InstanceMethods.send(:define_method, :direct_create_statement) do |query_params={}|
	# creates a statment hash that contains default values for creating an impression.
	# if :impressionable_id is a valid ObjectId then convert it into one
	query_params.reverse_merge!(
		:impressionable_type => controller_name.singularize.camelize,
		:impressionable_id=> !Moped::BSON::ObjectId.legal?(params[:id]) ? params[:id] : Moped::BSON::ObjectId.from_string(params[:id])
	)
	associative_create_statement(query_params)
end