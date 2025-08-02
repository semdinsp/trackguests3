defmodule Trackguests3Web.TermsOfServiceLiveTest do
  use Trackguests3Web.ConnCase

  import Phoenix.LiveViewTest

  describe "Terms of Service page" do
    test "renders terms of service page", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/tos")

      # Check for main heading
      assert html =~ "Terms of Service"
      
      # Check for data confidentiality highlight
      assert html =~ "Data Confidentiality Commitment"
      assert html =~ "All data stored in TrackGuest is strictly confidential"
      
      # Check for key sections
      assert html =~ "Acceptance of Terms"
      assert html =~ "Description of Service"
      assert html =~ "User Responsibilities"
      assert html =~ "Data and Privacy"
      assert html =~ "Service Availability"
      assert html =~ "Prohibited Uses"
      assert html =~ "Intellectual Property"
      assert html =~ "Limitation of Liability"
      assert html =~ "Termination"
      assert html =~ "Contact Information"
    end

    test "displays current date in last updated and effective date", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/tos")
      
      current_year = Date.utc_today().year |> to_string()
      assert html =~ "Last updated:"
      assert html =~ "effective as of"
      assert html =~ current_year
    end

    test "includes service description", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/tos")
      
      assert html =~ "Track guest check-ins and check-outs"
      assert html =~ "Manage visitor information and room assignments"
      assert html =~ "Generate reports and export guest data"
      assert html =~ "Maintain property and room information"
      assert html =~ "multi-language support"
    end

    test "has proper page title", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/tos")
      
      assert page_title(lv) =~ "Terms of Service"
    end

    test "includes user responsibilities", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/tos")
      
      assert html =~ "Account Security"
      assert html =~ "Lawful Use"
      assert html =~ "Data Accuracy"
      assert html =~ "Guest Consent"
      assert html =~ "obtain appropriate consent from guests"
    end

    test "lists prohibited uses", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/tos")
      
      assert html =~ "illegal, harmful, or offensive content"
      assert html =~ "Violate any applicable laws"
      assert html =~ "Infringe on intellectual property rights"
      assert html =~ "unauthorized access"
      assert html =~ "Interfere with the proper functioning"
    end

    test "includes confidentiality guarantees", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/tos")
      
      assert html =~ "Confidentiality Guarantee"
      assert html =~ "We do not access, analyze"
      assert html =~ "Your guest data remains your property"
      assert html =~ "export or delete your data at any time"
    end

    test "includes termination terms", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/tos")
      
      assert html =~ "delete your account and stop using the service"
      assert html =~ "terminate accounts that violate these terms"
      assert html =~ "your data will be deleted"
      assert html =~ "export your data before termination"
    end

    test "includes contact information", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/tos")
      
      assert html =~ "legal@trackguest.com"
      assert html =~ "Response Time:"
      assert html =~ "48 hours"
    end

    test "links to privacy policy", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/tos")
      
      assert html =~ ~s{href="/privacy"}
      assert html =~ "Privacy Policy"
    end

    test "mentions service as provided 'as is'", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/tos")
      
      assert html =~ "as is"
      assert html =~ "without warranties of any kind"
    end

    test "includes intellectual property section", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/tos")
      
      assert html =~ "TrackGuest and its original content"
      assert html =~ "international copyright, trademark"
      assert html =~ "Your guest data remains your property"
    end
  end
end