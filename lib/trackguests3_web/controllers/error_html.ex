defmodule Trackguests3Web.ErrorHTML do
  @moduledoc """
  This module is invoked by your endpoint in case of errors on HTML requests.

  Every status renders the same branded, self-contained page (errors are
  rendered with `layout: false`, see config/config.exs), so visitors always
  get the TrackGuests look and a way back into the app.

  In development `debug_errors: true` shows Phoenix's debug page instead;
  set it to false in config/dev.exs to preview these pages locally.
  """
  use Trackguests3Web, :html

  def render(template, _assigns) do
    status = template |> String.split(".") |> hd()
    {title, message} = copy(status)

    error_page(%{status: status, title: title, message: message})
  end

  defp copy("404") do
    {gettext("Page not found"),
     gettext("The page you're looking for doesn't exist or may have moved.")}
  end

  defp copy("403") do
    {gettext("Access denied"), gettext("You don't have permission to view this page.")}
  end

  defp copy("500") do
    {gettext("Something went wrong"),
     gettext("We hit an unexpected problem on our side. Please try again in a moment.")}
  end

  defp copy(status) do
    {Phoenix.Controller.status_message_from_template(status <> ".html"),
     gettext("We couldn't complete that request. Please go back and try again.")}
  end

  attr :status, :string, required: true
  attr :title, :string, required: true
  attr :message, :string, required: true

  def error_page(assigns) do
    ~H"""
    <!DOCTYPE html>
    <html lang="en" data-theme="light">
      <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <meta name="robots" content="noindex" />
        <title>{@title} · TrackGuests</title>
        <script>
          try { document.documentElement.setAttribute("data-theme", localStorage.getItem("theme") || "light") } catch (_) {}
        </script>
        <link rel="stylesheet" href={~p"/assets/css/app.css"} />
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
        <link
          href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;600;700&display=swap"
          rel="stylesheet"
        />
      </head>
      <body class="gradient-bg-luxury font-['Open_Sans'] text-gray-900 antialiased min-h-screen flex flex-col">
        <header class="glass-luxury border-b border-gray-200/50">
          <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center">
            <a href={~p"/"} class="flex items-center gap-2" aria-label={gettext("TrackGuests Home")}>
              <span class="w-10 h-10 gradient-header-luxury rounded-lg flex items-center justify-center text-white font-bold text-lg">
                TG
              </span>
              <span class="text-xl font-bold text-platinum tracking-tight">TrackGuests</span>
            </a>
          </div>
        </header>

        <main id="main-content" class="flex-1 flex items-center justify-center px-4 py-16">
          <div class="card-luxury w-full max-w-lg text-center">
            <p class="text-sm font-semibold tracking-widest text-gray-500">
              {gettext("Error %{status}", status: @status)}
            </p>
            <h1 class="mt-2 text-3xl sm:text-4xl font-bold text-platinum">{@title}</h1>
            <p class="mt-4 text-lg text-gray-600">{@message}</p>
            <div class="mt-8 flex flex-col sm:flex-row gap-3 justify-center">
              <a href={~p"/"} class="btn-primary">{gettext("Go to home page")}</a>
              <a href={~p"/visitor/check-in"} class="btn-luxury">{gettext("Guest check-in")}</a>
            </div>
          </div>
        </main>
      </body>
    </html>
    """
  end
end
