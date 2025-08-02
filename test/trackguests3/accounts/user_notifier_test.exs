defmodule Trackguests3.Accounts.UserNotifierTest do
  use ExUnit.Case, async: true

  alias Trackguests3.Accounts.UserNotifier
  alias Trackguests3.Accounts.User

  describe "HTML email content generation" do
    test "build_html_email_content/4 generates valid HTML with all variables" do
      email = "test@example.com"
      url = "https://example.com/login"
      introduction_text = "You can log in by visiting the URL below:"
      closing_text = "If you didn't request this, please ignore this email."

      html_content = UserNotifier.build_html_email_content(email, url, introduction_text, closing_text)

      # Verify it's valid HTML structure
      assert String.contains?(html_content, "<!DOCTYPE html>")
      assert String.contains?(html_content, "<html lang=\"en\">")
      assert String.contains?(html_content, "</html>")

      # Verify all variables are properly interpolated
      assert String.contains?(html_content, email)
      assert String.contains?(html_content, url)
      assert String.contains?(html_content, introduction_text)
      assert String.contains?(html_content, closing_text)

      # Verify key HTML elements are present
      assert String.contains?(html_content, "Track Guest System")
      assert String.contains?(html_content, "Manage visitors to your property effectively")
      assert String.contains?(html_content, "Easily track your visitors")

      # Verify the link is properly formatted
      assert String.contains?(html_content, "href=\"#{url}\"")
    end

    test "build_html_email_content/4 handles special characters in variables" do
      email = "user+test@example.com"
      url = "https://example.com/login?token=abc123&redirect=/dashboard"
      introduction_text = "Welcome! Here's your <special> link:"
      closing_text = "Questions? Contact us at support@example.com"

      html_content = UserNotifier.build_html_email_content(email, url, introduction_text, closing_text)

      # Verify special characters are properly handled
      assert String.contains?(html_content, email)
      assert String.contains?(html_content, url)
      assert String.contains?(html_content, introduction_text)
      assert String.contains?(html_content, closing_text)
    end

    test "build_html_email_content/4 handles empty strings" do
      email = ""
      url = ""
      introduction_text = ""
      closing_text = ""

      html_content = UserNotifier.build_html_email_content(email, url, introduction_text, closing_text)

      # Should still generate valid HTML structure
      assert String.contains?(html_content, "<!DOCTYPE html>")
      assert String.contains?(html_content, "Track Guest System")
    end
  end

  describe "email delivery functions" do
    setup do
      user = %User{
        id: 1,
        email: "test@example.com",
        confirmed_at: nil
      }
      url = "https://example.com/confirm/token123"

      {:ok, user: user, url: url}
    end

    test "deliver_login_instructions/2 with unconfirmed user calls confirmation", %{user: user, url: url} do
      # For unconfirmed user, should call deliver_confirmation_instructions
      result = UserNotifier.deliver_login_instructions(user, url)

      assert {:ok, email} = result
      assert email.to == [{"", user.email}]
      assert email.subject == "Confirmation instructions"
      assert email.html_body != nil
      assert String.contains?(email.html_body, "You can confirm your account by visiting the URL below:")
      assert String.contains?(email.html_body, url)
    end

    test "deliver_login_instructions/2 with confirmed user calls magic link", %{user: user, url: url} do
      confirmed_user = %{user | confirmed_at: ~N[2023-01-01 12:00:00]}

      result = UserNotifier.deliver_login_instructions(confirmed_user, url)

      assert {:ok, email} = result
      assert email.to == [{"", confirmed_user.email}]
      assert email.subject == "Log in instructions"
      assert email.html_body != nil
      assert String.contains?(email.html_body, "You can log in by visiting the URL below:")
      assert String.contains?(email.html_body, url)
    end

    test "deliver_update_email_instructions/2 generates proper email", %{user: user, url: url} do
      result = UserNotifier.deliver_update_email_instructions(user, url)

      assert {:ok, email} = result
      assert email.to == [{"", user.email}]
      assert email.subject == "Update email instructions"
      assert email.html_body != nil
      assert String.contains?(email.html_body, "You can change your email by visiting the URL below:")
      assert String.contains?(email.html_body, url)
    end

    test "all email functions generate HTML emails with proper structure", %{user: user, url: url} do
      # Test confirmation email
      {:ok, confirmation_email} = UserNotifier.deliver_login_instructions(user, url)

      # Test magic link email
      confirmed_user = %{user | confirmed_at: ~N[2023-01-01 12:00:00]}
      {:ok, magic_link_email} = UserNotifier.deliver_login_instructions(confirmed_user, url)

      # Test update email
      {:ok, update_email} = UserNotifier.deliver_update_email_instructions(user, url)

      emails = [confirmation_email, magic_link_email, update_email]

      for email <- emails do
        # Verify basic email structure
        assert email.from == {"Trackguests3", "info@alzheimer-memory.com"}
        assert email.to == [{"", user.email}]
        # "visiting the URL below"
        assert String.contains?(email.text_body, "visiting the URL below")
  # Current placeholder

        # Verify HTML content
        assert email.html_body != nil
        assert String.contains?(email.html_body, "<!DOCTYPE html>")
        assert String.contains?(email.html_body, "Track Guest System")
        assert String.contains?(email.html_body, user.email)
        assert String.contains?(email.html_body, url)
      end
    end

    test "emails have responsive design elements", %{user: user, url: url} do
      {:ok, email} = UserNotifier.deliver_update_email_instructions(user, url)

      html = email.html_body

      # Check for responsive design elements
      assert String.contains?(html, "meta name=\"viewport\"")
      assert String.contains?(html, "max-width: 600px")
      assert String.contains?(html, "margin: 0 auto")

      # Check for CSS styling
      assert String.contains?(html, "background: linear-gradient")
      assert String.contains?(html, "font-family:")
      assert String.contains?(html, "border-radius:")
    end

    test "emails contain proper call-to-action button", %{user: user, url: url} do
      {:ok, email} = UserNotifier.deliver_update_email_instructions(user, url)

      html = email.html_body

      # Check for button styling and link
      assert String.contains?(html, "href=\"#{url}\"")
      assert String.contains?(html, "display: inline-block")
      assert String.contains?(html, "background: linear-gradient")
      assert String.contains?(html, "text-decoration: none")
    end
  end
end
