# frozen_string_literal: true

class StoryChannel < ApplicationCable::Channel
  after_subscribe :send_story_state

  def subscribed
    stream_from story_key
    stream_from user_key
  end

  def receive(data)
    result = message_from(data).bind do |message|
      init_action(message).bind(&:execute!)
    end

    return unless result.success?

    broadcast(result.value!)

    # TODO: Add failure handling
  end

  private

  def user
    current_user
  end

  def game_session_id
    params[:story]
  end

  def story_key
    "story:#{game_session_id}"
  end

  def user_key
    "#{story_key}:#{user.id}"
  end

  def send_story_state
    Game::Actions::StoryState.new(game_session_id:).execute!.bind do |result|
      broadcast(result)
    end
  end

  def broadcast(result)
    Game::Messaging::Broadcast.new(data: result.data,
                                   event: result.event,
                                   game_session_id:,
                                   user: current_user).send!
  end

  def message_from(data)
    Game::Messaging::MessageLoader.new(data).message
  end

  def init_action(message)
    Game::Actions::Director.new(game_session_id:, message:, user:).action
  end
end
