defmodule SmartlangWeb.Router do
  use SmartlangWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SmartlangWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Smartlang.Auth.Pipeline
    plug Smartlang.Plugs.AuthorizeUser
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/auth", SmartlangWeb do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
    post "/logout", AuthController, :sign_out
  end

  scope "/translator", SmartlangWeb do
    pipe_through [:browser, :auth, :ensure_auth]

    get "/supported_languages", TranslatorController, :get_supported_languages
    post "/translate", TranslatorController, :translate_text
  end

  scope "/", SmartlangWeb do
    pipe_through [:browser, :auth, :ensure_auth]
    get "/userinfo", UserController, :user_info
    post "/summarizer/summarize", SummaryController, :summarize
  end

  # Other scopes may use custom stacks.
  # scope "/api", SmartlangWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:smartlang, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: SmartlangWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  scope "/", SmartlangWeb do
    pipe_through :browser
    get "/*path", PageController, :index
  end
end
