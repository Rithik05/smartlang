defmodule Smartlang.UserFromAuth do
  require Logger
  require Jason
  alias Ueberauth.Auth
  alias Smartlang.Service.User

  def oauth_login(%Auth{info: _info} = auth) do
    auth
    |> basic_info()
    |> User.find_or_create()
  end

  defp basic_info(%Auth{uid: uid, info: info}) do
    fullname = name_from_auth(info)

    %{
      uid: uid,
      first_name: fullname.first_name,
      last_name: fullname.last_name,
      email: info.email
    }
  end

  defp name_from_auth(info) do
    name =
      [info.first_name, info.last_name]
      |> Enum.filter(&(&1 != nil and &1 != ""))

    if length(name) != 2 do
      name = String.split(info.name)
      %{first_name: Enum.at(name, 0), last_name: Enum.at(name, 1)}
    else
      %{first_name: info.first_name, last_name: info.last_name}
    end
  end
end
