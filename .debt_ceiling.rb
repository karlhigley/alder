DebtCeiling.configure do |c|
  c.whitelist = %w(lib)
  c.max_debt_per_module = 50
  c.debt_ceiling = 100
end
