# frozen_string_literal: true
# rbs_inline: enabled

require_relative "harmonica/version"
require_relative "harmonica/spring"
require_relative "harmonica/point"
require_relative "harmonica/vector"
require_relative "harmonica/projectile"

module Harmonica
  # Calculate time delta for a given frames per second.
  # Use this when initializing Spring or Projectile.
  #
  # @example
  #   spring = Harmonica::Spring.new(delta_time: Harmonica.fps(60), ...)
  #
  # @rbs frames_per_second: Integer -- frames per second
  # @rbs return: Float
  def self.fps(frames_per_second)
    1.0 / frames_per_second
  end
end
