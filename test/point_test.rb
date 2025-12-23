# frozen_string_literal: true

require_relative "test_helper"

module Harmonica
  class PointTest < Minitest::Spec
    it "initializes with x, y, z coordinates" do
      point = Point.new(1.0, 2.0, 3.0)

      assert_equal 1.0, point.x
      assert_equal 2.0, point.y
      assert_equal 3.0, point.z
    end

    it "defaults to origin (0, 0, 0)" do
      point = Point.new

      assert_equal 0.0, point.x
      assert_equal 0.0, point.y
      assert_equal 0.0, point.z
    end

    it "converts to array" do
      point = Point.new(1.0, 2.0, 3.0)

      assert_equal [1.0, 2.0, 3.0], point.to_a
    end

    it "compares equality by coordinates" do
      point1 = Point.new(1.0, 2.0, 3.0)
      point2 = Point.new(1.0, 2.0, 3.0)
      point3 = Point.new(1.0, 2.0, 4.0)

      assert_equal point1, point2
      refute_equal point1, point3
    end

    it "converts to string representation" do
      point = Point.new(1.0, 2.0, 3.0)

      assert_equal "Point(1.0, 2.0, 3.0)", point.to_s
    end

    it "allows mutation of coordinates" do
      point = Point.new(0, 0, 0)
      point.x = 10.0
      point.y = 20.0
      point.z = 30.0

      assert_equal 10.0, point.x
      assert_equal 20.0, point.y
      assert_equal 30.0, point.z
    end
  end
end
