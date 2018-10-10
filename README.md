# Utex

## Overview

Utex is a command line tool to help with converting between datetimes and unix times.

## Installation
```bash
mix escript.build
mv utex /usr/local/bin
```

You should be able to call `utex` from the command after the above steps

## Usage

Here are some examples of how the command line tool can be used

```bash
## Get the current unix time

> utex -n
> 1539132676
```

```bash
## Get the date/time from a given unix time

> utex -d 1539132676
> -----
  2018/10/10 00:51:16 UTC
  
  2018/10/9 20:51:16 EDT
  -----

## The second date/time entry's timezone is dependent upon the calling machine's timezone
```

```bash
## Convert an iso8601 formatted date to a unix time

> utex --iso 2017-05-01T05:05:05Z 
> 1493615105
```

```bash
## Get the start and end unix times for a particular day, month, or year
## The valid formats are as follows:
## 1. YYYY
## 2. YYYY/MM
## 3. YYYY/MM/DD

> utex -s 2017
> 1483228800   ## Jan 1, 2017 00:00:00 UTC
  1514764799   ## Dec 31, 2017 23:59:59 UTC

## The -t flag can be used to specify a timezone

> utex -s 2017 -t EDT
> 1483246800 ## Jan 1, 2017 00:00:00 EDT
  1514782799 ## Dec 31, 2017 23:59:59 EDT
```

```bash
## Get the unix time of a particular date / time
## The valid formats are as follows:
## 1. YYYY
## 2. YYYY/MM
## 3. YYYY/MM/DD
## 4. YYYY/MM/DD-hh
## 5. YYYY/MM/DD-hh:mm
## 6. YYYY/MM/DD-hh:mm:ss

> utex -u 2017/3/13-05:00:00
> 1489381200

## The -t flag can be used to specify a timezone

> utex -u 2017/3/13-05:00:00 -t EDT
> 1489399200

## Note: - there will be some strange behaviour around daylight savings timezones (ie. EDT above)
##       - Not all timezones are supported
```

## Future TODO
- [ ] Add unit tests for more timezones
- [ ] Implement more timezones (Currently only whatever `Timex` supports)
- [ ] Resolve any issues with daylight savings time