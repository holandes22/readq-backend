defmodule ReadQ.Policies do
  use PolicyWonk.Enforce
  @behaviour PolicyWonk.Policy

  @err_handler ReadQ.ErrorHandlers

  def policy( assigns, :current_user ) do
    case assigns[:current_user] do
      _user = %ReadQ.User{} -> :ok
      _ ->    :current_user
    end
  end

  def policy_error(conn, error_data) when is_bitstring(error_data), do:
    @err_handler.unauthorized(conn, error_data)
  def policy_error(conn, _error_data), do: policy_error(conn, "Unauthorized")

end
