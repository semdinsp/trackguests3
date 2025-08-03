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

    live_session :with_current_scope,
      on_mount: [{Trackguests3Web.UserAuth, :mount_current_scope}] do
      # Main routes that work with or without auth but need current_scope
      live("/residences", ResidencesLive.Index, :index)
      live("/residences/new", ResidencesLive.Form, :new)
      live("/residences/:id", ResidencesLive.Show, :show)
      live("/residences/:id/edit", ResidencesLive.Form, :edit)

      live("/rooms", RoomsLive.Index, :index)

      # Residence-specific room routes
      live("/residences/:residence_id/rooms", RoomsLive.Index, :residence_rooms)
      live("/residences/:residence_id/rooms/new", RoomsLive.Form, :new)
      live("/rooms/new", RoomsLive.Form, :new)
      live("/rooms/:id", RoomsLive.Show, :show)
      live("/rooms/:id/edit", RoomsLive.Form, :edit)

      # Property management routes
      live("/property", PropertyLive.Dashboard, :index)
      live("/property/new", PropertyLive.Form, :new)
      live("/property/edit", PropertyLive.Form, :edit)
      live("/property/select", PropertyLive.Select, :index)
      live("/property/rooms", PropertyLive.Rooms, :index)
      live("/property/rooms/new", PropertyLive.Rooms, :new)
      live("/property/rooms/:id/edit", PropertyLive.Rooms, :edit)

      # History routes
      live("/history", HistoryLive.Index, :index)
      
      # Visitor check-in route (public - no auth needed but can access current_scope)
      live("/visitor/check-in", VisitorLive.CheckIn, :index)
    end
    
    # Public guides page
    live("/guides", GuidesLive, :index)
    
    # Legal pages
    live("/privacy", PrivacyLive, :index)
    live("/tos", TermsOfServiceLive, :index)
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
      
      # Visitor check-out requires authentication to enforce property restrictions
      live("/visitor/check-out", VisitorLive.CheckOut, :index)
    end

    # CSV export route requires authentication to enforce property restrictions
    get("/history/export.csv", HistoryController, :export_csv)
    
    post("/users/update-password", UserSessionController, :update_password)
  end

  ## Admin routes

  scope "/admin", Trackguests3Web do
    pipe_through([:browser, :require_authenticated_user, :require_admin_user])

    live_session :require_admin,
      on_mount: [{Trackguests3Web.UserAuth, :require_admin}] do
      live("/", AdminLive.Dashboard, :index)
      
      # Users management
      live("/users", AdminLive.Users, :index)
      live("/users/:id/edit", AdminLive.Users, :edit)
      
      # Residences management
      live("/residences", AdminLive.Residences, :index)
      live("/residences/new", AdminLive.Residences, :new)
      live("/residences/:id/edit", AdminLive.Residences, :edit)
      
      # Rooms management
      live("/rooms", AdminLive.Rooms, :index)
      
      # Persons management
      live("/persons", AdminLive.Persons, :index)
    end
  end

  scope "/", Trackguests3Web do
    pipe_through([:browser])

    live_session :current_user,
      on_mount: [{Trackguests3Web.UserAuth, :mount_current_scope}] do
      live("/", DashboardLive, :index)
      live("/users/register", UserLive.Registration, :new)
      live("/users/log-in", UserLive.Login, :new)
      live("/users/log-in/:token", UserLive.Confirmation, :new)
    end

    post("/users/log-in", UserSessionController, :create)
    delete("/users/log-out", UserSessionController, :delete)
    
    # Google OAuth routes
    get("/auth/google", GoogleAuthController, :request)
    get("/auth/google/callback", GoogleAuthController, :callback)
  end
end
