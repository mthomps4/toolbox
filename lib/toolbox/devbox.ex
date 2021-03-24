defmodule Toolbox.Devbox do
  @project_id Application.get_env(:toolbox, :devbox_project_id, nil)
  @instance_id Application.get_env(:toolbox, :devbox_instance_id, nil)
  @zone Application.get_env(:toolbox, :devbox_zone, nil)

  alias Toolbox.Gcp.CloudEngine

  def get_status,
    do: CloudEngine.get_status(%{instance_id: @instance_id, project_id: @project_id, zone: @zone})

  def start,
    do: CloudEngine.start(%{instance_id: @instance_id, project_id: @project_id, zone: @zone})

  def stop,
    do: CloudEngine.stop(%{instance_id: @instance_id, project_id: @project_id, zone: @zone})
end
