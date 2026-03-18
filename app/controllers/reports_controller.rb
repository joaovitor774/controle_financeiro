class ReportsController < ApplicationController
  def index
    @start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.current.beginning_of_month
    @end_date = params[:end_date].present? ? Date.parse(params[:end_date]) : Date.current.end_of_month

    @entries = current_user.entries
                           .includes(:account, :category, :entry_type, :entry_status)
                           .where(occurred_on: @start_date..@end_date)
                           .order(occurred_on: :desc, created_at: :desc)

    @income_total = @entries.joins(:entry_type)
                            .where(entry_types: { name: "income" })
                            .sum(:amount)

    @expense_total = @entries.joins(:entry_type)
                             .where(entry_types: { name: "expense" })
                             .sum(:amount)

    @balance = @income_total - @expense_total
  rescue Date::Error
    redirect_to reports_path, alert: "Período inválido."
  end
  def pdf
  start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.current.beginning_of_month
  end_date = params[:end_date].present? ? Date.parse(params[:end_date]) : Date.current.end_of_month

  entries = current_user.entries
                        .includes(:account, :category, :entry_type, :entry_status)
                        .where(occurred_on: start_date..end_date)
                        .order(occurred_on: :desc, created_at: :desc)

  income_total = entries.joins(:entry_type)
                        .where(entry_types: { name: "income" })
                        .sum(:amount)

  expense_total = entries.joins(:entry_type)
                         .where(entry_types: { name: "expense" })
                         .sum(:amount)

  balance = income_total - expense_total

  pdf = Prawn::Document.new(page_size: "A4", margin: 40)

  # 🔷 HEADER
  pdf.fill_color "0F172A"
  pdf.text "Controle Financeiro", size: 22, style: :bold
  pdf.move_down 4

  pdf.fill_color "475569"
  pdf.text "Relatório financeiro", size: 11
  pdf.move_down 12

  # 🔷 INFORMAÇÕES (LIMPO)
  pdf.fill_color "0F172A"
  pdf.text "Usuário: #{current_user.name}", size: 10, style: :bold
  pdf.move_down 3

  pdf.fill_color "475569"
  pdf.text "Período: #{start_date.strftime('%d/%m/%Y')} até #{end_date.strftime('%d/%m/%Y')}", size: 10

  pdf.move_down 10

  pdf.stroke_color "E2E8F0"
  pdf.stroke_horizontal_rule
  pdf.move_down 15

  # 🔷 RESUMO
  summary_data = [
    [
      "Entradas\nR$ #{format('%.2f', income_total).tr('.', ',')}",
      "Saídas\nR$ #{format('%.2f', expense_total).tr('.', ',')}",
      "Saldo\nR$ #{format('%.2f', balance).tr('.', ',')}"
    ]
  ]

  pdf.table(summary_data,
            width: pdf.bounds.width,
            cell_style: {
              padding: [12, 10, 12, 10],
              align: :center,
              valign: :center,
              size: 12,
              font_style: :bold,
              borders: [],
              background_color: "F8FAFC"
            }) do
    cells.border_width = 1
    cells.border_color = "E2E8F0"
    columns(0).text_color = "16A34A"
    columns(1).text_color = "DC2626"
    columns(2).text_color = balance >= 0 ? "16A34A" : "DC2626"
  end

  pdf.move_down 25

  # 🔷 TÍTULO
  pdf.fill_color "0F172A"
  pdf.text "Transações do período", size: 13, style: :bold
  pdf.move_down 10

  table_data = [["Data", "Descrição", "Categoria", "Conta", "Tipo", "Status", "Valor"]]

  entries.each do |entry|
    tipo = entry.entry_type&.name == "income" ? "Entrada" : "Saída"

    status = case entry.entry_status&.name
             when "paid" then "Pago"
             when "pending" then "Pendente"
             when "canceled" then "Cancelado"
             else "-"
    end

    table_data << [
      entry.occurred_on.strftime("%d/%m/%Y"),
      entry.description.to_s,
      entry.category&.name.to_s,
      entry.account&.name.to_s,
      tipo,
      status,
      "R$ #{format('%.2f', entry.amount).tr('.', ',')}"
    ]
  end

  pdf.table(table_data,
            header: true,
            width: pdf.bounds.width,
            row_colors: ["FFFFFF", "F8FAFC"],
            cell_style: {
              size: 9,
              padding: 6,
              border_color: "E2E8F0"
            }) do
    row(0).background_color = "1D4ED8"
    row(0).text_color = "FFFFFF"
    row(0).font_style = :bold

    columns(6).align = :right
    columns(4).align = :center
    columns(5).align = :center
  end

  pdf.move_down 20

  # 🔷 RODAPÉ
  pdf.stroke_color "CBD5E1"
  pdf.stroke_horizontal_rule
  pdf.move_down 8

  pdf.fill_color "64748B"
  pdf.text "Gerado em #{Time.current.strftime('%d/%m/%Y às %H:%M')}", size: 8, align: :right

  send_data pdf.render,
            filename: "relatorio_#{start_date}_#{end_date}.pdf",
            type: "application/pdf",
            disposition: "inline"

  rescue Date::Error
  redirect_to reports_path, alert: "Período inválido."
  end
end