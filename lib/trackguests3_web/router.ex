defmodule Trackguests3Web.Router do
  use Trackguests3Web, :router

  import Trackguests3Web.UserAuth

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, html: {Trackguests3Web.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:fetch_current_scope_for_user)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", Trackguests3Web do
    pipe_through(:browser)

    # Main routes
    live("/", DashboardLive, :index)
    live("/residences", ResidenceLive.Index, :index)
    live("/residences/new", ResidenceLive.Form, :new)
    live("/residences/:id", ResidenceLive.Show, :show)
    live("/residences/:id/edit", ResidenceLive.Form, :edit)

    live("/rooms", RoomsLive.Index, :index)
    live("/rooms/new", RoomsLive.Form, :new)
    live("/rooms/:id", RoomsLive.Show, :show)
    live("/rooms/:id/edit", RoomsLive.Form, :edit)

    # Visitor routes (public)
    live("/visitor/check-in", VisitorLive.CheckIn, :index)
    live("/visitor/check-out", VisitorLive.CheckOut, :index)
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:trackguests3, :dev_routes) do
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

    live_session :require_authenticated_user,
      on_mount: [{Trackguests3Web.UserAuth, :require_authenticated}] do
      live("/users/settings", UserLive.Settings, :edit)
      live("/users/settings/confirm-email/:token", UserLive.Settings, :confirm_email)
    end

    post("/users/update-password", UserSessionController, :update_password)
  end

  scope "/", Trackguests3Web do
    pipe_through([:browser])

    live_session :current_user,
      on_mount: [{Trackguests3Web.UserAuth, :mount_current_scope}] do
      live("/users/register", UserLive.Registration, :new)
      live("/users/log-in", UserLive.Login, :new)
      live("/users/log-in/:token", UserLive.Confirmation, :new)
    end

    post("/users/log-in", UserSessionController, :create)
    delete("/users/log-out", UserSessionController, :delete)
  end
end
