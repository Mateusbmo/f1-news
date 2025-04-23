defmodule F1NewsWeb.Router do
  use F1NewsWeb, :router

  import F1NewsWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {F1NewsWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :auth_required do
    plug :require_authenticated_user
  end

  pipeline :redirect_if_authenticated do
    plug :redirect_if_user_is_authenticated
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", F1NewsWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/about", PageController, :about
    get "/contact", PageController, :contact
    get "/teams-drivers", TeamsDriversController, :index
    get "/teams/:id", TeamsDriversController, :show_team
    get "/drivers/:id", TeamsDriversController, :show_driver
    get "/clear_session", UserSessionController, :clear
    live "/standings", StandingsLive, :index
    live "/schedule", ScheduleLive, :index
    live "/results", ResultsLive, :index
  end

  # Rotas para usuários autenticados
  scope "/", F1NewsWeb do
    pipe_through [:browser, :auth_required]

    resources "/news", NewsController
    live "/users/settings", UserSettingsLive, :index
    live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
  end

  # Rotas para usuários não autenticados
  scope "/", F1NewsWeb do
    pipe_through [:browser, :redirect_if_authenticated]

    live "/users/register", UserRegistrationLive, :new
    live "/users/log_in", UserLoginLive, :new
    post "/users/log_in", UserSessionController, :create
    live "/users/reset_password", UserForgotPasswordLive, :new
    live "/users/reset_password/:token", UserResetPasswordLive, :edit
  end

  scope "/", F1NewsWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live "/users/confirm/:token", UserConfirmationLive, :edit
    live "/users/confirm", UserConfirmationInstructionsLive, :new
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:f1_news, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: F1NewsWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
