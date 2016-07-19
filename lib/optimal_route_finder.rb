# Usage: +OptimalRouteFinder.new("sample.csv", 1000).solve

require_relative 'graph_builder'

class OptimalRouteFinder

  attr_reader  :path_to_csv, :graph, :number_of_iterations

  def initialize(path_to_csv, number_of_iterations=50)
    @path_to_csv = path_to_csv
    @graph = GraphBuilder.new(path_to_csv).build
    @number_of_iterations = number_of_iterations
  end

  def solve
    solutions = []

    1.upto(number_of_iterations).each do |i|
      solutions << generate_route
    end

    find_optimal_route(solutions)
  end

  private

  def number_of_nodes
    CSV.read(path_to_csv).size
  end


  def generate_route
    # Returns[1,2,3,4,5] given a graph size of 6.
    # I.e. give a list of nodes we should check out in our search for the shortest path.
    # This is valid as we are dealing with a complete graph - meaning that all nodes are connected/
    # As a result `nodes_to_explore` can contain all node indexes.
    nodes_to_explore = [*1..number_of_nodes-1]

    # Initialize array for storing the edges between the nodes.
    edges = []

    # Sets a starting point.
    last_node = 0

    # Into the `edges` array we shovel a list of the connected edges.
    # I.e. [[0, 32], [32, 41], [41, 37], [37, 50], ...
    1.upto(number_of_nodes).each do |x|
      # Pick a node at random to explore. When there are no more, revert to 0.
      node = nodes_to_explore.sample ? nodes_to_explore.sample : 0

      #Shovel in the `origin` and `destination` node.
      edges << [last_node, node]

      # We have now traversed this so delete it from nodes_to_explore.
      nodes_to_explore.delete(node)

      # Set last last_node to the current node and continue.
      last_node = node
    end

    edges
  end

  def find_optimal_route(solutions)
    distances = []

    #Iterate through the solutions, calculate the distances & return the best result.
    solutions.each_with_index do |solution|
      distances << calculate_distance(solution)
    end

    shortest_distance = distances.min
    shortest_path = solutions[(distances.index(shortest_distance))]

    return "Shortest path is #{shortest_distance} via #{shortest_path}"
  end

  # Given the array of edges, we can calculate the distance of a given route.
  def calculate_distance(edges)
    distances = edges.collect { |edge| graph[edge] }
    distances.inject(:+).round(2)
  end
end