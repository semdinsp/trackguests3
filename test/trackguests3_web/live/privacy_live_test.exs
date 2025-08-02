defmodule Trackguests3Web.PrivacyLiveTest do
  use Trackguests3Web.ConnCase

  import Phoenix.LiveViewTest

  describe "Privacy page" do
    test "renders privacy policy page", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/privacy")

      # Check for main heading
      assert html =~ "Privacy Policy"
      
      # Check for data confidentiality section
      assert html =~ "All Data is Confidential"
      assert html =~ "strictly confidential"
      
      # Check for key sections
      assert html =~ "Information We Collect"
      assert html =~ "How We Use Your Information"
      assert html =~ "Data Security"
      assert html =~ "Your Rights"
      assert html =~ "Contact Us"
      
      # Check for confidentiality guarantees
      assert html =~ "never shared, sold, or disclosed to third parties"
      assert html =~ "encrypted and stored securely"
      assert html =~ "do not analyze, mine, or use your data for commercial purposes"
    end

    test "displays current date in last updated", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/privacy")
      
      current_year = Date.utc_today().year |> to_string()
      assert html =~ "Last updated:"
      assert html =~ current_year
    end

    test "includes contact information", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/privacy")
      
      assert html =~ "privacy@trackguest.com"
      assert html =~ "Response Time:"
    end

    test "has proper page title", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/privacy")
      
      assert page_title(lv) =~ "Privacy Policy"
    end

    test "includes data security measures", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/privacy")
      
      assert html =~ "Encrypted data transmission"
      assert html =~ "HTTPS/TLS"
      assert html =~ "Secure database storage"
      assert html =~ "encryption at rest"
    end

    test "lists user rights", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/privacy")
      
      assert html =~ "Access:"
      assert html =~ "Correction:"
      assert html =~ "Deletion:"
      assert html =~ "Export:"
      assert html =~ "Restriction:"
    end

    test "mentions guest data types", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/privacy")
      
      assert html =~ "Guest check-in and check-out information"
      assert html =~ "Visitor personal details"
      assert html =~ "Property information and room assignments"
    end

    test "includes policy update information", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/privacy")
      
      assert html =~ "Policy Updates"
      assert html =~ "notify you of any significant changes"
    end
  end
end