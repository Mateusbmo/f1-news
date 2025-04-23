defmodule F1NewsWeb.UserAuth do
  use F1NewsWeb, :verified_routes

  import Phoenix.Component, only: [assign: 3]
  import Phoenix.LiveView, only: [redirect: 2, put_flash: 3]
  import Plug.Conn, only: [get_session: 2, put_session: 3, delete_session: 2]

  alias F1News.Accounts
  require Logger

  def on_mount(:ensure_authenticated, _params, session, socket) do
    case get_user_from_session(session) do
      nil ->
        socket =
          socket
          |> put_flash(:error, "You must log in to access this page.")
          |> redirect(to: ~p"/users/log_in")

        {:halt, socket}

      user ->
        socket = assign(socket, :current_user, user)
        {:cont, socket}
    end
  end

  def on_mount(:default, _params, session, socket) do
    socket =
      case get_user_from_session(session) do
        nil -> socket
        user -> assign(socket, :current_user, user)
      end

    {:cont, socket}
  end

  defp get_user_from_session(session) do
    with token when is_binary(token) <- session["user_token"],
         user = %Accounts.User{} <- Accounts.get_user_by_session_token(token) do
      user
    else
      _ -> nil
    end
  end

  def fetch_current_user(conn, _opts) do
    {user_token, conn} = ensure_user_token(conn)
    Logger.debug("fetch_current_user: user_token=#{inspect(user_token)}")
    user = user_token && Accounts.get_user_by_session_token(user_token)
    Logger.debug("fetch_current_user: user=#{inspect(user)}")
    Plug.Conn.assign(conn, :current_user, user)
  end

  defp ensure_user_token(conn) do
    if token = get_session(conn, :user_token) do
      {token, conn}
    else
      {nil, conn}
    end
  end

  def log_in_user(conn_or_socket, user, params \\ %{}) do
    token = Accounts.generate_user_session_token(user)
    user_return_to = params["user_return_to"] || ~p"/"
    Logger.debug("log_in_user: new_token=#{inspect(token)} user_id=#{user.id}")

    case conn_or_socket do
      %Plug.Conn{} = conn ->
        conn
        |> delete_session(:user_token)
        |> delete_session(:live_socket_id)
        |> put_session(:user_token, token)
        |> put_session(:live_socket_id, "users_sessions:#{Base.url_encode64(token)}")
        |> Phoenix.Controller.redirect(to: user_return_to)

      %Phoenix.LiveView.Socket{} = socket ->
        socket
        |> assign(:user_token, token)
        |> assign(:current_user, user)
        |> redirect(to: user_return_to)
    end
  end

  def log_out_user(conn) do
    user_token = get_session(conn, :user_token)
    user_token && Accounts.delete_user_session_token(user_token)

    if live_socket_id = get_session(conn, :live_socket_id) do
      F1NewsWeb.Endpoint.broadcast(live_socket_id, "disconnect", %{})
    end

    conn
    |> put_session(:user_token, nil)
    |> put_session(:live_socket_id, nil)
    |> Phoenix.Controller.redirect(to: ~p"/")
  end

  def require_authenticated_user(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      Logger.debug("require_authenticated_user: no current_user, redirecting")
      conn
      |> Phoenix.Controller.put_flash(:error, "You must log in to access this page.")
      |> Phoenix.Controller.redirect(to: ~p"/users/log_in")
      |> Plug.Conn.halt()
    end
  end

  def redirect_if_user_is_authenticated(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
      |> Phoenix.Controller.redirect(to: ~p"/")
      |> Plug.Conn.halt()
    else
      conn
    end
  end

  def clear_session(conn) do
    Logger.debug("clear_session: clearing session")
    conn
    |> delete_session(:user_token)
    |> delete_session(:live_socket_id)
    |> delete_session(:_csrf_token)
    |> Phoenix.Controller.redirect(to: ~p"/users/log_in")
  end
end
