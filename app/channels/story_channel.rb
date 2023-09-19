# frozen_string_literal: true

class StoryChannel < ApplicationCable::Channel
  def subscribed
    stream_from "story:#{params[:story]}"
  end
end
