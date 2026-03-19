class DashboardController < ApplicationController
  def index
    @entries = current_user.entries
                           .includes(:category, :account, :entry_type, :entry_status)
                           .order(occurred_on: :desc, created_at: :desc)

    paid_entries = current_user.entries
                               .joins(:entry_status)
                               .where(entry_statuses: { name: "paid" })

    @income_total = paid_entries.joins(:entry_type)
                                .where(entry_types: { name: "income" })
                                .sum(:amount)

    @expense_total = paid_entries.joins(:entry_type)
                                 .where(entry_types: { name: "expense" })
                                 .sum(:amount)

    @balance = @income_total - @expense_total

    @recent_entries = @entries.limit(5)
  end
end