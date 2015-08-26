defmodule Oddobot.Handlers.Command do
  @moduledoc """
  Basic command parsing
  """

  @usage nil

  use Hedwig.Handler
  import String

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

  def parse_command(cmd) do
    match_regex = ~r/^(?<command>\S+)\s*(?<args>.*)/
    %{"command" => command, "args" => args} = Regex.named_captures(match_regex, cmd)
    {String.downcase(command), args}
  end

  def handle_command(cmd, msg) do
    case parse_command(cmd) do
      {"help", _} -> handle_help(msg)
      {invalid, _} -> handle_unknown(invalid, msg)
      ditto -> reply(msg, "Parse error: #{inspect ditto}")
    end
  end

  def handle_help(msg) do
    reply(msg, "Greetings humans, I am Oddobot.")
  end

  def handle_unknown(command, msg) do
    reply(msg, "Do not know '#{command}'")
  end

end
