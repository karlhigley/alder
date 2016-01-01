$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'alder'
require 'debt_ceiling'
at_exit { DebtCeiling.audit unless ENV['GUARD'] }

