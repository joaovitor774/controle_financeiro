class AccountsController < ApplicationController
  before_action :set_account, only: %i[ show edit update destroy ]

  def index
    @accounts = current_user.accounts.includes(:account_type)
    @total_balance = @accounts.sum(:initial_balance)
    @active_accounts_count = @accounts.where(active: true).count
    @accounts_count = @accounts.count
  end

  def show
  end

  def new
    @account = current_user.accounts.new
  end

  def edit
  end

  def create
    @account = current_user.accounts.new(account_params)

    respond_to do |format|
      if @account.save
        format.html { redirect_to @account, notice: "Conta criada com sucesso." }
        format.json { render :show, status: :created, location: @account }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to @account, notice: "Conta atualizada com sucesso.", status: :see_other }
        format.json { render :show, status: :ok, location: @account }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @account.destroy!

    respond_to do |format|
      format.html { redirect_to accounts_path, notice: "Conta removida.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  def set_account
    @account = current_user.accounts.find(params[:id])
  end

  def account_params
    params.expect(account: [:name, :initial_balance, :active, :account_type_id])
  end
end
