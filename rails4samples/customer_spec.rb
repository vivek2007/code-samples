require 'rails_helper'


describe Customer  do
	# before do
	# 	@customer = FactoryGirl.build(:customer)
	# end
  let(:customer){FactoryGirl.build(:customer)}

  it "should have company name" do 
    expect(customer).to respond_to(:company_name)
  end

  it "should be valid" do 
    expect(customer).to be_valid
  end

  subject { customer }
  it { is_expected.to respond_to(:company_name) }
  it { is_expected.to respond_to(:street_address1)}
  it { is_expected.to respond_to(:street_address2)}
  it { is_expected.to respond_to(:city) }
  it { is_expected.to respond_to(:state) }
  it { is_expected.to respond_to(:email) }
  it { is_expected.to respond_to(:postal_code) }
  it { is_expected.to respond_to(:phone_number) }


  describe "validations" do
      context "when wrong email format" do  
      before do 
       customer.email = "testmail.com" 
      end
      it "should not be valid" do 
        expect(customer).to be_invalid
        expect(customer.errors.full_messages.first).to eql("Email is invalid")
      end
      end

      context "when no company name" do  
        before do 
         customer.email = "test@mail.com"
         customer.company_name = "" 
        end
        it "should not be valid" do 
          expect(customer).to be_invalid 
          expect(customer.errors.full_messages.first).to eql("Company name can't be blank")
        end
      end

      context "when no street_address name" do  
        before do 
         customer.email = "test@mail.com"
         customer.company_name = "Company name" 
         customer.street_address1 = "" 
        end

        it "should not be valid" do 
          expect(customer).to be_invalid
          expect(customer.errors.full_messages.first).to eql("Street address1 can't be blank")
        end
      end

      context "when no city name" do  
        before do 
         customer.email = "test@mail.com"
         customer.company_name = "Company name" 
         customer.street_address1 = "Street Adress" 
         customer.city = ''
        end

        it "should not be valid" do 
          expect(customer).to be_invalid
          expect(customer.errors.full_messages.first).to eql("City can't be blank")
        end
      end

      context "when no state name" do  
        before do 
         customer.email = "test@mail.com"
         customer.company_name = "Company name" 
         customer.street_address1 = "Street Adress" 
         customer.city = 'My City'
         customer.state = ''
        end

        it "should not be valid" do 
          expect(customer).to be_invalid
          expect(customer.errors.full_messages.first).to eql("State can't be blank")
        end
      end

      describe "postal code format" do 
        context 'when code is less than 5 charecters' do
          it "is expected to be invalid" do 
            customer.postal_code = '111'
            expect(customer).to be_invalid
          end

          it "is expected to return invalid error message" do 
            customer.postal_code = '111'
            customer.save
            expect(customer.errors.full_messages.first).to eql("Postal code should be 12345 or 12345-6789")
          end
        end

        context "when code is greater than 5 charecter" do
          it "is expected to be invalid" do 
            customer.postal_code = '111111'
            expect(customer).to be_invalid
          end
        end

        context "accepts area code" do
          it "is expected to be valid" do 
            customer.postal_code = '11111-1234'
            expect(customer).to be_valid
          end
        end


      end
    end


	describe "when versions", versioning:  true  do 

		before do
			customer.save
		end

  		it 'should be versioned'  do
    		expect(PaperTrail).to be_enabled
  		end

  		it 'returns version when create user'  do 
  			expect(customer.versions).to_not be_nil
  			expect(customer.versions.last.event).to eql("create")
  		end

  		it 'returns version when update user'  do 
  			customer.update_attributes!(:company_name => 'New Company Name')
  		    expect(customer.versions.last.event).to eql("update")
  		end

  		it 'returns version when deletes user'  do 
  			customer.destroy
  			expect(customer.versions).to_not be_nil
  			expect(customer.versions.last.event).to eql("destroy")
  		end

	end 

  describe 'relationships'  do
    it 'expected to relate with users' do
      expect(customer).to respond_to(:users)
    end
  end

end
