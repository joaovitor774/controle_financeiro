class EntriesController < ApplicationController
  before_action :set_entry, only: %i[ show edit update destroy ]
  before_action :load_dependencies, only: %i[ new create edit update ]

  # GET /entries or /entries.json
  def index
    @entries = current_user.entries
                           .includes(:account, :category, :entry_type, :entry_status)
                           .order(occurred_on: :desc, created_at: :desc)
  end

  # GET /entries/1 or /entries/1.json
  def show
  end

  # GET /entries/new
  def new
    @entry = current_user.entries.new
  end

  # GET /entries/1/edit
  def edit
  end

  # POST /entries or /entries.json
  def create
    @entry = current_user.entries.new(entry_params)

    respond_to do |format|
      if @entry.save
        format.html { redirect_to dashboard_path, notice: "Transação criada com sucesso." }
        format.json { render :show, status: :created, location: @entry }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /entries/1 or /entries/1.json
  def update
    respond_to do |format|
      if @entry.update(entry_params)
        format.html { redirect_to reports_path, notice: "Transação atualizada com sucesso.", status: :see_other }
        format.json { render :show, status: :ok, location: @entry }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entries/1 or /entries/1.json
  def destroy
    @entry.destroy!

    respond_to do |format|
      format.html { redirect_to reports_path, notice: "Transação removida com sucesso.", status: :see_other }
      format.json { head :no_content }
    end
  end

  def update_status
    @entry = current_user.entries.find(params[:id])
    new_status = EntryStatus.find_by(name: params[:status])

    if new_status.present? && @entry.update(entry_status: new_status)
      redirect_back fallback_location: reports_path, notice: "Status atualizado com sucesso."
    else
      redirect_back fallback_location: reports_path, alert: "Não foi possível atualizar o status."
    end
  end

  private

  def set_entry
    @entry = current_user.entries.find(params[:id])
  end

  def load_dependencies
    @accounts = current_user.accounts
    @categories = current_user.categories.includes(:category_kind)

    @income_categories = @categories.select { |c| c.category_kind&.name == "income" }
    @expense_categories = @categories.select { |c| c.category_kind&.name == "expense" }

    @entry_type_options = EntryType.all.map do |entry_type|
      label =
        case entry_type.name
        when "income" then "Entrada"
        when "expense" then "Saída"
        else entry_type.name
        end

      [label, entry_type.id]
    end

    @entry_status_options = EntryStatus.all.map do |entry_status|
      label =
        case entry_status.name
        when "paid" then "Pago"
        when "pending" then "Pendente"
        when "canceled" then "Cancelado"
        else entry_status.name
        end

      [label, entry_status.id]
    end

    @paid_status_id = EntryStatus.find_by(name: "paid")&.id
  end

  def entry_params
    params.expect(entry: [
      :description,
      :amount,
      :occurred_on,
      :account_id,
      :category_id,
      :entry_type_id,
      :entry_status_id,
      :notes
    ])
  end
end