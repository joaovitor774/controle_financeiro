class DashboardController < ApplicationController
  def index
    @entries = current_user.entries
                           .includes(:category, :account, :entry_type, :entry_status)
                           .order(occurred_on: :desc, created_at: :desc)

    @income_total = @entries.joins(:entry_type)
                            .where(entry_types: { name: "income" })
                            .sum(:amount)

    @expense_total = @entries.joins(:entry_type)
                             .where(entry_types: { name: "expense" })
                             .sum(:amount)

    @balance = @income_total - @expense_total

    @recent_entries = @entries.limit(5)
  end
end