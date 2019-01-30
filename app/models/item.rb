class Item < ApplicationRecord
	searchkick text_middle: [:name]
	Item.reindex
	belongs_to :user
	has_many :wish_lists, dependent: :destroy
	has_many :borrowed_items, dependent: :destroy
	has_many :on_hold_items, dependent: :destroy
	has_many_attached :images, dependent: :destory
	validates :name, presence: {message: "Please provide name for your item"}
	validates :descr, presence: {message: "Please describe your item"}
	#validates :street, presence: {message: "Please provide a street"}
	#validates :city, presence: {message: "Please provide a city"}
	#validates :address, presence: {message: "Please provide a country"}
	geocoded_by :address1
	after_validation :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }

	def address1
	[ city, address].compact.join(', ')
	end

	self.per_page = 10
	scope :with_category, -> (category) { where('category = ?', category)}
	scope :with_status, -> (status) {where('status = ?', status)}
	scope :with_city, -> (city) {where('city = ?', city)}
	scope :sorted_by, lambda { |sort_option|
	  # extract the sort direction from the param value.
	  direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
	  case sort_option.to_s
	  when /^created_at_/
	    # Simple sort on the created_at column.
	    # Make sure to include the table name to avoid ambiguous column names.
	    # Joining on other tables is quite common in Filterrific, and almost
	    # every ActiveRecord table has a 'created_at' column.
	    order("items.created_at #{ direction }")
	  when /^name_/
	    # Simple sort on the name colums
	    order("items.name #{ direction }")

	  else
	    raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
	  end
	}

	scope :search_query, lambda { |query|
	  where("name LIKE ? ", "%#{query}%")
	}

	filterrific(
	   default_filter_params: { sorted_by: 'created_at_desc'},
	   available_filters: [
	     :sorted_by,
	     :search_query,
	     :with_category,
	     :with_status,
			 :with_city,
			 :with_created_at_gte,

	   ]
	 )


	 def self.options_for_sorted_by
  [

    ['Name (a-z)', 'name_asc'],
    ['Created at (newer first)', 'created_at_desc'],
    ['Created at (older first)', 'created_at_asc'],
  ]
end


def self.options_for_category
	[
		['Accesories'],
		['Art'], ['Bath'],['Beauty'],['Books'], ['Clothing'], ['Craft Supplies'],
		['Electronics'], ['Films'], ['Games'],['Home'],['Living'], ['Music'], ['Office Tools'], ['Pet Supplies'], ['Tools'], ['Toys']
	]
end

def self.options_for_city
	[
		['Brampton'],['Hamilton'],['Kitchener'],['London'], ['Markham'],
	['Mississauga'], ['Ottawa'], ['Toronto'], ['Vaughan'],
	['Windsor']
	]
end
	def self.item_search(params)
    query = params.slice(:page, :name, :status, :category)
		puts query[:name]

		results = self.agg_search(query)

		puts "self item serach"


      return results.page(query[:page]) if query[:name].blank?
			puts query[:name]


			results_id = results.pluck(:id)
puts results_id
			self.elastic_search(query, results_id)



end


def self.agg_search(params)
	puts "simple search"
	puts params

	results = self.order('created_at DESC')
	results = results.by_category(params[:category]) if params[:category].present?
	results = results.by_status(params[:status]) if params[:status].present?
	results

end

def self.elastic_search(params, results_id)
	puts "elastic_search"
puts params
	if :name.present?

puts "name is present "
        @items = Item.search params[:name], operator: "or", fields: [:name], where: { id: results_id },match: :text_middle, misspellings: {below: 1}, per_page: 3
		else
      @items = Item.all

    end

end

def self.status_filter(status)
	if status.present?


			@status_filter = Item.search status, operator: "or", fields: [:status], misspellings: {edit_distance: 3}
	else
		@status_filter = Item.all

	end

end


def self.category_filter(category)
	if category.present?


			@category_filter = Item.search category, operator: "or", fields: [:category], misspellings: {edit_distance: 3}
	else
		@category_filter = Item.all

	end

end


#change status when item is lent out
def lent_out
	update_attributes(status: 'Lent Out')
end

#when returned
def returned
	update_attributes(status: 'Returned')
end

#after return confirmed
def available
	update_attributes(status: 'available')
end

end
