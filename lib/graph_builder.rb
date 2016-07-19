# This class accepts a CSV file and outputs a Ruby hash showing the distance between all nodes.
#
# Usage: GraphBuilder.new("sample.csv").build
#
# Example CSV:
# Row 1: 1, 2 (Node 0)
# Row 2: 2, 4 (Node 1)
# Row 3: 1, 3 (Node 2)
#
# These values represents points a grid we will create. They are coordinates (x, y).
#
# Imagine a (zero indexed) 4 x 4 grid:
#
#        0     1      2      3
#      ----------------------------
#   0  | x     Node0  Node2  x
#   1  | x     x      x      Node1
#   2  | x     x      x      x
#   3  | x     x      x      x
#
# Output: {
#           [0, 0]=>0, [0, 1]=>2.24, [0, 2]=>1.0,
#           [1, 0]=>2.24, [1, 1]=>0, [1, 2]=>1.41,
#           [2, 0]=>1.0, [2, 1]=>1.41, [2, 2]=>0
#         }
#
# Show thats the straightline distance from:
# =>  Node 0 (0, 1) to Node 1 (1, 3) is 2.24.
# =>  Node 0 (0, 1) to Node 2 (0, 2) is 1.0. (I.e. just adjacent horizontally.)
#
# =>  Node 2 (0, 2) to Node 1 (1, 3) is 1.41.

require 'csv'

class GraphBuilder
  include Math

  attr_reader :coordinates

  def initialize(path_to_csv)
    @coordinates = CSV.read(path_to_csv)
    transform_to_integer(coordinates)
  end

  def build
    build_hash(coordinates)
  end

  private

  def build_hash(coordinates)
    hash = {}

    coordinates.each_with_index do |coordinate_1, index_1|
      coordinates.each_with_index do |coordinate_2, index_2|
        if index_1 == index_2
          hash[[index_1, index_2]] = 0
        else
          hash[[index_1, index_2]] = calculate_straightline_distance(coordinate_1, coordinate_2)
        end
      end
    end

    hash
  end

  def calculate_straightline_distance(coordinate_1, coordinate_2)
    sum_of_squares = 0
    coordinate_1.each_with_index do |first_coord,index|
      sum_of_squares += (first_coord - coordinate_2[index]) ** 2
    end
    Math.sqrt(sum_of_squares).round(2)
  end

  def transform_to_integer(coordinates)
    coordinates.map!{|coord| [coord[0].to_i,coord[1].to_i] }
  end
end