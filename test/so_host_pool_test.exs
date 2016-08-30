defmodule SoHostPoolTest do
  use ExUnit.Case

  test "SoHostPool" do
    {:ok, p} = SoHostPool.start_link(TestData.libecho_path, 2)
    response = SoHostPool.call(p, "echo", "hello")
    assert response == "you said: hello"
  end
end
