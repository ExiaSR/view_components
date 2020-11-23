# frozen_string_literal: true

module Primer
  # Avatars are images used to represent users and organizations on GitHub.
  # Use the default round avatar for users, and the `square` argument
  # for organizations or any other non-human avatars.
  class AvatarComponent < Primer::Component
    SMALL_THRESHOLD = 24

    #
    # @example 34|Default
    #   <%= render(Primer::AvatarComponent.new(src: "http://placekitten.com/200/200", alt: "@kittenuser")) %>
    #
    # @param src [String] The source url of the avatar image
    # @param alt [String] Passed through to alt on img tag
    # @param size [Integer] Adds the avatar-small class if less than 24
    # @param square [Boolean] Used to create a square avatar.
    def initialize(src:, alt:, size: 20, square: false, **system_arguments)
      @system_arguments = system_arguments
      @system_arguments[:tag] = :img
      @system_arguments[:src] = src
      @system_arguments[:alt] = alt
      @system_arguments[:size] = size
      @system_arguments[:height] = size
      @system_arguments[:width] = size

      @system_arguments[:classes] = class_names(
        "avatar",
        system_arguments[:classes],
        "avatar--small" => size < SMALL_THRESHOLD,
        "CircleBadge" => !square
      )
    end

    def call
      render(Primer::BaseComponent.new(**@system_arguments)) { content }
    end
  end
end
