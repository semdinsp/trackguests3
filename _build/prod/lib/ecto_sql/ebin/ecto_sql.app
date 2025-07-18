{application,ecto_sql,
             [{modules,['Elixir.Collectable.Ecto.Adapters.SQL.Stream',
                        'Elixir.Ecto.Adapter.Migration',
                        'Elixir.Ecto.Adapter.Structure',
                        'Elixir.Ecto.Adapters.MyXQL',
                        'Elixir.Ecto.Adapters.Postgres',
                        'Elixir.Ecto.Adapters.Postgres.Connection',
                        'Elixir.Ecto.Adapters.SQL',
                        'Elixir.Ecto.Adapters.SQL.Application',
                        'Elixir.Ecto.Adapters.SQL.Connection',
                        'Elixir.Ecto.Adapters.SQL.Sandbox',
                        'Elixir.Ecto.Adapters.SQL.Sandbox.Connection',
                        'Elixir.Ecto.Adapters.SQL.Stream',
                        'Elixir.Ecto.Adapters.Tds','Elixir.Ecto.Migration',
                        'Elixir.Ecto.Migration.Command',
                        'Elixir.Ecto.Migration.Constraint',
                        'Elixir.Ecto.Migration.Index',
                        'Elixir.Ecto.Migration.Reference',
                        'Elixir.Ecto.Migration.Runner',
                        'Elixir.Ecto.Migration.SchemaMigration',
                        'Elixir.Ecto.Migration.Table','Elixir.Ecto.Migrator',
                        'Elixir.Enumerable.Ecto.Adapters.SQL.Stream',
                        'Elixir.Mix.EctoSQL','Elixir.Mix.Tasks.Ecto.Dump',
                        'Elixir.Mix.Tasks.Ecto.Gen.Migration',
                        'Elixir.Mix.Tasks.Ecto.Load',
                        'Elixir.Mix.Tasks.Ecto.Migrate',
                        'Elixir.Mix.Tasks.Ecto.Migrations',
                        'Elixir.Mix.Tasks.Ecto.Rollback']},
              {optional_applications,[postgrex,myxql,tds]},
              {applications,[kernel,stdlib,elixir,logger,eex,ecto,telemetry,
                             db_connection,postgrex,myxql,tds]},
              {description,"SQL-based adapters for Ecto and database migrations"},
              {registered,[]},
              {vsn,"3.13.1"},
              {env,[{postgres_map_type,<<"jsonb">>}]},
              {mod,{'Elixir.Ecto.Adapters.SQL.Application',[]}}]}.
