defmodule Oddobot.Handlers.Echo do
  @moduledoc """
  A completely useless echo script.

  This script simply echoes the same message back.
  """

  @usage nil

  use Hedwig.Handler

  require Logger

  @cmd_prefix "/oddo"

  def has_command_prefix?(msg_text) do
    String.starts_with?(msg_text, @cmd_prefix)
  end

  def handle_event(%Message{body: ""}, opts) do
    {:ok, opts}
  end

  def handle_event(%Message{type: "groupchat"} = msg, opts) do
    if has_command_prefix?(msg.body) do
      cmd = String.slice(msg.body, String.length(@cmd_prefix)..-1)
      handle_command(cmd, msg)
    end
    {:ok, opts}
  end

  def handle_event(%Message{type: "chat"} = msg, opts) do
    handle_command(msg.body, msg)
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
