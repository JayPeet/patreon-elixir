defmodule Patreon.TypeSpecHelpers do
  defp create_option_list_ast(struct_ast, keys_to_drop) do
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

      Enum.reduce(rest, {:|, [], [prev, last]}, &{:|, [], [&1, &2]})
  end

  defmacro struct_to_option_list(_name, struct_ast, keys_to_drop) do
    type = create_option_list_ast(struct_ast, keys_to_drop)
    quote do
      [unquote(type)]
    end
  end

  defmacro struct_to_allowed_option_type(name, struct_ast, keys_to_drop) do
    type = create_option_list_ast(struct_ast, keys_to_drop)

    quote do
      @type unquote(name) :: unquote(type)
    end
  end

end
