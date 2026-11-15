defmodule Trackguests3Web.ErrorHTMLTest do
  use Trackguests3Web.ConnCase, async: true

  # Bring render_to_string/4 for testing custom views
  import Phoenix.Template, only: [render_to_string: 4]

  test "renders a branded 404 page with a way home" do
    html = render_to_string(Trackguests3Web.ErrorHTML, "404", "html", [])

    assert html =~ "<!DOCTYPE html>"
    assert html =~ "TrackGuests"
    assert html =~ "Page not found"
    assert html =~ "Error 404"
    assert html =~ ~s(href="/")
    assert html =~ "/assets/css/app.css"
  end

  test "renders a branded 500 page" do
    html = render_to_string(Trackguests3Web.ErrorHTML, "500", "html", [])

    assert html =~ "Something went wrong"
    assert html =~ "Error 500"
    assert html =~ "TrackGuests"
  end

  test "renders a branded page for other statuses" do
    html = render_to_string(Trackguests3Web.ErrorHTML, "400", "html", [])

    assert html =~ "Bad Request"
    assert html =~ "Error 400"
    assert html =~ "TrackGuests"
  end

  test "unknown URLs get the branded 404 page", %{conn: conn} do
    body = conn |> get("/this-page-does-not-exist") |> html_response(404)

    assert body =~ "Page not found"
    assert body =~ "TrackGuests"
  end
end
