# frozen_string_literal: true

# Base class for all application services. Private tasks are defined and run, either
# storing a final service result or raising a common service error that can be used
# to display standard messages throughout the application
class Service
  attr_reader :errors, :result

  def initialize(**_args)
    @errors = []
    @result = nil
  end

  def run
    begin
      tasks
    rescue ServiceError => e
      errors.push(e)
    end

    completed_successfully?
  end

  def run!
    tasks
    self
  end

  private

  attr_writer :errors, :result

  def tasks
    # Define tasks here
  end

  def completed_successfully?
    errors.empty?
  end
end
