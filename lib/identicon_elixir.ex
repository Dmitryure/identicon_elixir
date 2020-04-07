defmodule IdenticonElixir do
  def main(input) do
    input 
    |> hash_input
    |> pick_color
  end

  def hash_input(input) do
    
    %IdenticonElixir.Image {
      hex:
        :crypto.hash(:md5, input)
        |> :binary.bin_to_list
    }

  end

  def pick_color(image) do
    %IdenticonElixir.Image{hex: hex_list} = image
    [r, g, b | _tail] = hex_list
    [r, g, b]
  end

end
