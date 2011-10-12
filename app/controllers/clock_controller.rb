class ClockController < ApplicationController
  def now
    @time = Time.current
  end

end
