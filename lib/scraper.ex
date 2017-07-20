defmodule Scraper do
  use GenServer
  use Export.Python
  use Timex

  alias Sonar.Show
  alias Sonar.Repo

  def start_link do
    GenServer.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  def init(:ok) do
    {:ok, %{}}
  end

  def update do
    Repo.delete_all(Show)

    {:ok, pid} = Python.start(python_path: Application.app_dir(:sonar, "priv"))
    Python.call(pid, "googlesheets", "pull", [System.get_env("KEYFILE_PATH")])
    |> Poison.decode!
    |> Stream.reject(&(Map.get(&1, "VenueName") === ""))
    |> Stream.reject(&(Map.get(&1, "VenueLat") === ""))
    |> Stream.reject(&(Map.get(&1, "VenueLong") === ""))
    |> Stream.reject(&(Map.get(&1, "BandName") === ""))
    |> Stream.reject(&(Map.get(&1, "Time") === ""))
    |> Stream.reject(&(Map.get(&1, "YTID") === "NONE"))
    |> Stream.reject(&(Map.get(&1, "YTID") === ""))
    |> Enum.map(&insert_show/1)
    |> Enum.count
  end

  defp insert_show(show) do

    date = Map.get(show, "EventDate") <> "|" <> Map.get(show, "Time") <> "|America/Toronto"
    |> Timex.parse!("{D}/{0M}/{YYYY}|{h24}:{m}|{Zname}")
    |> Timex.to_unix

    changeset = Show.changeset(%Show{}, %{
      artist: Map.get(show, "BandName"),
      venue: Map.get(show, "VenueName"),
      venue_lat: Map.get(show, "VenueLat"),
      venue_long: Map.get(show, "VenueLong"),
      ytid: Map.get(show, "YTID"),
      price: Map.get(show, "Price"),
      url_facebook: Map.get(show, "EventFacebook"),
      url_ticket: Map.get(show, "EventBuy"),
      utc_date: date
    })

    case Repo.insert(changeset) do
      {:ok, show} -> show
      {:error, reason} -> reason
    end
  end
end
