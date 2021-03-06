namespace :investment_allocator do
  desc 'Runs all of the example calculations'
  task examples: :environment do
    complex_1 = {
      "allocation_amount": 100,
      "investor_amounts": [{
              "id": "Investor A",
              "requestedAmount": 100,
              "averageAmount": 95
          },
          {
              "id": "Investor B",
              "requestedAmount": 2,
              "averageAmount": 1
          },
          {
              "id": "Investor C",
              "requestedAmount": 1,
              "averageAmount": 4
          }
      ]
  }

    complex_2 = {
      "allocation_amount": 100,
      "investor_amounts": [
        {
          "id": "Investor A",
          "requestedAmount": 100,
          "averageAmount": 95
        },
        {
          "id": "Investor B",
          "requestedAmount": 1,
          "averageAmount": 1
        },
        {
          "id": "Investor C",
          "requestedAmount": 1,
          "averageAmount": 4
        }
      ]
    }

    simple_1 = {
      "allocation_amount": 100,
      "investor_amounts": [
        {
          "id": "Investor A",
          "requestedAmount": 100,
          "averageAmount": 100
        },
        {
          "id": "Investor B",
          "requestedAmount": 25,
          "averageAmount": 25
        }
      ]
    }

    simple_2 = {
      "allocation_amount": 200,
      "investor_amounts": [
        {
          "id": "Investor A",
          "requestedAmount": 100,
          "averageAmount": 100
        },
        {
          "id": "Investor B",
          "requestedAmount": 25,
          "averageAmount": 25
        }
      ]
    }

    puts "Complex 1: #{InvestmentAllocator.allocate(complex_1)}"
    puts "Complex 2: #{InvestmentAllocator.allocate(complex_2)}"
    puts "Simple 1: #{InvestmentAllocator.allocate(simple_1)}"
    puts "Simple 2: #{InvestmentAllocator.allocate(simple_2)}"
  
  end
end
