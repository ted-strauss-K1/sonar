defmodule Sonar.ShowApiView do
  use Sonar.Web, :view

#   def render("index.json", %{shows: shows}) do
#       IO.inspect shows
#     shows
#   end

  def render("index.json", %{event: event}) do
    Map.from_struct(event)
    |> Map.delete(:__meta__)
  end

  def render("index.json", %{shows: shows}) do
    %{events: shows}
  end

  def render("show.json", %{show_api: show}) do
    Map.from_struct(show)
    |> Map.delete(:__meta__)
  end

#   def render("show.json", %{venue: venue}) do
#     %{data: render_one(venue, Sonar.VenueView, "venue.json")}
#   end

#   def render("venue.json", %{venue: venue}) do
#     %{id: venue.id,
#       name: venue.name}
#   end
end
