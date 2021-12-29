defmodule Patreon.TypeSpecHelpers do
  defmacro struct_to_option_list(name, struct_ast, keys_to_drop) do

    #Take the modules atoms
    {_, _, struct_atoms} = struct_ast

    struct =
    Enum.join([:Elixir | struct_atoms], ".")
    |> String.to_atom()
    |> Kernel.struct()

    [last, prev | rest] =
      Map.drop(struct, [:__struct__])
      |> Map.drop(keys_to_drop)
      |> Map.keys()
      |> Enum.reverse()

      type =
        Enum.reduce(rest, {:|, [], [prev, last]}, &{:|, [], [&1, &2]})


    quote do
      @type unquote(name) :: [unquote(type)]
    end
  end

end
