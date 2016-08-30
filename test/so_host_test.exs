defmodule SoHostTest do
  use ExUnit.Case

  test "SoHost.call" do
    {:ok, h} = SoHost.start_link(TestData.libecho_path)
    response = SoHost.call(h, "echo", "asdf")
    assert response == "you said: asdf"
  end
end
