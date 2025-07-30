defmodule Trackguests3Web.GuidesLiveTest do
  use Trackguests3Web.ConnCase

  import Phoenix.LiveViewTest
  import Trackguests3.AccountsFixtures

  describe "Guides page" do
    test "renders the guides page successfully", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/guides")

      # Check main page elements
      assert html =~ "TrackGuests User Guides"
      assert html =~ "Comprehensive guides to help you make the most"
      assert html =~ "Overview"
      assert html =~ "Guest Check-In"
      assert html =~ "Guest Check-Out"
      assert html =~ "Features"
      assert html =~ "Admin Guide"
    end

    test "mounts with default overview section", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/guides")

      # Should default to overview section
      assert has_element?(index_live, "button[phx-value-section='overview'][class*='border-purple-500']")
    end

    test "displays overview section content by default", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/guides")

      # Check overview section content - HTML entity encoding changes & to &amp;
      assert html =~ "Welcome to TrackGuests"
      assert html =~ "Quick &amp; Easy"
      assert html =~ "Secure &amp; Reliable"
      assert html =~ "Real-time Analytics"
      assert html =~ "Getting Started"
      assert html =~ "For Visitors"
      assert html =~ "For Property Managers"
    end

    test "switches to check-in section when clicked", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/guides")

      # Click check-in tab
      index_live
      |> element("button[phx-value-section='check-in']")
      |> render_click()

      # Check that check-in content is displayed
      html = render(index_live)
      assert html =~ "Guest Check-In Process"
      assert html =~ "Step-by-Step Instructions"
      assert html =~ "Navigate to Check-In"
      assert html =~ "Select Property"
      assert html =~ "Enter Guest Information"
      assert html =~ "Select Destination Room"
      assert html =~ "Complete Check-In"
      assert html =~ "Smart Room Search"
      assert html =~ "Pro Tips for Efficient Check-In"
    end

    test "switches to check-out section when clicked", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/guides")

      # Click check-out tab
      index_live
      |> element("button[phx-value-section='check-out']")
      |> render_click()

      # Check that check-out content is displayed
      html = render(index_live)
      assert html =~ "Guest Check-Out Process"
      assert html =~ "How to Check Out Visitors"
      assert html =~ "Access Check-Out Page"
      assert html =~ "Review Active Visitors"
      assert html =~ "Select Visitor to Check Out"
      assert html =~ "Confirm Check-Out"
      assert html =~ "Real-Time Status"
      assert html =~ "Check-Out Best Practices"
    end

    test "switches to features section when clicked", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/guides")

      # Click features tab
      index_live
      |> element("button[phx-value-section='features']")
      |> render_click()

      # Check that features content is displayed - HTML entity encoding changes & to &amp;
      html = render(index_live)
      assert html =~ "Platform Features"
      assert html =~ "Visitor Management"
      assert html =~ "Property &amp; Room Management"
      assert html =~ "Analytics &amp; Reporting"
      assert html =~ "Security &amp; Access Control"
      assert html =~ "Multi-language Support"
      assert html =~ "Mobile Responsive"
      assert html =~ "Advanced Capabilities"
      assert html =~ "Real-time Updates"
      assert html =~ "Integration &amp; Compatibility"
    end

    test "switches to admin section when clicked", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/guides")

      # Click admin tab
      index_live
      |> element("button[phx-value-section='admin']")
      |> render_click()

      # Check that admin content is displayed
      html = render(index_live)
      assert html =~ "Administrator Guide"
      assert html =~ "Administrative Capabilities"
      assert html =~ "Key Responsibilities"
      assert html =~ "User Account Management"
      assert html =~ "System Monitoring"
      assert html =~ "User Permission Levels"
      assert html =~ "Administrator"
      assert html =~ "Property Manager"
      assert html =~ "Guest/Public"
      assert html =~ "Common Administrative Tasks"
      assert html =~ "Common Issues &amp; Solutions"
    end

    test "tab navigation updates active state correctly", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/guides")

      # Initially overview should be active
      assert has_element?(index_live, "button[phx-value-section='overview'][class*='border-purple-500']")
      refute has_element?(index_live, "button[phx-value-section='check-in'][class*='border-purple-500']")

      # Click check-in tab
      index_live
      |> element("button[phx-value-section='check-in']")
      |> render_click()

      # Now check-in should be active, overview should not
      refute has_element?(index_live, "button[phx-value-section='overview'][class*='border-purple-500']")
      assert has_element?(index_live, "button[phx-value-section='check-in'][class*='border-purple-500']")

      # Click features tab
      index_live
      |> element("button[phx-value-section='features']")
      |> render_click()

      # Now features should be active
      refute has_element?(index_live, "button[phx-value-section='check-in'][class*='border-purple-500']")
      assert has_element?(index_live, "button[phx-value-section='features'][class*='border-purple-500']")
    end

    test "displays correct icons for each section", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/guides")

      # Check that each tab has its appropriate icon (SVG elements)
      assert html =~ "Overview"
      assert html =~ "Guest Check-In"
      assert html =~ "Guest Check-Out"
      assert html =~ "Features"
      assert html =~ "Admin Guide"
      # Check that SVG icons are present (note: HTML renders as viewbox, not viewBox)
      assert html =~ "viewbox=\"0 0 24 24\""
    end

    test "includes navigation links in footer", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/guides")

      # Check footer navigation
      assert html =~ "Need More Help?"
      assert html =~ "Return to Dashboard"
      assert html =~ "Start Guest Check-In"
      assert html =~ ~r/href="\/".*Return to Dashboard/s
      assert html =~ ~r/href="\/visitor\/check-in".*Start Guest Check-In/s
    end

    test "includes help and contact information", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/guides")

      # Check help section - HTML entity encoding changes apostrophes
      assert html =~ "Can&#39;t find what you&#39;re looking for?"
      assert html =~ "Contact your system administrator"
    end

    test "displays professional styling elements", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/guides")

      # Check for luxury/professional CSS classes
      assert html =~ "gradient-bg-luxury"
      assert html =~ "gradient-header-luxury"
      assert html =~ "page-title-luxury"
      assert html =~ "page-subtitle-luxury"
      assert html =~ "card-luxury"
      assert html =~ "btn-luxury"
      assert html =~ "btn-secondary-luxury"
    end

    test "check-in section includes all key information", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/guides")

      # Switch to check-in section
      index_live
      |> element("button[phx-value-section='check-in']")
      |> render_click()

      html = render(index_live)

      # Check step-by-step content
      assert html =~ "Navigate to Check-In"
      assert html =~ "Select Property (if applicable)"
      assert html =~ "Enter Guest Information"
      assert html =~ "Select Destination Room"
      assert html =~ "Add Visit Details"
      assert html =~ "Complete Check-In"

      # Check features content
      assert html =~ "Smart Room Search"
      assert html =~ "Form Validation"
      assert html =~ "Mobile Optimized"
      assert html =~ "Key Fob Integration"

      # Check pro tips
      assert html =~ "Speed Up the Process"
      assert html =~ "Ensure Accuracy"
    end

    test "check-out section includes comprehensive information", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/guides")

      # Switch to check-out section
      index_live
      |> element("button[phx-value-section='check-out']")
      |> render_click()

      html = render(index_live)

      # Check process steps
      assert html =~ "Access Check-Out Page"
      assert html =~ "Review Active Visitors"
      assert html =~ "Select Visitor to Check Out"
      assert html =~ "Confirm Check-Out"

      # Check features
      assert html =~ "Real-Time Status"
      assert html =~ "Visitor Information Cards"
      assert html =~ "Instant Processing"
      assert html =~ "Visit History"

      # Check special scenarios
      assert html =~ "No Active Visitors"
      assert html =~ "Room Information Handling"

      # Check best practices
      assert html =~ "Timely Processing"
      assert html =~ "Verify Identity"
      assert html =~ "Monitor Patterns"
    end

    test "features section displays all platform capabilities", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/guides")

      # Switch to features section
      index_live
      |> element("button[phx-value-section='features']")
      |> render_click()

      html = render(index_live)

      # Check core features - HTML entity encoding changes & to &amp;
      assert html =~ "Visitor Management"
      assert html =~ "Analytics &amp; Reporting"
      assert html =~ "Security &amp; Access Control"
      assert html =~ "Multi-language Support"
      assert html =~ "Mobile Responsive"

      # Check advanced capabilities
      assert html =~ "Real-time Updates"
      assert html =~ "Data Management"
      assert html =~ "Live dashboard updates via WebSocket"
      assert html =~ "Comprehensive visitor history tracking"

      # Check integration capabilities
      assert html =~ "API Ready"
      assert html =~ "Cloud Native"
      assert html =~ "Security First"
    end

    test "admin section includes all administrative information", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/guides")

      # Switch to admin section
      index_live
      |> element("button[phx-value-section='admin']")
      |> render_click()

      html = render(index_live)

      # Check capabilities
      assert html =~ "Global System Access"
      assert html =~ "User Management"
      assert html =~ "System Configuration"
      assert html =~ "Advanced Reporting"

      # Check responsibilities
      assert html =~ "User Account Management"
      assert html =~ "System Monitoring"

      # Check permission levels
      assert html =~ "Administrator"
      assert html =~ "Property Manager"
      assert html =~ "Guest/Public"
      assert html =~ "Full system access with all permissions"
      assert html =~ "Manage assigned properties and guests"
      assert html =~ "Limited access for visitor self-service"

      # Check common tasks
      assert html =~ "Setting Up New Properties"
      assert html =~ "Managing User Accounts"

      # Check troubleshooting
      assert html =~ "User Access Issues"
      assert html =~ "Data Synchronization"
    end

    test "page is accessible without authentication", %{conn: conn} do
      # Test that the page works without being logged in
      {:ok, _index_live, html} = live(conn, ~p"/guides")

      # Should render successfully
      assert html =~ "TrackGuests User Guides"
      assert html =~ "Overview"
    end

    test "page works with authenticated user", %{conn: conn} do
      # Create a user and log them in
      user = user_fixture()
      conn = log_in_user(conn, user)

      {:ok, _index_live, html} = live(conn, ~p"/guides")

      # Should render successfully with authentication
      assert html =~ "TrackGuests User Guides"
      assert html =~ "Overview"
    end

    test "page works with admin user", %{conn: conn} do
      # Create an admin user and log them in
      user = user_fixture() |> make_admin()
      conn = log_in_user(conn, user)

      {:ok, _index_live, html} = live(conn, ~p"/guides")

      # Should render successfully with admin authentication
      assert html =~ "TrackGuests User Guides"
      assert html =~ "Overview"
    end

    test "all sections render without errors", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/guides")

      # Test each section renders without error
      sections = ["overview", "check-in", "check-out", "features", "admin"]

      for section <- sections do
        index_live
        |> element("button[phx-value-section='#{section}']")
        |> render_click()

        # Should not raise any errors and should contain content
        html = render(index_live)
        assert String.length(html) > 1000  # Ensure substantial content
        # Just check no fatal errors occurred (the page rendered)
        assert html =~ "TrackGuests User Guides"
      end
    end

    test "responsive design elements are present", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/guides")

      # Check for responsive CSS classes that are actually in the component
      assert html =~ "max-w-7xl"
      assert html =~ "px-4"
      assert html =~ "sm:px-6"
      assert html =~ "lg:px-8"
      assert html =~ "grid-cols-1"
      assert html =~ "md:grid-cols"
    end

    test "accessibility features are included", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/guides")

      # Check for basic accessibility elements
      assert html =~ "viewbox"  # SVG elements have viewbox (lowercase in HTML)
      assert html =~ "<button"  # Interactive elements are present
      assert html =~ "phx-click"  # Interactive functionality
    end

    test "all external links and navigation work", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/guides")

      # Check that important navigation links are present
      assert html =~ "Return to Dashboard"
      assert html =~ "Start Guest Check-In"
      assert html =~ "href=\"/\""
      assert html =~ "href=\"/visitor/check-in\""
    end

    test "includes back to home link with TG icon", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/guides")

      # Check for back to home link
      assert html =~ "Back to Home"
      assert html =~ "href=\"/\""
      # Check for TG icon
      assert html =~ ">TG<"
      # Check for proper styling classes
      assert html =~ "gradient-header-luxury"
    end

    test "section switching maintains page state", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/guides")

      # Switch to check-in section
      index_live
      |> element("button[phx-value-section='check-in']")
      |> render_click()

      # Verify we're in check-in section
      html = render(index_live)
      assert html =~ "Guest Check-In Process"

      # Switch to admin section
      index_live
      |> element("button[phx-value-section='admin']")
      |> render_click()

      # Verify we're now in admin section
      html = render(index_live)
      assert html =~ "Administrator Guide"
      refute html =~ "Guest Check-In Process"

      # Switch back to overview
      index_live
      |> element("button[phx-value-section='overview']")
      |> render_click()

      # Verify we're back in overview
      html = render(index_live)
      assert html =~ "Welcome to TrackGuests"
      refute html =~ "Administrator Guide"
    end
  end

  # Helper functions for testing
  defp make_admin(user) do
    {:ok, admin_user} = Trackguests3.Accounts.update_user_admin(user, %{admin: true})
    admin_user
  end
end