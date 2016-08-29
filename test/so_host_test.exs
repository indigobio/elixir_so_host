defmodule SoHostTest do
  use ExUnit.Case
  import TestData

  test "SoHost.call" do
    {:ok, h} = SoHost.start_link(libecho_path, host_path)
    response = SoHost.call(h, "echo", "asdf")
    assert response == "you said: asdf"
  end
end
