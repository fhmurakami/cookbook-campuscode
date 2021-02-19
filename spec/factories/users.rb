FactoryBot.define do
  factory :user do
    name { FFaker::NameBR.name }
    city { FFaker::AddressBR.city }
    email { FFaker::Internet.email }
    password { '123456' }
    password_confirmation { '123456' }
  end
end
