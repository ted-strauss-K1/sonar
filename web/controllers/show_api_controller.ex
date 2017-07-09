defmodule Sonar.ShowApiController do
  use Sonar.Web, :controller
  use Timex

  import Ecto.Query, only: [from: 2]

  alias Sonar.Show

  def index(conn, %{"id" => id}) do
    event = from(s in Show, where: ^id == s.id)
    |> Repo.one
    render(conn, "index.json", event: event)
  end

  def shows_prox(conn, %{"date" => date, "lat" => lat, "lng" => lng, "off" => off}) do

    utc_start = Timex.parse!(date, "{ISO:Extended}")
    |> Timex.add(Timex.Duration.from_seconds off)
    |> Timex.beginning_of_day
    |> Timex.to_unix()

    start = utc_start - off
    finish = start + 86400
    query = from s in Show, where: s.utc_date > ^start and s.utc_date < ^finish, order_by: s.utc_date
    shows = Repo.all(query)
    |> sort_days(lng, lat)

    venues = shows
    |> Enum.uniq_by(& &1.venue)
    |> Enum.map(& %{name: &1.venue, pos: [&1.venue_long, &1.venue_lat]})

    shows = shows
    |> Enum.map(fn %{id: id, ytid: ytid, venue: venue, utc_date: date, price: price, artist: artist, url_facebook: facebook, url_ticket: ticket} ->
      %{ytid: ytid,
        venue: Enum.find(venues, &(&1.name == venue)),
        utc_date: date,
        price: price,
        artist: artist,
        url_facebook: facebook,
        url_ticket: ticket,
        id: id,
      }
    end)

    render(conn, "index.json", shows: shows)
  end

  defp sort_days(shows, lng, lat) do
    Enum.sort(shows, fn a, b ->
      dist_a = :math.sqrt(:math.pow(a.venue_long - lng, 2) + :math.pow(a.venue_lat - lat, 2))
      dist_b = :math.sqrt(:math.pow(b.venue_long - lng, 2) + :math.pow(b.venue_lat - lat, 2))
      dist_a < dist_b
    end)
  end
end
