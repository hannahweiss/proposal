#based off of https://github.com/dwyl/elixir-auth-github/blob/master/lib/elixir_auth_github.ex

defmodule GithubAccess do

  @github_url "https://github.com/login/oauth/"
  @github_auth_url @github_url <> "access_token?"


  def github_auth(code) do
    query =
      URI.encode_query(%{
        "client_id" => System.get_env("GITHUB_CLIENT_ID"),
        "client_secret" => System.get_env("GITHUB_CLIENT_SECRET"),
        "code" => code
      })

    HTTPoison.post!(@github_auth_url <> query, "")
    |> Map.get(:body)
    |> URI.decode_query()
    |> check_authenticated
  end

  defp check_authenticated(%{"access_token" => access_token}) do
    access_token
    |> get_user_details
  end

  defp check_authenticated(error), do: {:error, error}

  defp get_user_details(access_token) do
    HTTPoison.get!("https://api.github.com/user", [
      #  https://developer.github.com/v3/#user-agent-required
      {"User-Agent", "ElixirAuthGithub"},
      {"Authorization", "token #{access_token}"}
    ])
    |> Map.get(:body)
    |> Poison.decode!()
    |> set_user_details(access_token)
  end

  defp get_primary_email(access_token) do
    HTTPoison.get!("https://api.github.com/user/emails", [
      #  https://developer.github.com/v3/#user-agent-required
      {"User-Agent", "ElixirAuthGithub"},
      {"Authorization", "token #{access_token}"}
    ])
    |> Map.get(:body)
    |> Poison.decode!()
    |> Enum.find_value(&if &1["primary"], do: &1["email"])
  end

  def search_users(term) do
    HTTPoison.get!("https://api.github.com/search/users?q=#{term}", [
      #  https://developer.github.com/v3/#user-agent-required
    ])
    |> Map.get(:body)
    |> Poison.decode!()
  end

  defp set_user_email(user, nil, access_token) do
    email = get_primary_email(access_token)
    Map.put(user, "email", email)
  end

  defp set_user_email(user, email, _access_token), do: Map.put(user, "email", email)

  defp set_user_details(%{"login" => _name, "email" => email} = user, access_token) do
    user =
      user
      |> Map.put("access_token", access_token)
      |> set_user_email(email, access_token)

    # transform map with keys as strings into keys as atoms!
    # https://stackoverflow.com/questions/31990134
    atom_key_map = for {key, val} <- user, into: %{}, do: {String.to_atom(key), val}
    {:ok, atom_key_map}
  end

  defp set_user_details(error, _token), do: {:error, error}
end
