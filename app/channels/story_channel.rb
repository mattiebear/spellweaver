# frozen_string_literal: true

class StoryChannel < ApplicationCable::Channel
  after_subscribe :send_story_state

  # TODO: Notate event data structure in some way
  # TODO: Create store for send and received events
  CURRENT_STATE = 'current-story-state'
  SELECT_MAP = 'select-map'
  REQUEST_ADD_TOKEN = 'request-add-token'
  ADD_TOKEN = 'add-token'
  REQUEST_REMOVE_TOKEN = 'request-remove-token'
  REMOVE_TOKEN = 'remove-token'
  REQUEST_MOVE_TOKEN = 'request-move-token'
  MOVE_TOKEN = 'move-token'

  def subscribed
    stream_from story_key
    stream_from user_key
  end

  # FIXME: This is a mess
  def receive(data)
    # TODO: Move actions to isolated class
    message = Story::Message.from(data)

    case message.event
    when SELECT_MAP
      save_selected_map(message)
    when REQUEST_ADD_TOKEN
      request_add_token(message)
    when REQUEST_REMOVE_TOKEN
      request_remove_token(message)
    when REQUEST_MOVE_TOKEN
      request_move_token(message)
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

  def request_add_token(message)
    token = book.add_token(message.data, current_user)

    return unless token

    book.save!

    message = Story::Message.new(ADD_TOKEN, token)

    ActionCable.server.broadcast(story_key, message.to_h)
  end

  def request_remove_token(message)
    book.remove_token(message.data[:token_id])

    reply = Story::Message.new(REMOVE_TOKEN, message.data)

    ActionCable.server.broadcast(story_key, reply.to_h)
  end

  def request_move_token(message)
    book.move_token(message.data)

    reply = Story::Message.new(MOVE_TOKEN, message.data)

    ActionCable.server.broadcast(story_key, reply.to_h)
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
