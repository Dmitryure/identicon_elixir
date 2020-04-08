defmodule IdenticonElixir do
  def main(input) do
    pixels = 75
    input 
    |> hash_input 
    |> split_into_color_and_hex(3)
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map(pixels)
    |> draw_image(pixels)
    |> save_image(input)
  end

  def save_image(image, filename) do
    File.write("#{filename}.png", image)
  end

  def draw_image(%IdenticonElixir.Image{color: color, pixel_map: pixel_map}, pixels) do
    image = :egd.create(pixels * 5, pixels * 5)
    fill = :egd.color(color)

    Enum.each pixel_map, fn({start, stop}) ->
      :egd.filledRectangle(image, start, stop, fill)
    end

    :egd.render(image)
  end

  def build_pixel_map(%IdenticonElixir.Image{grid: grid} = struct, pixels) do
    %IdenticonElixir.Image{struct | pixel_map: Enum.map(grid, fn({_value, index}) ->
      horizontal = rem(index, 5) * pixels
      vertical = div(index, 5) * pixels
      top_left = {horizontal, vertical}
      bottom_right = {horizontal + pixels, vertical + pixels}
      {top_left, bottom_right}
    end
    )}
  end

  def build_grid(%IdenticonElixir.Image{hex: hex, color: _color} = struct) do
    %IdenticonElixir.Image{struct | grid: 
		hex 
		|> Enum.chunk(3) 
		|> Enum.map(&mirror_row/1) 
		|> List.flatten 
		|> Enum.with_index
  }
  end

	def filter_odd_squares(%IdenticonElixir.Image{grid: grid} = struct) do
	  %IdenticonElixir.Image{struct | grid: Enum.filter(grid, fn({value, _index}) -> rem(value, 2) == 0 end)}
	end

  def mirror_row([first, second | _tail] = row) do
    row ++ [second, first]
  end
  def split_into_color_and_hex(list, count) do
    Enum.split(list, count)
  end

  def pick_color({color, hex}) do
    %IdenticonElixir.Image{color: List.to_tuple(color), hex: Enum.concat(color,hex)}
  end

  def hash_input(input) do
    :crypto.hash(:md5, input)
    |> :binary.bin_to_list
  end

end
