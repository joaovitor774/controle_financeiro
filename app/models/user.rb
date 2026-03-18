class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :accounts, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :entries, dependent: :destroy

  after_create :setup_default_financial_data

  private

  def setup_default_financial_data
    cash_type = AccountType.find_by(name: "cash")
    income_kind = CategoryKind.find_by(name: "income")
    expense_kind = CategoryKind.find_by(name: "expense")

    accounts.create!(
      name: "Carteira",
      account_type: cash_type,
      initial_balance: 0,
      active: true
    )

    ["Salário", "Freelance", "Vendas", "Investimentos", "Outras receitas"].each do |name|
      categories.create!(name: name, category_kind: income_kind)
    end

    ["Alimentação", "Transporte", "Moradia", "Saúde", "Educação", "Lazer", "Compras", "Contas", "Outras despesas"].each do |name|
      categories.create!(name: name, category_kind: expense_kind)
    end
  end
end