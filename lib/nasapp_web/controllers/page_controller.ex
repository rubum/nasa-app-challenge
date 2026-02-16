defmodule NasappWeb.PageController do
  use NasappWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
