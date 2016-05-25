defmodule Constable.Plugs.RequireLoginTest do
  use Constable.ConnCase, async: true

  test "user is redirected when current_user is not set" do
    conn = conn() |> with_session |> run_plug

    assert redirected_to(conn) == "/session/new"
  end

  test "the original request path is stored on the session" do
    conn = conn(:get, "/foo") |> with_session |> run_plug

    assert get_session(conn, :original_request_path) == "/foo"
  end

  test "user passes through when current_user is set" do
    conn = conn() |> authenticate |> run_plug

    assert not_redirected?(conn)
  end

  defp not_redirected?(conn) do
    conn.status != 302
  end

  defp authenticate(conn) do
    conn |> assign(:current_user, %Constable.User{})
  end

  defp run_plug(conn) do
    conn |> Constable.Plugs.RequireLogin.call(%{})
  end
end
