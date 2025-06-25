defmodule Trackguests3Web.PageController do
  use Trackguests3Web, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
