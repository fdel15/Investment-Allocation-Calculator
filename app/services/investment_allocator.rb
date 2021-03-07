class InvestmentAllocator
  def self.allocate(input)
    new(
      allocation_amount: input[:allocation_amount],
      investor_amounts: input[:investor_amounts]
    ).allocate
  end
  
  attr_reader :allocation_amount, :requested_amount_sum, :investor_average_sum
  attr_accessor :investor_amounts
  MARGIN_OF_ERROR = 0.01

  def initialize(allocation_amount:, investor_amounts:)
    @allocation_amount = allocation_amount
    @investor_amounts = investor_amounts
    @requested_amount_sum = investor_amounts.sum { |investor| investor[:requestedAmount].to_f }
    @investor_average_sum = investor_amounts.sum { |investor| investor[:averageAmount].to_f }
  end

  def allocate
    if requested_amount_sum < allocation_amount
      allocate_requested_amounts
    else
      allocate_pro_rated_amounts
    end
  end

  def allocate_requested_amounts
    results(:requestedAmount)
  end

  def results(allocation_key)
    investor_amounts.map do |investor|
      {id: investor[:id], allocatedAmount: investor[allocation_key] }
    end
  end

  def allocate_pro_rated_amounts
    while allocation_amount > MARGIN_OF_ERROR
      round_investment_amount = 0
      investor_amounts.each do |investor|
        requested_amount = investor[:requestedAmount]
        average_amount = investor[:averageAmount]
        current_investment_amount = investor[:pro_rated_investment].to_f

        next if current_investment_amount == requested_amount

        pro_rate_amount = pro_rate(average_amount)
        total_invested = [current_investment_amount + pro_rate_amount, requested_amount].min

        investor[:pro_rated_investment] = total_invested
        round_investment_amount += total_invested - current_investment_amount
      end
      @allocation_amount -= round_investment_amount
    end

    results(:pro_rated_investment)
  end

  def pro_rate(average_amount)
    allocation_amount * (average_amount.to_f / investor_average_sum)
  end
end