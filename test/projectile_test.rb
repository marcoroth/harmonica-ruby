# frozen_string_literal: true

require_relative "test_helper"

module Harmonica
  class ProjectileTest < Minitest::Spec
    it "initializes with position, velocity, and acceleration" do
      projectile = Projectile.new(
        delta_time: Harmonica.fps(60),
        position: Point.new(0, 100, 0),
        velocity: Vector.new(10, 0, 0),
        acceleration: GRAVITY
      )

      assert_equal 0, projectile.position.x
      assert_equal 100, projectile.position.y
      assert_equal 10, projectile.velocity.x
      assert_in_delta(-9.81, projectile.acceleration.y, 0.001)
    end

    it "updates position based on velocity and delta_time" do
      delta_time = Harmonica.fps(60)
      projectile = Projectile.new(
        delta_time: delta_time,
        position: Point.new,
        velocity: Vector.new(60, 0, 0),
        acceleration: Vector.new(0, 0, 0)
      )

      position = projectile.update

      assert_in_delta 1.0, position.x, 0.0001
      assert_in_delta 0.0, position.y, 0.0001
    end

    it "applies gravity acceleration over time" do
      delta_time = Harmonica.fps(60)
      projectile = Projectile.new(
        delta_time: delta_time,
        position: Point.new(0, 100, 0),
        velocity: Vector.new(0, 0, 0),
        acceleration: GRAVITY
      )

      initial_y = projectile.position.y

      10.times { projectile.update }

      assert projectile.position.y < initial_y
      assert projectile.velocity.y.negative?
    end

    it "simulates parabolic motion" do
      delta_time = Harmonica.fps(60)
      projectile = Projectile.new(
        delta_time: delta_time,
        position: Point.new,
        velocity: Vector.new(10, 20, 0),
        acceleration: GRAVITY
      )

      max_y = 0.0

      200.times do
        position = projectile.update
        max_y = position.y if position.y > max_y
        break if position.y.negative? && projectile.velocity.y.negative?
      end

      assert max_y.positive?
      assert projectile.position.x.positive?
    end

    it "resets position and velocity" do
      projectile = Projectile.new(
        delta_time: Harmonica.fps(60),
        position: Point.new,
        velocity: Vector.new(10, 10, 0),
        acceleration: GRAVITY
      )

      10.times { projectile.update }

      projectile.reset(
        position: Point.new(100, 100, 0),
        velocity: Vector.new(0, 0, 0)
      )

      assert_equal 100, projectile.position.x
      assert_equal 100, projectile.position.y
      assert_equal 0, projectile.velocity.x
      assert_equal 0, projectile.velocity.y
    end
  end
end
