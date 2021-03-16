defmodule Toolbox.Ec2 do
  # def instances_by_tag(name, value) do
  #   ExAws.EC2.describe_instances("Filter.1.Name": "tag:" <> name, "Filter.1.Value": value)
  #   |> ExAws.request()
  #   |> parse_response
  # end

  def instances_by_state(state) do
    ExAws.EC2.describe_instances(filters: ["instance-state-name": state])
    |> ExAws.request()
  end

  def instance_by_id(id) do
    ExAws.EC2.describe_instances(filters: ["instance-id": id])
    |> ExAws.request()
  end
end

# i-0f5fccbf444b4028a
