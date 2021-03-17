defmodule Toolbox.AWS.EC2 do
  @doc """
  {:ok,
  %{
   "DescribeInstancesResponse" => %{
     "requestId" => "5c816a94-1ff8-4351-9450-a8dc8ecee694",
     "reservationSet" => %{
       "item" => %{
         "groupSet" => nil,
         "instancesSet" => %{
           "item" => %{
             "sourceDestCheck" => "true",
             "hypervisor" => "xen",
             "clientToken" => nil,
             "ipAddress" => "xxx",
             "capacityReservationSpecification" => %{
               "capacityReservationPreference" => "open"
             },
             "rootDeviceName" => "/dev/sda1",
             "networkInterfaceSet" => %{
               "item" => %{
                 "association" => %{
                   "ipOwnerId" => "xxx",
                   "pnnublicDnsName" => "ec2-xxx-xx-xx-xxx.us-east-2.compute.amazonaws.com",
                   "publicIp" => "xxx"
                 },
                 "attachment" => %{
                   "attachTime" => "2021-03-15T01:24:59.000Z",
                   "attachmentId" => "eni-attach-xxx",
                   "deleteOnTermination" => "true",
                   "deviceIndex" => "0",
                   "status" => "attached"
                 },
                 "description" => nil,
                 "groupSet" => %{
                   "item" => %{
                     "groupId" => "sg-xxx",
                     "groupName" => "dev-box"
                   }
                 },
                 "interfaceType" => "interface",
                 "ipv6AddressesSet" => nil,
                 "macAddress" => "0a:9f:76:a1:f6:88",
                 "networkInterfaceId" => "eni-xxx",
                 "ownerId" => "xxx",
                 "privateDnsName" => "ip-xxx.us-east-2.compute.internal",
                 "privateIpAddress" => "xxx",
                 "privateIpAddressesSet" => %{
                   "item" => %{
                     "association" => %{
                       "ipOwnerId" => "xxx",
                       "publicDnsName" => "ec2-x-xxx-xxx-xxx.us-east-2.compute.amazonaws.com",
                       "publicIp" => "3x.xxx.xxx.xxx"
                     },
                     "primary" => "true",
                     "privateDnsName" => "ip-xxx-xx-xx-xxx.us-east-2.compute.internal",
                     "privateIpAddress" => "xxx.xx.xx.xxx"
                   }
                 },
                 "sourceDestCheck" => "true",
                 "status" => "in-use",
                 "subnetId" => "subnet-xxxx",
                 "vpcId" => "vpc-29a02c42"
               }
             },
             "instanceType" => "t3.xlarge",
             "instanceState" => %{"code" => "16", "name" => "running"},
             "monitoring" => %{"state" => "enabled"},
             "groupSet" => %{
               "item" => %{
                 "groupId" => "sg-xxxx",
                 "groupName" => "dev-box"
               }
             },
             "productCodes" => nil,
             "instanceId" => "i-xxx",
             "amiLaunchIndex" => "0",
             "tagSet" => %{"item" => %{"key" => "Name", "value" => "DevBox"}},
             "imageId" => "ami-xxx",
             "cpuOptions" => %{"coreCount" => "2", "threadsPerCore" => "2"},
             "placement" => %{
               "availabilityZone" => "us-east-2c",
               "groupName" => nil,
               "tenancy" => "default"
             },
             "reason" => nil,
             "enclaveOptions" => %{"enabled" => "false"},
             "enaSupport" => "true",
             "hibernationOptions" => %{"configured" => "true"},
             "metadataOptions" => %{
               "httpEndpoint" => "enabled",
               "httpPutResponseHopLimit" => "1",
               "httpTokens" => "optional",
               "state" => "applied"
             },
             "rootDeviceType" => "ebs",
             "launchTime" => "2021-03-16T23:17:28.000Z",
             "vpcId" => "vpc-xxx",
             "privateIpAddress" => "xxx.xx.xx.xxx",
             "blockDeviceMapping" => %{
               "item" => %{
                 "deviceName" => "/dev/sda1",
                 "ebs" => %{
                   "attachTime" => "2021-03-15T01:24:59.000Z",
                   "deleteOnTermination" => "true",
                   "status" => "attached",
                   "volumeId" => "vol-xxx"
                 }
               }
             },
             "dnsName" => "ec2-xxx-xxx-xxx-xxx.us-east-2.compute.amazonaws.com",
             "privateDnsName" => "ip-xxx-xx-xx-xxx.us-east-2.compute.internal",
             "ebsOptimized" => "true",
             "keyName" => "DevBox",
             "virtualizationType" => "hvm",
             "subnetId" => "subnet-xxxxxxxx",
             "architecture" => "x86_64"
           }
         },
         "ownerId" => "xxx",
         "reservationId" => "r-xxx"
       }
     }
   }
  }}
  """
  def instances do
    ExAws.EC2.describe_instances()
    |> ExAws.request()
    |> parse_request()
  end

  # def instances_by_tag(name, value) do
  #   ExAws.EC2.describe_instances("Filter.1.Name": "tag:" <> name, "Filter.1.Value": value)
  #   |> ExAws.request()
  #   |> parse_response
  # end

  def instance_by_id(nil), do: nil

  def instance_by_id(id) do
    ExAws.EC2.describe_instances(filters: ["instance-id": id])
    |> ExAws.request()
    |> parse_request()
  end

  defp parse_request({:ok, %{body: body}}), do: XmlToMap.naive_map(body) |> parse_response()
  defp parse_request({:error, _err}), do: nil

  # "reservationSet, "item" "instancesSet" "item" "instanceState" "name"
  defp parse_response(%{
         "DescribeInstancesResponse" => %{
           "requestId" => req_id,
           "reservationSet" => %{
             "item" => %{"instancesSet" => %{"item" => %{"instanceState" => %{"name" => state}}}}
           }
         }
       }),
       do: %{req_id: req_id, instance_state: state}

  def start(nil), do: nil

  def start(instance_id) do
    ExAws.EC2.start_instances([instance_id])
    |> ExAws.request()
  end

  def stop(nil), do: nil

  def stop(instance_id) do
    ExAws.EC2.stop_instances([instance_id])
    |> ExAws.request()
  end

  def reboot(nil), do: nil

  def reboot(instance_id) do
    ExAws.EC2.reboot_instances([instance_id])
    |> ExAws.request()
  end
end
