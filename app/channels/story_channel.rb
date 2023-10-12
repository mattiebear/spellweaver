# frozen_string_literal: true

class StoryChannel < ApplicationCable::Channel
  after_subscribe :send_story_state

  # TODO: Notate event data structure in some way
  # TODO: Create store for send and received events
  CURRENT_STATE = 'current-story-state'
  SELECT_MAP = 'select-map'
  ADD_TOKEN = 'add-token'

  def subscribed
    stream_from story_key
    stream_from user_key
  end

  def receive(data)
    # TODO: Move actions to isolated class
    message = Story::Message.from(data)

    case message.event
    when SELECT_MAP
      save_selected_map(message)
    when ADD_TOKEN
      add_token(message)
    end
  end

  private

  def book
    @book ||= Story::Book.new(story_id).load!
  end

  def send_story_state
    message = Story::Message.new(CURRENT_STATE, book)

    ActionCable.server.broadcast(user_key, message.to_h)
  end

  def save_selected_map(message)
    book.select_map(message.get(:map_id))
    book.save!
  end

  def add_token(message)
    book.add_token(message.get(:id), message.data)
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
