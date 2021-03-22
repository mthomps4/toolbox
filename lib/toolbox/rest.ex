defmodule Rest do
  def get do
    url =
      "https://compute.googleapis.com/compute/v1/projects/neural-cirrus-308001/zones/us-east-1b/instances/204427256649420470?key=AIzaSyC6YB5uRByOHdcIGJ1gQ2Q4GhnDYbpnEoY"

    HTTPoison.get!(url)
  end
end
