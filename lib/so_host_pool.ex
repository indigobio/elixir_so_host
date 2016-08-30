defmodule SoHostPool do
  @moduledoc """
  Controls access to a pool of SoHosts
  """
  use Supervisor

  defstruct [:pid, :name]

  def start_link(so_path, parallelism \\ 8) do
    name = :"so_host:#{so_path}:#{inspect(make_ref)}"
    {:ok, pid} = Supervisor.start_link(__MODULE__, [so_path, parallelism, name])
    {:ok, %SoHostPool{pid: pid, name: name}}
  end

  def init([so_path, parallelism, name]) do
    poolboy_config = [
      {:name, {:local, name}},
      {:worker_module, SoHost},
      {:size, parallelism},
      {:max_overflow, 0}
    ]

    children = [
      :poolboy.child_spec(name, poolboy_config, so_path)
    ]

    options = [strategy: :one_for_one]

    supervise(children, options)
  end

  def call(pool, func_name, data) do
    :poolboy.transaction(pool.name, &SoHost.call(&1, func_name, data), :infinity)
  end
end
