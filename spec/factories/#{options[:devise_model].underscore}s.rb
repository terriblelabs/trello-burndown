FactoryGirl.define do
  factory :user do
    email      { Faker::Internet.disposable_email }
    password   'password'
  end
end
