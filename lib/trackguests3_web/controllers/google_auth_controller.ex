defmodule Trackguests3Web.GoogleAuthController do
  use Trackguests3Web, :controller

  alias Trackguests3.Accounts
  alias Trackguests3Web.UserAuth
  require Logger
  @doc """
  Redirects to Google OAuth authorization URL
  """
  def request(conn, _params) do
    state = generate_state()

    # Store state in session to verify on callback
    conn = put_session(conn, :oauth_state, state)

    # Generate Google OAuth URL
    oauth_url = ElixirAuthGoogle.generate_oauth_url(conn, state)

    redirect(conn, external: oauth_url)
  end

  @doc """
  Handles Google OAuth callback and creates/logs in user
  """
  def callback(conn, %{"code" => code, "state" => state}) do
    # Verify state to prevent CSRF attacks
    stored_state = get_session(conn, :oauth_state)

    if state != stored_state do
      conn
      |> put_flash(:error, "Invalid OAuth state. Please try again.")
      |> redirect(to: ~p"/users/log-in")
    else
      case ElixirAuthGoogle.get_token(code, conn) do
        {:ok, token} ->
          handle_google_user(conn, token)

        {:error, reason} ->
          conn
          |> put_flash(:error, "Failed to authenticate with Google: #{inspect(reason)}")
          |> redirect(to: ~p"/users/log-in")
      end
    end
  end

  def callback(conn, %{"error" => error}) do
    conn
    |> put_flash(:error, "Google authentication cancelled: #{error}")
    |> redirect(to: ~p"/users/log-in")
  end

  def callback(conn, _params) do
    conn
    |> put_flash(:error, "Invalid Google OAuth callback")
    |> redirect(to: ~p"/users/log-in")
  end

  defp handle_google_user(conn, token) do
    case ElixirAuthGoogle.get_user_profile(token.access_token) do
      {:ok, profile} ->
        case find_or_create_user(profile) do
          {:ok, user} ->
            conn
            |> delete_session(:oauth_state)
            |> put_flash(:info, "Successfully logged in with Google")
            |> UserAuth.log_in_user(user)

          {:error, reason} ->
            conn
            |> put_flash(:error, "Failed to create user account: #{inspect(reason)}")
            |> redirect(to: ~p"/users/log-in")
        end

      {:error, reason} ->
        conn
        |> put_flash(:error, "Failed to get user profile from Google: #{inspect(reason)}")
        |> redirect(to: ~p"/users/log-in")
    end
  end

  defp find_or_create_user(profile) do
    email = profile[:email]
    Logger.info("SCOTT: email: #{email} Google profile: #{inspect(profile)}")
    case Accounts.get_user_by_email(email) do
      nil ->
        # Create new user
        user_attrs = %{
          email: email,
          confirmed_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second),
          google_id: profile[:id],
          first_name: profile[:given_name],
          last_name: profile[:family_name],
          picture_url: profile[:picture]
        }

        Accounts.register_google_user(user_attrs)

      user ->
        # Update existing user with Google info if needed
        update_attrs = %{
          google_id: profile["id"],
          picture_url: profile["picture"]
        }

        case Accounts.update_user_google_info(user, update_attrs) do
          {:ok, updated_user} -> {:ok, updated_user}
          {:error, _changeset} -> {:ok, user}  # Fallback to original user if update fails
        end
    end
  end

  defp generate_state do
    :crypto.strong_rand_bytes(32) |> Base.url_encode64(padding: false)
  end
end
