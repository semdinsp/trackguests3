defmodule Trackguests3.Repo do
  use Ecto.Repo,
    otp_app: :trackguests3,
    adapter: Ecto.Adapters.SQLite3
end
