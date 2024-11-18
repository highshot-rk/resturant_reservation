FactoryBot.define do
  factory :table do
    capacity { (2..8).to_a.sample }
    location { Table.location.values.sample }
  end
end
