# frozen_string_literal: true

class StoryChannel < ApplicationCable::Channel
  after_subscribe :send_story_state

  def subscribed
    stream_from story_key
    stream_from user_key
  end

  private

  def send_story_state
    book = Story::Book.new(story_id)

    ActionCable.server.broadcast(user_key, { event: 'current-story-state', data: book.to_h })
  end

  def story_id
    params[:story]
  end

  def story_key
    "story:#{story_id}"
  end

  def user_id
    current_user.id
  end

  def user_key
    "#{story_key}:#{user_id}"
  end
end
