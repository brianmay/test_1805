defmodule Test1805Web.Live.Logs do
  @moduledoc "Live view for Tesla"
  use Test1805Web, :live_view

  alias Phoenix.LiveView.Socket

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:nodes, %{})
      |> assign(:active, "logs")

    :timer.send_interval(1000, :timer)
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    id =
      case params["id"] do
        nil -> nil
        id -> id
      end

    socket = assign(socket, :id, id)
    {:noreply, socket}
  end

  @spec get_list_url(Socket.t()) :: String.t()
  defp get_list_url(%Socket{} = socket) do
    Routes.logs_path(socket, :index)
  end

  @spec get_node_url(Socket.t(), id :: String.t()) :: String.t()
  defp get_node_url(%Socket{} = socket, id) do
    Routes.logs_path(socket, :index, id)
  end

  @impl true
  def handle_info(:timer, socket) do
    payload = %{
      node_id: "test",
      datetime: DateTime.now!("Etc/UTC"),
      message: "Shutup Tilly!",
      level: :debug,
      hostname: "test",
      values: %{message: "My dog barks too much"},
      state: %{message: "Why do I have a dog?"}
    }
    nodes = socket.assigns.nodes
    key = payload.node_id

    lines = Map.get(nodes, key, [])
    lines = [payload | lines]
    lines = Enum.take(lines, 20)
    nodes = Map.put(nodes, key, lines)

    socket = assign(socket, :nodes, nodes)
    {:noreply, socket}
  end

  def logs(assigns) do
    lines = assigns[:lines]

    ~H"""
        <table class="">
            <thead class="">
                <th class="">Time</th>
                <th class="">Level</th>
                <th class="">Hostname</th>
                <th class="">Message</th>
                <th class="">Values</th>
                <th class="">State</th>
            </thead>

            <tbody>
                <%= for line <- lines do %>
                    <tr>
                        <td class=""><%= line.datetime |> Calendar.strftime("%Y-%m-%d %H:%M:%S") %></td>
                        <td class=""><%= inspect line.level %></td>
                        <td class=""><%= line.hostname %></td>
                        <td class=""><%= line.message %></td>
                        <td class="">
                            <div class="">
                                <div class=""><%= inspect(line.values) |> String.slice(0..30) %></div>
                                <div class=""><pre><%= inspect(line.values, pretty: true) %></pre></div>
                            </div>
                        </td>
                        <td class="">
                            <div class="">
                                <div class=""><%= inspect(line.state) |> String.slice(0..30) %></div>
                                <div class=""><pre><%= inspect(line.state, pretty: true) %></pre></div>
                            </div>
                        </td>
                    </tr>
                <% end %>
            </tbody>
        </table>
    """
  end
end
