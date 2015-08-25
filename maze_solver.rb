require "./maze.rb"

class MazeSolver
  attr_accessor :step, :maze, :current_position

  def initialize
    @step = 1
    @path = []
    @maze = Maze.new(ARGV[0])
    @current_position = @maze.find_end
    @neighbors = [[-1,0],[1,0],[0,-1],[0,1]]
  end

  def find_path
    find_reverse_path
    find_shortest_path
    clean_up
    draw_path
  end

  def draw_path
    @current_position = @maze.find_start
    display
    sleep 1
    @path.each do |step|
      @current_position[0] += step[0]
      @current_position[1] += step[1]
      @maze.grid[@current_position[0]][@current_position[1]] = "X"
      display
      sleep 0.5
    end
  end

  def find_shortest_path
    @current_position = @maze.find_start
    end_step = @maze.find_end

    until @current_position == end_step
      @path << get_shorest_step #modifies @current_position
    end

    @path
  end

  def clean_up
    @maze.clean_up
  end

  def get_shorest_step
    step_value = 99999 #bad, but i need a large number
    shortest_step = []
    @neighbors.each do |neighbor|
      idx1 = @current_position[0] + neighbor[0]
      idx2 = @current_position[1] + neighbor[1]
      value = @maze.grid[idx1][idx2]
      if (value.is_a?(Fixnum) && value < step_value) || @maze.grid[idx1][idx2] == "E"
        step_value = @maze.grid[idx1][idx2]
        shortest_step = neighbor
      end
    end
    idx1 = @current_position[0] + shortest_step[0]
    idx2 = @current_position[1] + shortest_step[1]
    @current_position = [idx1, idx2]
    shortest_step
  end

  def find_reverse_path
    mark_adjacent_steps(@current_position)

    # until start_found?
    until start_found?
      stepped_positions = @maze.find_points(@step)
      @step += 1
      stepped_positions.each { |pos| mark_adjacent_steps(pos) }
    end

  end

  def start_found?
    @neighbors.each do |neighbor|
      start_position = maze.find_start
      idx1 = start_position[0] + neighbor[0]
      idx2 = start_position[1] + neighbor[1]
      return true if @maze.grid[idx1][idx2].is_a?(Fixnum)
    end
    false
  end


  def mark_adjacent_steps(pos)
    @neighbors.each do |neighbor|
      if @maze.valid_move?(pos, neighbor)
        position = [pos[0] + neighbor[0], pos[1] + neighbor[1]]
        @maze.tag_spot(position, @step)
      end
    end
  end

  def display
    system("clear")
    @maze.grid.each do |row|
      p row
    end
  end
end

maze_solver = MazeSolver.new
maze_solver.find_path
