defmodule Trackguests3.Repo do
  use Ecto.Repo,
    otp_app: :trackguests3,
    #adapter: Ecto.Adapters.SQLite3
    adapter: if(Mix.env() in [:dev, :test],
        do: Ecto.Adapters.SQLite3,
        else: Ecto.Adapters.Postgres
      )
end
