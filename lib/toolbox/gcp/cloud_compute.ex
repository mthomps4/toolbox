defmodule Toolbox.Gcp.CloudEngine do
  alias Toolbox.Gcp

  defmodule InstanceStatus do
    @moduledoc """
      https://cloud.google.com/compute/docs/instances/instance-life-cycle
    """

    @doc """
      Resources are being allocated for the instance. The instance is not running yet.
    """
    def provisioning, do: "PROVISIONING"

    @doc """
      Resources have been acquired and the instance is being prepared for first boot.
    """
    def staging, do: "STAGING"

    @doc """
      The instance is booting up or running. You should be able to ssh into the instance soon, but not immediately, after it enters this state.
    """
    def running, do: "RUNNING"

    @doc """
      The instance is being stopped. This can be because a user has made a request to stop the instance or there was a failure. This is a temporary status and the instance will move to TERMINATED.
    """
    def stopping, do: "STOPPING"

    @doc """
    The instance is being repaired. This can happen because the instance encountered an internal error or the underlying machine is unavailable due to maintenance.
    """
    def repairing, do: "REPAIRING"

    @doc """
      A user shut down the instance, or the instance encountered a failure. You can choose to restart the instance or delete it.
    """
    def terminated, do: "TERMINATED"

    @doc """
      The instance is being suspended. A user has suspended the instance.
    """
    def suspending, do: "SUSPENDING"

    @doc """
      The instance is suspended. You can choose to resume or delete it.
    """
    def suspended, do: "SUSPENDED"

    def is_booting(current_state),
      do: Enum.any?(["PROVISIONING", "STAGING"], fn state -> state == current_state end)

    def is_running("RUNNING"), do: true
    def is_running(_other), do: false

    def is_stopping("STOPPING"), do: true
    def is_stopping(_other), do: false

    def is_terminated("TERMINATED"), do: true
    def is_terminated(_other), do: false

    def is_repairing("REPAIRING"), do: true
    def is_repairing(_other), do: false
  end

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
