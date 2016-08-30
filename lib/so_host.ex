defmodule SoHost do
  @moduledoc """
  Holds a connection to a process hosting a shared object.
  """
  use GenServer

  defmodule State do
    defstruct [:so_path, :port]
  end


  # Callbacks

  def init(so_path) do
    {:ok, %State{so_path: so_path, port: make_slave(so_path)}}
  end

  def handle_call({:request, name, data}, _from, %State{port: port} = state) when is_binary(data) do
    Port.command(port, name)
    Port.command(port, data)
    receive do
      {^port, {:data, data}} ->
        {:reply, data, state}
      {^port, {:exit_status, status}} ->
        on_slave_death(status, state)
    end
  end

  def handle_info(msg, %State{port: port} = state) do
    case msg do
      {^port, {:exit_status, status}} ->
        on_slave_death(status, state)
    end
  end

  # Client

  def start_link(so_path) do
    GenServer.start_link(__MODULE__, so_path)
  end

  def call(so_host, func_name, data) do
    GenServer.call(so_host, {:request, func_name, data})
  end


  # Private

  def on_slave_death(status, state) do
    IO.puts "so_host for #{state.so_path} exited with status #{status}"
    {:stop, :slave_died, %{state | port: nil}}
  end

  def make_slave(so_path) do
    desc = {:spawn_executable, "priv/so_host"}
    args = [so_path]
    opts = [{:args, args}, :binary, {:packet, 4}, :exit_status]
    Port.open(desc, opts)
  end
end
