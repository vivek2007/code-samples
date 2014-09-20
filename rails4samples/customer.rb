class Customer < ActiveRecord::Base
	validates_presence_of :company_name, :street_address1, :city,:state ,:email ,:phone_number,:postal_code
	validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i}
  validates_format_of :postal_code,
                    with: /\A\d{5}(-\d{4})?\Z/, 
                    message: "should be 12345 or 12345-6789"
	has_many :users, :dependent => :destroy  
	has_paper_trail
	#before_save :update_auto_pay_and_paper_invoices


	def auto_pay=(value)
		#binding.pry
	  value = value.eql?("on") ? true : false
	  @auto_pay = value
	  super
	end

    def paper_invoices=(value)

      value = value.eql?("on") ? true : false
      @paper_invoices =value
      super
    end

    def update_auto_pay_and_paper_invoices
    	binding.pry
    	self.paper_invoices = "off" if paper_invoices.blank?
    	self.auto_pay = "off" if auto_pay.blank?
    end
end
