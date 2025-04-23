defmodule F1NewsWeb.UserLoginLive do
  use F1NewsWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Log in to account
        <:subtitle>
          Don't have an account?
          <.link navigate={~p"/users/register"} class="font-semibold text-brand hover:underline">
            Sign up
          </.link>
          for an account now.
        </:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="login_form"
        action={~p"/users/log_in"}
        phx-update="ignore"
      >
        <.input field={@form[:email]} type="email" label="Email" required />
        <.input field={@form[:password]} type="password" label="Password" required />

        <:actions>
          <.input field={@form[:remember_me]} type="checkbox" label="Keep me logged in" />
          <.link href={~p"/users/reset_password"} class="text-sm font-semibold">
            Forgot your password?
          </.link>
        </:actions>
        <:actions>
          <.button phx-disable-with="Logging in..." class="w-full">
            Log in <span aria-hidden="true">→</span>
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email, "password" => nil, "remember_me" => "false"}, as: "user")
    socket = assign(socket, form: form, current_user: socket.assigns[:current_user] || nil)
    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    form = to_form(user_params, as: "user")
    {:noreply, assign(socket, form: form)}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case F1News.Accounts.get_user_by_email_and_password(user_params["email"], user_params["password"]) do
      nil ->
        form = to_form(user_params, as: "user")
        {:noreply,
         socket
         |> put_flash(:error, "Invalid email or password")
         |> assign(form: form)}

      user ->
        socket =
          socket
          |> put_flash(:info, "Welcome back!")
          |> F1NewsWeb.UserAuth.log_in_user(user, user_params)

        {:noreply, socket}
    end
  end
end
