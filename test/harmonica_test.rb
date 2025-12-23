# frozen_string_literal: true

require_relative "test_helper"

module Harmonica
  class HarmonicaTest < Minitest::Spec
    it "has a version number" do
      refute_nil VERSION
    end

    it "calculates fps as delta time" do
      assert_in_delta 1.0 / 60, Harmonica.fps(60), 0.0001
      assert_in_delta 1.0 / 30, Harmonica.fps(30), 0.0001
      assert_in_delta 1.0 / 120, Harmonica.fps(120), 0.0001
    end

    it "defines gravity constant for bottom-left origin" do
      assert_equal 0, GRAVITY.x
      assert_in_delta(-9.81, GRAVITY.y, 0.001)
      assert_equal 0, GRAVITY.z
    end

    it "defines terminal gravity constant for top-left origin" do
      assert_equal 0, TERMINAL_GRAVITY.x
      assert_in_delta 9.81, TERMINAL_GRAVITY.y, 0.001
      assert_equal 0, TERMINAL_GRAVITY.z
    end
  end
end
