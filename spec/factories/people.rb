FactoryBot.define do
  factory :person do
    telegram_code { Faker::Number.number(digits: 10) }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    username { Faker::Internet.username  }
    language_code { 'en' }
  end

  factory :person_params, class: Person do
    id { Faker::Number.number(digits: 10) }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    username { Faker::Internet.username  }
    language_code { 'en' }
  end
end
