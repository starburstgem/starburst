FactoryGirl.define do 
        factory :user do
                first_name { Faker::Name.first_name }
                last_name { Faker::Name.last_name }
                email { Faker::Internet.email }
                password "changeme"
                trait :paid do
                        subscription "monthly"
                end
                trait :free do
                        subscription ""
                end
        end
end