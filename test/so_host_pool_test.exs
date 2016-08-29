defmodule SoHostPoolTest do
  use ExUnit.Case
  import TestData

  test "SoHostPool" do
    {:ok, p} = SoHostPool.start_link(libecho_path, 2, host_path)
    response = SoHostPool.call(p, "echo", "hello")
    assert response == "you said: hello"
  end
end
