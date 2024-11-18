FactoryBot.define do
  factory :reservation do
    name { Faker::Name.name }
    reservation_time { Faker::Time.forward(days: 2, period: :evening) }
    reservation_capacity { rand(2..10) }
    status { :confirmed }
    duration { rand(1..4) }

    after(:build) do |reservation|
      reservation.tables = []
    end
  end
end
