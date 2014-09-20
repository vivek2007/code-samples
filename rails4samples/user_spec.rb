require 'rails_helper'

describe User do

    let(:user){ FactoryGirl.build(:user) }

		subject { user }
		it { is_expected.to respond_to(:username) }
		it { is_expected.to respond_to(:last_name)}
		it { is_expected.to respond_to(:first_name)}
		it { is_expected.to respond_to(:email) }
		it { is_expected.to respond_to(:password) }
		it { is_expected.to respond_to(:password_confirmation) }
		it { is_expected.to respond_to(:is_admin) }
		it { is_expected.to respond_to(:customer_id)}
		it { is_expected.to be_valid }


		describe "validations" do
		  context "when wrong email format" do  
			before do 
			 user.email = "testmail.com" 
			end
			it "should not be valid" do 
			  expect(user).to be_invalid
			  expect(user.errors.full_messages.first).to eql("Email is invalid")
			end
		  end

		  context "when no first name" do  
			before do 
			 user.email = "test@mail.com"
			 user.first_name = "" 
			end
			it "should not be valid" do 
			  expect(user).to be_invalid 
			  expect(user.errors.full_messages.first).to eql("First name can't be blank")
			end
		  end

		  context "when no last name" do  
			before do 
			 user.email = "test@mail.com"
			 user.first_name = "first name" 
			 user.last_name = "" 
			end
			it "should not be valid" do 
			  expect(user).to be_invalid
			  expect(user.errors.full_messages.first).to eql("Last name can't be blank")
			end
		  end

		  context "when no user name" do  
			before do 
			 user.email = "test@mail.com"
			 user.first_name = "first name" 
			 user.last_name = "last name"
			 user.username = "" 
			end
			it "should not be valid" do 
			  expect(user).to be_invalid
			  expect(user.errors.full_messages.first).to eql("Username can't be blank")
			end
		  end

		  context "when password mismatch"  do  
			before do 
			 user.email = "test@mail.com"
			 user.first_name = "first name" 
			 user.last_name = "last name"
			 user.username = "username" 
			 user.password = "plese1234"
			 user.password_confirmation = "please2342"
			end
			it "should not be valid" do 
			  expect(user).to be_invalid
			  expect(user.errors.full_messages.first).to eql("Password confirmation doesn't match Password")
			end
		  end

		end


		describe "when email is not present" do
			before { user.email = " " }
			it { is_expected.to_not be_valid }
		end


		describe "when email address is already taken" do
			before do
				user_with_same_email = user.dup
				user_with_same_email.save
			end
			it { is_expected.to_not be_valid }
		end
		describe "when email address is already taken" do
			before do
				user_with_same_email = user.dup
				user_with_same_email.email = user.email.upcase
				user_with_same_email.save
			end
			it { is_expected.to_not be_valid }
		end
		describe "when password is not present" do
			before do
				user.password = ''
				user.password_confirmation = ''
			end
			it { is_expected.to_not be_valid }
		end
		describe "when password doesn't match confirmation" do
			before { user.password_confirmation = "mismatch" }
			it { is_expected.to_not be_valid }
		end





    describe "when versions", :versioning => true  do 

		before do
			user.save
		end

  		it 'should be versioned'  do
    		expect(PaperTrail).to be_enabled
  		end

  		it 'returns version when create user'  do 
  			expect(user.versions).to_not be_nil
  			expect(user.versions.last.event).to eql("create")
  		end

  		it 'returns version when update user'  do 
  			user.update_attributes!(:username => 'Version User')
  		    expect(user.versions.last.event).to eql("update")
  		end

  		it 'returns version when deletes user'  do 
  			user.destroy
  			expect(user.versions).to_not be_nil
  			expect(user.versions.last.event).to eql("destroy")
  		end

	end 

    describe 'relationships'  do
      it 'expected to relate with users' do
        expect(user).to respond_to(:customer)
      end
    end

end
