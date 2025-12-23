# frozen_string_literal: true

require_relative "test_helper"

module Harmonica
  class SpringTest < Minitest::Spec
    it "initializes with delta_time, angular_frequency, and damping_ratio" do
      spring = Spring.new(
        delta_time: Harmonica.fps(60),
        angular_frequency: 6.0,
        damping_ratio: 0.5
      )

      refute_nil spring
    end

    it "handles zero frequency by maintaining position" do
      spring = Spring.new(
        delta_time: Harmonica.fps(60),
        angular_frequency: 0.0,
        damping_ratio: 0.5
      )

      position, velocity = spring.update(10.0, 0.0, 100.0)
      assert_in_delta 10.0, position, 0.0001
      assert_in_delta 0.0, velocity, 0.0001
    end

    it "computes critically damped motion" do
      spring = Spring.new(
        delta_time: Harmonica.fps(60),
        angular_frequency: 6.0,
        damping_ratio: 1.0
      )

      position = 0.0
      velocity = 0.0
      target = 100.0

      10.times do
        position, velocity = spring.update(position, velocity, target)
      end

      assert position > 0.0
      assert position < target
    end

    it "computes under-damped motion with oscillation" do
      spring = Spring.new(
        delta_time: Harmonica.fps(60),
        angular_frequency: 6.0,
        damping_ratio: 0.2
      )

      position = 0.0
      velocity = 0.0
      target = 100.0

      300.times do
        position, velocity = spring.update(position, velocity, target)
      end

      assert_in_delta target, position, 5.0
    end

    it "computes over-damped motion without oscillation" do
      spring = Spring.new(
        delta_time: Harmonica.fps(60),
        angular_frequency: 6.0,
        damping_ratio: 2.0
      )

      position = 0.0
      velocity = 0.0
      target = 100.0

      100.times do
        position, velocity = spring.update(position, velocity, target)
      end

      assert position > 0.0
      assert position < target
    end

    it "converges to target position" do
      spring = Spring.new(
        delta_time: Harmonica.fps(60),
        angular_frequency: 6.0,
        damping_ratio: 0.5
      )

      position = 0.0
      velocity = 0.0
      target = 100.0

      500.times do
        position, velocity = spring.update(position, velocity, target)
      end

      assert_in_delta target, position, 0.1
      assert_in_delta 0.0, velocity, 0.1
    end

    it "clamps negative angular_frequency and damping_ratio to zero" do
      spring = Spring.new(
        delta_time: Harmonica.fps(60),
        angular_frequency: -5.0,
        damping_ratio: -0.5
      )

      refute_nil spring
    end
  end
end
