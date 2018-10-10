defmodule Utex do
  @moduledoc """
  Documentation for Utex.
  """

  require UnixTime

  def main(args \\ []) do
    args
    |> parse_args()
    |> response()
    |> IO.puts()
  end

  defp parse_args(args) do
    {opts, _, _} =
      args
      |> OptionParser.parse(
        switches: [
          date: :integer,
          now: :boolean,
          help: :boolean,
          startend: :string,
          unix: :string,
          iso: :string,
          timezone: :string
        ],
        aliases: [d: :date, n: :now, h: :help, s: :startend, u: :unix, i: :iso, t: :timezone]
      )

    opts
  end

  ## TODO: Add hour and minute for startend
  defp get_usage() do
    """
    utex usage

    --help, -h             : Display this usage message
    --now, -n              : Get the current unix timestamp
    --date, -d [unix time] : Given a unix time, display the date/time in UTC and the current machine's timezone
    --iso                  : Given an iso formatted date, give the unix time

    --timezone, -t         : Specify what timezone to use with the commands below. Defaults to UTC if no
                           : timezone is given

    --startend, -s [date]  : Display the unix times that start and end the given day, month, or year
                           : Allowed formats:
                           :  1. YYYY
                           :  2. YYYY/MM
                           :  3. YYYY/MM/DD

    --unix, -u [date/time] : Display the unix time for the given date/time
                           : Allowed formats:
                           :  1. YYYY
                           :  2. YYYY/MM
                           :  3. YYYY/MM/DD
                           :  4. YYYY/MM/DD-hh
                           :  5. YYYY/MM/DD-hh:mm
                           :  6. YYYY/MM/DD-hh:mm:ss
    """
  end

  defp response(opts) do
    cond do
      !is_nil(opts[:help]) ->
        get_usage()

      !is_nil(opts[:date]) ->
        UnixTime.unix_to_date_string(opts[:date])

      !is_nil(opts[:now]) ->
        UnixTime.cur_unix()

      !is_nil(opts[:startend]) ->
        UnixTime.start_end(opts[:startend], opts[:timezone])

      !is_nil(opts[:unix]) ->
        UnixTime.get_unix(opts[:unix], opts[:timezone])

      !is_nil(opts[:iso]) ->
        UnixTime.iso8601_to_unix(opts[:iso], opts[:timezone])

      true ->
        "No valid arguments given\n\n" <> get_usage()
    end
  end
end
