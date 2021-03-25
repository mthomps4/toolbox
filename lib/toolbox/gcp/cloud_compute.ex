defmodule Toolbox.Gcp.CloudEngine do
  alias Toolbox.Gcp

  def get_status(%{instance_id: instance_id, project_id: project_id, zone: zone}) do
    url =
      "https://compute.googleapis.com/compute/v1/projects/#{project_id}/zones/#{zone}/instances/#{
        instance_id
      }"

    with {:ok, %{token: token}} <- Gcp.authenticate() do
      headers = [{"Authorization", "Bearer #{token}"}]

      HTTPoison.get(url, headers)
      |> parse_response()
    else
      e -> {:error, e}
    end
  end

  def start(%{instance_id: instance_id, project_id: project_id, zone: zone}) do
    url =
      "https://compute.googleapis.com/compute/v1/projects/#{project_id}/zones/#{zone}/instances/#{
        instance_id
      }/start"

    with {:ok, %{token: token}} <- Gcp.authenticate() do
      headers = [{"Authorization", "Bearer #{token}"}]

      HTTPoison.post(url, "", headers)
      |> parse_response()
    else
      e -> {:error, e}
    end
  end

  def stop(%{instance_id: instance_id, project_id: project_id, zone: zone}) do
    url =
      "https://compute.googleapis.com/compute/v1/projects/#{project_id}/zones/#{zone}/instances/#{
        instance_id
      }/stop"

    with {:ok, %{token: token}} <- Gcp.authenticate() do
      headers = [{"Authorization", "Bearer #{token}"}]

      HTTPoison.post(url, "", headers)
      |> parse_response()
    else
      e -> {:error, e}
    end
  end

  defp parse_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    {:ok, Jason.decode!(body)}
  end

  defp parse_response({:ok, %HTTPoison.Response{body: body}}) do
    {:error, Jason.decode!(body)}
  end

  defp parse_response(unknown), do: {:error, unknown}
end
