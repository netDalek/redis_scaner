defmodule RedisScaner.CLI do
  @moduledoc false

  def main([host, port]) do
    {:ok, conn} = :eredis_sync.connect_db(String.to_charlist(host), String.to_integer(port), 1)
    {:ok, <<"PONG">>} = :eredis_sync.q(conn, ["PING"])
    {:ok, total} = :eredis_sync.q(conn, ["DBSIZE"])
    total = String.to_integer(total)

    scan(conn, 0, 0, 0, total)
  end

  def scan(_conn, "0", cnt, inc, total) do
  end
  def scan(_conn, '0', cnt, inc, total) do
  end
  def scan(conn, id, cnt, inc, total) do
    {:ok, [new_id, keys]} = :eredis_sync.q(conn, ["SCAN", id])
    if rem(inc, 10) == 0 do
      IO.puts :stderr, "#{cnt*1000/total}%%"
    end
    for k <- keys do
      {:ok, res} = :eredis_sync.q(conn, ["TTL", k])
      ttl = String.to_integer(res)
      if ttl == -1 || ttl > 259_800 do
        IO.puts "#{k} - #{ttl}"
      end
    end
    scan(conn, new_id, cnt+length(keys), inc+1, total)
  end
end
