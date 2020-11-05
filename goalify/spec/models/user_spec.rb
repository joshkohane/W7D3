# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:good_user) { User.new( username: "goalie", password: "password123" ) }

  describe "User validations" do
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username) }
    it { should validate_presence_of(:session_token) }
    it { should validate_uniqueness_of(:session_token) }
  end

  # test associations
  # test class methods

  describe "user#self.find_by_credentials" do
    before { good_user.save! }
  
    it "Finds user with valid credentials" do
      expect(User.find_by_credentials("goalie", "password123")).to eq(good_user)
    end

    it "Does not find user if credentials do not exist" do
      expect(User.find_by_credentials("timothy", "password123")).to be(nil)
    end

    # it "Raises error for invalid credentials" do
    #   expect(bad_user.errors[:password]).to include('invalid credentials')
    # end
  end

  describe 'password encryption' do
    it 'does not save passwords to the database' do
      FactoryBot.create(:coolest_user)
      user = User.find_by(username: 'coolest_user')
      expect(user.password).not_to eq('password123')
    end

    it 'encrypts password using bcrypt' do
      expect(BCrypt::Password).to receive(:create).with('asdlfkju')
      FactoryBot.build(:coolest_user, password: "asdlfkju")
    end
  end
end
