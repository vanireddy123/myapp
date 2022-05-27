class User 
	include ActiveModel::Model
	attr_accessor :name, :city, :building_number, :date
		PATH = "#{Rails.root}/tmp/sonder1.yml"


	def initialize
		@name = name
		@city = city
		@building_number = building_number
		@date = date
	end

	def self.file_search(file,search_key)
		data = []
			file.each do |user|
			data << user.select{|key,values| values["name"] == search_key}
			end
			users = data.reject! { |h| h.empty? }
			users
	end

	# def self.find_and_map_the_user(params,read_file)
	# 	@read_file	= read_file	
	# 	array_of_hashes = [
	#  	{params["user"]["building_number"]=>{"name" => params["user"]["name"], "city" => params["user"]["city"], "date" => params["user"]["date"]	}}
	#  ]
	#  user = @read_file.detect{|a| a.key?(params["user"]["building_number"])}
	#  user
	# end

	def self.map_and_edit(read_file,params)
		@read_file	= read_file	
		user = @read_file.detect { |a| a.key?(params["id"]) }.dig(params["id"])
		@user = User.new
		@user.name = user["name"]
		@user.city = user["city"]
		@user.date = user["date"].to_date
		@user.building_number = params["id"]
		@user
	end

	def self.map_and_update(file,params)
		user = []
		file.each do |user|
			if user.include? params["id"]
				user[params["id"]]["name"] = params["user"]["name"] 
				user[params["id"]]["city"] = params["user"]["city"]
				user[params["id"]]["date"] = params["user"]["date"]
			end
			user = user
		end
		user
	end



end