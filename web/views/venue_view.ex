defmodule Sonar.VenueView do
  use Sonar.Web, :view

  def render("index.json", %{venues: venues}) do
    %{data: render_many(venues, Sonar.VenueView, "venue.json")}
  end

  def render("show.json", %{venue: venue}) do
    %{data: render_one(venue, Sonar.VenueView, "venue.json")}
  end

  def render("venue.json", %{venue: venue}) do
    %{id: venue.id,
      name: venue.name}
  end
end
