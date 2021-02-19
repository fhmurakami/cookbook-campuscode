require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  it { expect(user).to validate_presence_of(:email) }
  it { expect(user).to validate_uniqueness_of(:email).case_insensitive }
  it { expect(user).to allow_value('teste@email.com').for(:email) }
  it { expect(user).to validate_presence_of(:name) }
  it { expect(user).to validate_presence_of(:city) }
  it { expect(user).to respond_to(:photo) }
  it { expect(user).to be_valid }
  it { is_expected.to validate_uniqueness_of(:auth_token) }

  describe '#info' do
    it 'returns email, created_at and Token' do
      user.save!
      allow(Devise).to receive(:friendly_token).and_return('TabcO123KxyzE456N')

      expect(user.info).to eq("#{user.email} - #{user.created_at}"\
        " - Token: #{Devise.friendly_token}")
    end
  end

  describe '#generate_authentication_token!' do
    it 'generates a unique auth token' do
      allow(Devise).to receive(:friendly_token).and_return('TabcO123KxyzE456N')
      user.generate_authentication_token!

      expect(user.auth_token).to eq('TabcO123KxyzE456N')
    end

    it 'generates another auth token when the current auth token already'\
      ' has been taken' do
      allow(Devise).to receive(:friendly_token)
        .and_return('abc123xyzTOKEN', 'abc123xyzTOKEN', 'TabcO123KxyzE456N')
      old_user = create(:user)
      user.generate_authentication_token!

      expect(user.auth_token).to_not eq(old_user.auth_token)
    end
  end
end
