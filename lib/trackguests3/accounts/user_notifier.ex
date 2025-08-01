defmodule Trackguests3.Accounts.UserNotifier do
  import Swoosh.Email

  alias Trackguests3.Mailer
  alias Trackguests3.Accounts.User

  # Delivers the email using the application mailer.
  defp deliver(recipient, subject, text_body, html_body) do
    email =
      new()
      |> to(recipient)
      |> from({"Trackguests3", "info@alzheimer-memory.com"})
      |> subject(subject)
      |> html_body(html_body)
      |> text_body(text_body)

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end



  @doc """
  Deliver instructions to log in with a magic link.
  """
  def deliver_login_instructions(user, url) do
    case user do
      %User{confirmed_at: nil} -> deliver_confirmation_instructions(user, url)
      _ -> deliver_magic_link_instructions(user, url)
    end
  end

  def build_html_email_content(email, url, introduction_text, closing_text) do
    assigns = %{
      email: email,  url: url,    introduction_text: introduction_text,
      closing_text: closing_text, appurl:  Trackguests3Web.Endpoint.url() }
    template_string="""
    <!DOCTYPE html>
      <html lang="en">
      <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>Property Dashboard</title>
      </head>
      <body style="margin: 0; padding: 0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif; background-color: #f8fafc; color: #334155; line-height: 1.6;">
          <div style="max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 8px; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); overflow: hidden;">
              <!-- Header -->
              <div style="background: linear-gradient(135deg, #1e293b 0%, #334155 100%); color: white; padding: 2rem; text-align: center;">
                  <h1 style="margin: 0 0 0.5rem 0; font-size: 1.875rem; font-weight: 700; letter-spacing: -0.025em;">Track Guest System</h1>
                  <p style="margin: 0; opacity: 0.9; font-size: 0.875rem;">Manage visitors to your property effectively</p>
              </div>

              <!-- Main Content -->
              <div style="padding: 2rem;">
                  <!-- Introduction Text (Elixir Variable) -->
                  <div style="font-size: 1rem; margin-bottom: 1.5rem; color: #475569;">
                      <%= @introduction_text %>
                  </div>

                  <!-- Divider -->
                  <div style="height: 1px; background: linear-gradient(to right, transparent, #e2e8f0, transparent); margin: 1.5rem 0;"></div>

                  <!-- Call to Action -->
                  <div style="text-align: center; margin: 2rem 0;">
                      <a href="<%= @url %>" style="display: inline-block; background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%); color: white; text-decoration: none; padding: 0.875rem 2rem; border-radius: 6px; font-weight: 600; font-size: 0.875rem; transition: transform 0.2s ease;">
                          Link
                      </a>
                  </div>

                  <!-- Divider -->
                  <div style="height: 1px; background: linear-gradient(to right, transparent, #e2e8f0, transparent); margin: 1.5rem 0;"></div>

                  <!-- Closing Text (Elixir Variable) -->
                  <div style="color: #475569; font-size: 1rem;">
                      <%= @closing_text %>
                  </div>
              </div>

              <!-- Footer -->
              <div style="background-color: #f8fafc; padding: 1.5rem 2rem; border-top: 1px solid #e2e8f0; text-align: center; font-size: 0.75rem; color: #64748b;">
                  <p style="margin: 0 0 0.5rem 0;">Easily track your visitors</p>
                  <p style="margin: 0;">This email was sent to <%= @email %> from <%= @appurl %></p>
              </div>
          </div>
      </body>
      </html>
    """
    rendered_html = EEx.eval_string(template_string, assigns: assigns)
    rendered_html
  end

  defp deliver_magic_link_instructions(user, url) do
    content = build_html_email_content(user.email, url, "You can log in by visiting the URL below:",
                "If you didn't request this, please ignore this email.")
      text_content="test"
    deliver(user.email, "Log in instructions", text_content, content)
  end

  defp deliver_confirmation_instructions(user, url) do
    content = build_html_email_content(user.email, url, " You can confirm your account by visiting the URL below:",
                "If you didn't request this, please ignore this email.")
      text_content="test"
    deliver(user.email, "Confirmation instructions", text_content, content)
  end

  @doc """
  Deliver instructions to update a user email.
  """
  def deliver_update_email_instructions(user, url) do
    content = build_html_email_content(user.email, url, " You can change your email by visiting the URL below:",
                "If you didn't request this change, please ignore this email.")
     text_content="test"
    deliver(user.email, "Update email instructions", text_content, content)
  end

  # ORIGINAL
  def old_deliver_update_email_instructions(user, url) do
    deliver(user.email, "Update email instructions", """

    ==============================

    Hi #{user.email},

    You can change your email by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    ""","html")
  end
  # END ORIGINAL

end
