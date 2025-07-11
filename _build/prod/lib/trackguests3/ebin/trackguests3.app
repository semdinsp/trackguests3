{application,trackguests3,
    [{modules,
         ['Elixir.Inspect.Trackguests3.Accounts.User','Elixir.Trackguests3',
          'Elixir.Trackguests3.Accomodation',
          'Elixir.Trackguests3.Accomodation.Residence',
          'Elixir.Trackguests3.Accomodation.Rooms',
          'Elixir.Trackguests3.Accounts','Elixir.Trackguests3.Accounts.Scope',
          'Elixir.Trackguests3.Accounts.User',
          'Elixir.Trackguests3.Accounts.UserNotifier',
          'Elixir.Trackguests3.Accounts.UserToken',
          'Elixir.Trackguests3.Application','Elixir.Trackguests3.Mailer',
          'Elixir.Trackguests3.Persons','Elixir.Trackguests3.Persons.Person',
          'Elixir.Trackguests3.Release','Elixir.Trackguests3.Repo',
          'Elixir.Trackguests3Web','Elixir.Trackguests3Web.CoreComponents',
          'Elixir.Trackguests3Web.Endpoint',
          'Elixir.Trackguests3Web.ErrorHTML',
          'Elixir.Trackguests3Web.ErrorJSON','Elixir.Trackguests3Web.Gettext',
          'Elixir.Trackguests3Web.Layouts',
          'Elixir.Trackguests3Web.PageController',
          'Elixir.Trackguests3Web.PageHTML',
          'Elixir.Trackguests3Web.ResidenceLive.Form',
          'Elixir.Trackguests3Web.ResidenceLive.Index',
          'Elixir.Trackguests3Web.ResidenceLive.Show',
          'Elixir.Trackguests3Web.RoomsLive.Form',
          'Elixir.Trackguests3Web.RoomsLive.Index',
          'Elixir.Trackguests3Web.RoomsLive.Show',
          'Elixir.Trackguests3Web.Router','Elixir.Trackguests3Web.Telemetry',
          'Elixir.Trackguests3Web.UserAuth',
          'Elixir.Trackguests3Web.UserLive.Confirmation',
          'Elixir.Trackguests3Web.UserLive.Login',
          'Elixir.Trackguests3Web.UserLive.Registration',
          'Elixir.Trackguests3Web.UserLive.Settings',
          'Elixir.Trackguests3Web.UserSessionController',
          'Elixir.Trackguests3Web.VisitorLive.CheckIn',
          'Elixir.Trackguests3Web.VisitorLive.CheckOut']},
     {compile_env,
         [{trackguests3,['Elixir.Trackguests3Web.Gettext'],error},
          {trackguests3,[dev_routes],error}]},
     {optional_applications,[]},
     {applications,
         [kernel,stdlib,elixir,logger,runtime_tools,bcrypt_elixir,phoenix,
          phoenix_ecto,ecto_sql,ecto_sqlite3,postgrex,phoenix_html,
          phoenix_live_view,phoenix_live_dashboard,swoosh,finch,
          telemetry_metrics,telemetry_poller,gettext,jason,dns_cluster,
          bandit]},
     {description,"trackguests3"},
     {registered,[]},
     {vsn,"0.1.0"},
     {mod,{'Elixir.Trackguests3.Application',[]}}]}.
