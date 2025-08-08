defmodule Trackguests3Web.UserLive.Login do
  use Trackguests3Web, :live_view

  alias Trackguests3.Accounts

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="mx-auto max-w-sm space-y-4">
        <.header class="text-center">
          <p>Log in</p>
          <:subtitle>
            <%= if @current_scope do %>
              You need to reauthenticate to perform sensitive actions on your account.
            <% else %>
              Don't have an account? <.link
                navigate={~p"/users/register"}
                class="font-semibold text-brand hover:underline"
                phx-no-format
              >Sign up</.link> for an account now.
            <% end %>
          </:subtitle>
        </.header>

        <div :if={local_mail_adapter?()} class="alert alert-info">
          <.icon name="hero-information-circle" class="size-6 shrink-0" />
          <div>
            <p>You are running the local mail adapter.</p>
            <p>
              To see sent emails, visit <.link href="/dev/mailbox" class="underline">the mailbox page</.link>.
            </p>
          </div>
        </div>

        <div class="card-luxury">
          <.form
            :let={f}
            for={@form}
            id="login_form_magic"
            action={~p"/users/log-in"}
            phx-submit="submit_magic"
          >
            <.input
              readonly={!!@current_scope}
              field={f[:email]}
              type="email"
              label="Email"
              autocomplete="username"
              required
              phx-mounted={JS.focus()}
            />
            <.button class="w-full" variant="primary">
              Log in with email <span aria-hidden="true">→</span>
            </.button>
          </.form>
        </div>

        <div class="divider">or</div>

        <div class="card-luxury">
          <.form
            :let={f}
            for={@form}
            id="login_form_password"
            action={~p"/users/log-in"}
            phx-submit="submit_password"
            phx-trigger-action={@trigger_submit}
          >
            <.input
              readonly={!!@current_scope}
              field={f[:email]}
              type="email"
              label="Email"
              autocomplete="username"
              required
            />
            <div class="relative">
              <.input
                field={@form[:password]}
                type="password"
                label="Password"
                autocomplete="current-password"
                id="password-input"
              />
              <button
                type="button"
                class="absolute right-3 top-9 text-gray-500 hover:text-gray-700 focus:outline-none"
                onclick="togglePasswordVisibility()"
                aria-label="Toggle password visibility"
              >
                <svg id="eye-open" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path>
                </svg>
                <svg id="eye-closed" class="w-5 h-5 hidden" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.878 9.878L12 12m-2.122-2.122L7.757 7.757M9.878 9.878l4.242 4.242m0 0L12 12m2.121-2.121L16.243 7.757m-4.242 4.242L12 12m-2.122-2.122L9.878 9.878"></path>
                </svg>
              </button>
            </div>
            <script>
              function togglePasswordVisibility() {
                const passwordInput = document.getElementById('password-input');
                const eyeOpen = document.getElementById('eye-open');
                const eyeClosed = document.getElementById('eye-closed');
                
                if (passwordInput.type === 'password') {
                  passwordInput.type = 'text';
                  eyeOpen.classList.add('hidden');
                  eyeClosed.classList.remove('hidden');
                } else {
                  passwordInput.type = 'password';
                  eyeOpen.classList.remove('hidden');
                  eyeClosed.classList.add('hidden');
                }
              }
            </script>
            <.input
              :if={!@current_scope}
              field={f[:remember_me]}
              type="checkbox"
              label="Keep me logged in"
            />
            <.button class="w-full" variant="primary">
              Log in <span aria-hidden="true">→</span>
            </.button>
          </.form>
        </div>

        <div class="divider">or</div>

        <!-- Google Login Button -->
        <div class="card-luxury">
          <.link
            href="/auth/google"
            class="btn-luxury w-full flex items-center justify-center space-x-3 py-3 px-4 rounded-xl border-2 border-gray-300 hover:border-gray-400 focus:ring-2 focus:ring-gray-300 focus:ring-offset-2 transition-all duration-300"
          >
            <svg class="w-5 h-5" viewBox="0 0 24 24">
              <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
              <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
              <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/>
              <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
            </svg>
            <span class="font-medium text-gray-700">Continue with Google</span>
          </.link>
        </div>
      </div>
    </Layouts.app>
    """
  end

  def mount(_params, _session, socket) do
    email =
      Phoenix.Flash.get(socket.assigns.flash, :email) ||
        get_in(socket.assigns, [:current_scope, Access.key(:user), Access.key(:email)])

    form = to_form(%{"email" => email}, as: "user")

    {:ok, assign(socket, form: form, trigger_submit: false)}
  end

  def handle_event("submit_password", _params, socket) do
    {:noreply, assign(socket, :trigger_submit, true)}
  end

  def handle_event("submit_magic", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_login_instructions(
        user,
        &url(~p"/users/log-in/#{&1}")
      )
    end

    info =
      "If your email is in our system, you will receive instructions for logging in shortly."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> push_navigate(to: ~p"/users/log-in")}
  end

  defp local_mail_adapter? do
    Application.get_env(:trackguests3, Trackguests3.Mailer)[:adapter] == Swoosh.Adapters.Local
  end
end
