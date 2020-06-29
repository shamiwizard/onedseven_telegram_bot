FactoryBot.define do
  factory :poll do
    association :organizer
    started_at { Time.current }
    ended_at { nil }
    status { 'started' }
  end

  factory :poll_closed, class: Poll do
    association :organizer
    started_at { Time.current }
    ended_at { Time.current + 2.days }
    status { 'ended' }
  end
end
