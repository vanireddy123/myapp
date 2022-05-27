class UsersController < ApplicationController
	before_action :load_file
	before_action :set_list, only: %i[ show edit update ]
	PATH = "#{Rails.root}/tmp/sonder1.yml"
	def index
		if params["search"].present?
			users = User.file_search(@file,params["search"])
			@users = users.paginate(page: params[:page], per_page: 2)
		else
			sorted_users = @read_file.sort_by { |h| h.first }
			@users = sorted_users.paginate(page: params[:page], per_page: 5)
		end
	end

	def new
		@user = User.new
	end

	def create
		array_of_hashes = [
	 	{params["user"]["building_number"]=>{"name" => params["user"]["name"], "city" => params["user"]["city"], "date" => params["user"]["date"]	}}
	 ]
	 user = @read_file.detect{|a| a.key?(params["user"]["building_number"])}
	 if user.present?
	 	redirect_to edit_user_path(params["user"]["building_number"]), notice: "List is already present please go for edit and update"
	 else
			converted_yml = @file.inject(array_of_hashes, :<<).to_yaml
			if File.exist?(PATH)
				File.open(PATH, 'w') {|f| f.write converted_yml} 
				respond_to do |format|
		      format.html { redirect_to users_url, notice: "List was successfully created." }
		    end
			end
		end
	end

	def show
	
	end

	def edit
		@user = User.map_and_edit(@read_file,params)
		
	end

	def update
		User.map_and_update(@file,params)

		if File.exist?(PATH)
			File.open(PATH, 'w') {|f| f.write @file.to_yaml } 
			respond_to do |format|
	      format.html { redirect_to users_url, notice: "List was updated successfully." }
	    end
		end
  end


	private	
  def load_file
  	@file = YAML.load_file("#{Rails.root}/tmp/sonder1.yml")
  	Rails.cache.write("new_file",@file)
  	@read_file = Rails.cache.read("new_file")
  end

  def set_list
	 @user = @read_file.detect{|a| a.key?(params["id"])}
  end



end