class PagesController < ApplicationController
  ##
  # POST /calculate
  ##
  def calculate
    results = InvestmentAllocator.allocate(calculation_params)
    # byebug
    respond_to do |format|
      format.json { render json: results, status: :ok }
    end
  end

  def calculation_params
    params.permit(
      :allocation_amount,
      investor_amounts: [:id, :name, :averageAmount, :requestedAmount]
    )
  end
end
