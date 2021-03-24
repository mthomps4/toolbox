defmodule Toolbox.Gcp do
  def authenticate, do: Goth.fetch(Toolbox.Goth)
end
