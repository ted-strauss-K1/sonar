<template>

<div class="finder" style="background:#343332">
  <slot />
</div>

</template>

<script>

import "mapbox.js";
import "mapbox.js/theme/style.css";

L.mapbox.accessToken = "pk.eyJ1IjoibWVzaHUiLCJhIjoiY2lwcjRzbnA4MDA3cWkybWFjYWpva3UwbCJ9.OYx5wsP9YBImxOuvdrkDQw";

export default {
  computed: {
    userCoords() {
      return this.$store.state.userCoords;
    },
    venues() {
      return this.$store.state.venues;
    },
    currentEvent() {
      return this.$store.getters.currentEvent;
    }
  },
  methods: {
    updateUserCoords(coords) {
      const [ lon, lat ] = coords;
      this.map.setView([ lat, lon ]);
      this.userLayer.setGeoJSON({
        type: "Feature",
        properties: {
          title: "You are here",
          "marker-color": "#2d9ad8",
          // "marker-color": "#f86767",
          "marker-size": "medium",
          // url: "http://en.wikipedia.org/wiki/Washington,_D.C."
          "marker-symbol": "star"
        },
        geometry: { type: "Point", coordinates: coords }
      });
    },
    updateCurrentVenue(venueId) {
      const venue = this.$store.state.venues[venueId]
      const coords = venue.pos;
      const [ lon, lat ] = coords;
      this.map.setView([ lat, lon ]);
      this.currentVenueLayer.setGeoJSON({
        type: "Feature",
        properties: {
          title: venueId,
          // "marker-color": "#2d9ad8",
          "marker-color": "#f86767",
          "marker-size": "small",
          // url: "http://en.wikipedia.org/wiki/Washington,_D.C."
          "marker-symbol": "music"
        },
        geometry: { type: "Point", coordinates: coords }
      });
    },
    updateVenues(venues) {
      const features = [];
      for (let i in venues) {
        const venue = venues[i];
        features.push({
          type: "Feature",
          properties: {
            title: venue.name,
            "marker-color": "#ffc500",
            "marker-size": "small",
            // url: "http://en.wikipedia.org/wiki/Washington,_D.C."
            "marker-symbol": "music"
          },
          geometry: { type: "Point", coordinates: venue.pos }
        });
        // }
      }
      this.venuesLayer.setGeoJSON({ type: "FeatureCollection", features });
    }
  },
  watch: {
    userCoords(coords) {
      this.updateUserCoords(coords);
    },
    venues(venues) {
      this.updateVenues(venues);
    },
    currentEvent(event) {
      this.updateCurrentVenue(event.venue);
    }
  },
  mounted() {
    this.map = L.mapbox.map(this.$el, null, { zoom: 14, zoomControl: false, keyboard: false, attributionControl: false });
    L.mapbox
      .styleLayer("mapbox://styles/meshu/cipx013xd000abjnf5g2ip4qw")
      .addTo(this.map);
    this.userLayer = L.mapbox.featureLayer().addTo(this.map);
    this.venuesLayer = L.mapbox.featureLayer().addTo(this.map);
    this.currentVenueLayer = L.mapbox.featureLayer().addTo(this.map);
    this.venuesLayer.on("click", event => {
      this.$store.commit("SET_ACTIVE_VENUE", {venue: event.layer.options.title})
    });
    if (this.userCoords) this.updateUserCoords(this.userCoords);
    if (this.venues) this.updateVenues(this.venues);
    if (this.currentEvent) this.updateCurrentVenue(this.currentEvent.venue);
  },
  beforeDestroy() {
    this.map.remove();
  }
};

</script>