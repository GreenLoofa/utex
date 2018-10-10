defmodule UnixTime do
  @moduledoc """
  Wrappers for time functions
  """

  use Timex

  @doc """
  Returns the current unix time on the calling machine
  """
  def cur_unix() do
    DateTime.utc_now()
    |> DateTime.to_unix()
  end

  @doc """
  Returns the unix time of the given date/time string `date_time`

  `date_time` can be of the form:
  - YYYY
  - YYYY/MM
  - YYYY/MM/DD
  - YYYY/MM/DD-hh
  - YYYY/MM/DD-hh:mm
  - YYYY/MM/DD-hh:mm:ss

  Optionally accepts time (Might need to think on this one)
  """
  def get_unix(date_time, tz) do
    date_time_list = String.split(date_time, "-")

    if length(date_time_list) == 2 do
      [date, time] = date_time_list

      (String.split(date, "/") ++ String.split(time, ":"))
      |> Enum.map(&String.to_integer(&1))
      |> parse_date(tz)
    else
      date_time_list
      |> List.first()
      |> String.split("/")
      |> Enum.map(&String.to_integer(&1))
      |> parse_date(tz)
      |> List.first()
    end
  end

  defp get_timezone() do
    {zone, result} = System.cmd("date", ["+%Z"])
    if result == 0, do: String.trim(zone)
  end

  @doc """
  Takes a unix time and returns a formatted string with
  the UTC date/time and local timezone date/time
  """
  def unix_to_date_string(unix_time) do
    timezone = get_timezone()

    """
    -----
    #{unix_to_date(unix_time, "UTC")} UTC

    #{unix_to_date(unix_time, timezone)} #{timezone}
    -----
    """
  end

  defp unix_to_date(unix_time, tz) do
    unix_time
    |> DateTime.from_unix!()
    |> Timex.to_datetime(tz)
    |> Timex.format!("{YYYY}/{0M}/{D} {h24}:{0m}:{0s}")
  end

  @doc """
  Returns the range of unix times for a specific date as a string
  separated by new line characters

  For example
  ```
  iex> start_end("2017", "UTC") 
  iex> "1483228800\\n1514764799\\n"

  iex> start_end("2017/01", "UTC")
  iex> "1483228800\\n1485907199\\n"
  ```

  The given `date` string must be in one of the following forms:
  YYYY
  YYYY/MM
  YYYY/MM/DD
  """
  def start_end(date, tz) do
    date
    |> String.split("/")
    |> Enum.map(&String.to_integer(&1))
    |> parse_date(tz)
    |> Enum.reduce("", fn x, acc ->
      acc <> to_string(x) <> "\n"
    end)
  end

  defp parse_date([year], tz) do
    [
      iso8601_to_unix("#{year}-01-01T00:00:00Z", tz),
      iso8601_to_unix("#{year}-12-31T23:59:59Z", tz)
    ]
  end

  defp parse_date([year, month], tz) do
    [
      iso8601_to_unix("#{year}-#{format_num(month)}-01T00:00:00Z", tz),
      iso8601_to_unix(
        "#{year}-#{format_num(month)}-#{get_end_of_month(year, month)}T23:59:59Z",
        tz
      )
    ]
  end

  defp parse_date([year, month, day], tz) do
    [
      iso8601_to_unix("#{year}-#{format_num(month)}-#{format_num(day)}T00:00:00Z", tz),
      iso8601_to_unix(
        "#{year}-#{format_num(month)}-#{format_num(day)}T23:59:59Z",
        tz
      )
    ]
  end

  defp parse_date([year, month, day, hour], tz) do
    iso8601_to_unix(
      "#{year}-#{format_num(month)}-#{format_num(day)}T#{format_num(hour)}:00:00Z",
      tz
    )
  end

  defp parse_date([year, month, day, hour, minute], tz) do
    iso8601_to_unix(
      "#{year}-#{format_num(month)}-#{format_num(day)}T#{format_num(hour)}:#{format_num(minute)}:00Z",
      tz
    )
  end

  defp parse_date([year, month, day, hour, minute, second], tz) do
    iso8601_to_unix(
      "#{year}-#{format_num(month)}-#{format_num(day)}T#{format_num(hour)}:#{format_num(minute)}:#{
        format_num(second)
      }Z",
      tz
    )
  end

  defp format_num(num) do
    if num < 10 do
      "0#{num}"
    else
      "#{num}"
    end
  end

  ## Returns the last day of the month as an integer
  ## Assumes `year` and `month` are integers
  defp get_end_of_month(year, month) do
    months = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

    cond do
      month == 2 and Timex.is_leap?(year) ->
        29

      true ->
        Enum.at(months, month - 1)
    end
    |> format_num()
  end

  @doc """
  Converts an iso8601 formatted date string to a unix time
  """
  def iso8601_to_unix(iso8601_date, tz) do
    {:ok, date_time, _} = DateTime.from_iso8601(iso8601_date)

    new_date_time = Timex.to_datetime(date_time, tz)
    
    date_time
    |> Timex.shift(seconds: -new_date_time.utc_offset)
    |> DateTime.to_unix()
  end
end
