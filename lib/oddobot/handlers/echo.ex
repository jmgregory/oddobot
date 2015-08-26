defmodule Oddobot.Handlers.Echo do
  @moduledoc """
  A completely useless echo script.

  This script simply echoes the same message back.
  """

  @usage nil

  use Hedwig.Handler
  import String
  require Logger

  @cmd_prefix "/oddo"

  def has_command_prefix?(msg_text) do
    starts_with?(msg_text, @cmd_prefix)
  end

  def handle_event(%Message{body: ""}, opts) do
    {:ok, opts}
  end

  def handle_event(%Message{type: "groupchat"} = msg, opts) do
    if has_command_prefix?(strip(msg.body)) do
      cmd = slice(strip(msg.body), String.length(@cmd_prefix)..-1)
      handle_command(cmd, msg)
    end
    {:ok, opts}
  end

  def handle_event(%Message{type: "chat"} = msg, opts) do
    handle_command(strip(msg.body), msg)
    {:ok, opts}
  end

  def handle_event(_, opts) do
    {:ok, opts}
  end

  def handle_command(cmd, msg) do
    Logger.warn fn -> "Recieved command: " <> cmd end
    reply(msg, cmd)
  end

end
