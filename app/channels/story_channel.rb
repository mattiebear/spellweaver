# frozen_string_literal: true

class StoryChannel < ApplicationCable::Channel
  after_subscribe :send_story_state

  CURRENT_STATE = 'current-story-state'
  SELECT_MAP = 'select-map'

  def subscribed
    stream_from story_key
    stream_from user_key
  end

  def receive(data)
    event = data['event']

    case event
    when SELECT_MAP
      save_selected_map(data['data']['id'])
    end
  end

  private

  def book
    @book ||= Story::Book.new(story_id).load!
  end

  def send_story_state
    ActionCable.server.broadcast(user_key, { event: CURRENT_STATE, data: book.to_h })
  end

  def save_selected_map(map_id)
    book.map = map_id
    book.save!
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
