defmodule UnixTimeTest do
  @moduledoc """
  Test that the underlying functions for each flag behave as expected
  """

  use ExUnit.Case, async: true
  doctest Utex

  import UnixTime

  describe "--now, -n flag" do
    test "result is an integer" do
      assert cur_unix() |> is_integer()
    end
  end

  describe "--date, -d flag" do
    test "valid unix time returns correctly formatted date" do
      output = unix_to_date_string(1538948633)

      assert String.contains?(output, "2018/10/7 21:43:53 UTC")
      ## The rest of the output is hard to test as it is either
      ## aesthetic or dependent on the specific machine
    end
  end

  describe "--iso flag" do
    test "Valid iso8601-formatted date returns correct unix time" do
      assert iso8601_to_unix("2017-01-01T01:01:01Z", "UTC") == 1483232461
    end

    test "-t EDT option returns correct unix time" do
      assert iso8601_to_unix("2017-01-01T01:01:01Z", "EDT") == 1483250461
    end

    ## TODO: Add more time zones to test
  end

  describe "--range, -r flag" do
    test "Given YYYY, the correct unix time range is returned" do
      assert start_end("2017", "UTC") == "1483228800\n1514764799\n"
    end

    test "Given YYYY/MM, the correct unix time range is returned" do
      assert start_end("2017/01", "UTC") == "1483228800\n1485907199\n"
      assert start_end("2016/02", "UTC") == "1454284800\n1456790399\n" ## Leap Year
    end

    test "Given YYYY/M, the correct unix time range is returned" do
      assert start_end("2017/1", "UTC") == "1483228800\n1485907199\n"
    end

    test "Given YYYY/MM/DD, the correct unix time range is returned" do
      assert start_end("2017/01/01", "UTC") == "1483228800\n1483315199\n"
      assert start_end("2016/02/29", "UTC") == "1456704000\n1456790399\n" ## Leap Day
    end

    test "Given YYYY/M/D, the correct unix time range is returned" do
      assert start_end("2017/1/1", "UTC") == "1483228800\n1483315199\n"
    end

    ## TODO: Test invalid formats
  end

  describe "--unix, -u flag" do
    test "Given YYYY, the correct unix time is returned" do
      assert get_unix("2017", "UTC") == 1483228800
    end

    test "Given YYYY/MM, the correct unix time is returned" do
      assert get_unix("2017/01", "UTC") == 1483228800
      assert get_unix("2016/02", "UTC") == 1454284800 ## Leap Year
    end

    test "Given YYYY/MM/DD, the correct unix time is returned" do
      assert get_unix("2017/01/01", "UTC") == 1483228800
      assert get_unix("2016/02/29", "UTC") == 1456704000 ## Leap Day
    end

    test "Given YYYY/MM/DD-hh, the correct unix time is returned" do
      assert get_unix("2017/01/01-12", "UTC") == 1483272000
    end

    test "Given YYYY/MM/DD-h, the correct unix time is returned" do
      assert get_unix("2017/01/01-1", "UTC") == 1483232400
    end

    test "Given YYYY/MM/DD-hh:mm, the correct unix time is returned" do
      assert get_unix("2017/01/01-12:30", "UTC") == 1483273800
    end

    test "Given YYYY/MM/DD-hh:m, the correct unix time is returned" do
      assert get_unix("2017/01/01-12:1", "UTC") == 1483272060
    end

    test "Given YYYY/MM/DD-hh:mm:ss, the correct unix time is returned" do
      assert get_unix("2017/01/01-12:30:56", "UTC") == 1483273856
    end

    test "Given YYYY/MM/DD-hh:mm:s, the correct unix time is returned" do
      assert get_unix("2017/01/01-12:30:9", "UTC") == 1483273809
    end

    ## TODO: Test invalid formats
  end
end