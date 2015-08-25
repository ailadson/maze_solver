class Maze
  attr_accessor :grid, :current_position

  def initialize(filename)
    @grid = create_maze(filename)
  end

  def create_maze(filename)
    g = []
    File.readlines(filename).each do |line|
      g << line.chomp.split("")
    end
    g
  end

  def valid_move?(position, move)
    idx1 = position[0] + move[0]
    idx2 = position[1] + move[1]
    return true unless @grid[idx1][idx2] == "*" || @grid[idx1][idx2] == "E" || @grid[idx1][idx2] == "S" || @grid[idx1][idx2].is_a?(Fixnum) || @grid[idx1][idx2].nil?
  end

  def find_start
    find_point("S")
  end

  def clean_up
    @grid.each_with_index do |row, idx1|
      row.each_with_index do |ele, idx2|
        @grid[idx1][idx2] = " " if ele.is_a?(Fixnum)
      end
    end
  end

  def find_end
    find_point("E")
  end

  def tag_spot(position, tag)
    idx1 = position[0]
    idx2 = position[1]
    @grid[idx1][idx2] = tag
  end

  def find_points(n)
    points = []
    @grid.each_with_index do |row, idx1|
      row.each_with_index do |ele, idx2|
        points << [idx1,idx2] if ele == n
      end
    end
    points
  end

  def find_point(point)
    @grid.each_with_index do |row, idx1|
      row.each_with_index do |ele, idx2|
        return [idx1,idx2] if ele == point
      end
    end
  end
end
