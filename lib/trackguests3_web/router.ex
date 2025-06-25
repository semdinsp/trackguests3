defmodule Trackguests3Web.Router do
  use Trackguests3Web, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, html: {Trackguests3Web.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", Trackguests3Web do
    pipe_through(:browser)

    # Visitor routes (public)
    live("/visitor/check-in", VisitorLive.CheckIn, :index)
    live("/visitor/check-out", VisitorLive.CheckOut, :index)
  end

  # Other scopes may use custom stacks.
  # scope "/api", Trackguests3Web do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:trackguests3, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: Trackguests3Web.Telemetry)
      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end

  ## Authentication routes

  scope "/", Trackguests3Web do
    pipe_through([:browser, :require_authenticated_user])

    live_session :require_authenticated_user do
      live("/", ResidenceLive.Index, :index)
      live("/residences", ResidenceLive.Index, :index)
      live("/residences/new", ResidenceLive.Form, :new)
      live("/residences/:id", ResidenceLive.Show, :show)
      live("/residences/:id/edit", ResidenceLive.Form, :edit)

      live("/rooms", RoomsLive.Index, :index)
      live("/rooms/new", RoomsLive.Form, :new)
      live("/rooms/:id", RoomsLive.Show, :show)
      live("/rooms/:id/edit", RoomsLive.Form, :edit)

      live("/users/settings", UserLive.Settings, :edit)
      live("/users/settings/confirm-email/:token", UserLive.Settings, :confirm_email)

      live("/users/settings", UserLive.Settings, :edit)
      live("/users/settings/confirm-email/:token", UserLive.Settings, :confirm_email)
    end

    post("/users/update-password", UserSessionController, :update_password)
  end

  scope "/", Trackguests3Web do
    pipe_through([:browser])

    live_session :current_user do
      live("/users/register", UserLive.Registration, :new)
      live("/users/log-in", UserLive.Login, :new)
      live("/users/log-in/:token", UserLive.Confirmation, :new)
    end

    post("/users/log-in", UserSessionController, :create)
    delete("/users/log-out", UserSessionController, :delete)
  end
end
