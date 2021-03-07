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

    many_investors = {
      "allocation_amount": 1000,
      "investor_amounts": [
        {"id": 1, "name": "A", "averageAmount": 100, "requestedAmount": 200},
        {"id": 2, "name": "B", "averageAmount": 100, "requestedAmount": 25},
        {"id": 3, "name": "C", "averageAmount": 500, "requestedAmount": 10},
        {"id": 4, "name": "D", "averageAmount": 1000, "requestedAmount": 500},
        {"id": 5, "name": "E", "averageAmount": 10, "requestedAmount": 100},
        {"id": 6, "name": "F", "averageAmount": 25, "requestedAmount": 100},
        {"id": 7, "name": "G", "averageAmount": 50, "requestedAmount": 100},
        {"id": 8, "name": "H", "averageAmount": 100, "requestedAmount": 500}
      ]
     }

    puts "Complex 1: #{InvestmentAllocator.allocate(complex_1)}"
    puts "Complex 2: #{InvestmentAllocator.allocate(complex_2)}"
    puts "Simple 1: #{InvestmentAllocator.allocate(simple_1)}"
    puts "Simple 2: #{InvestmentAllocator.allocate(simple_2)}"
    puts "Many Investors: #{InvestmentAllocator.allocate(many_investors)}"
  
  end
end
