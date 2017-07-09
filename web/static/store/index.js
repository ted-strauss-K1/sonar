import Vue from "vue";
import Vuex from "vuex";
import { addDays } from "../utils/date.js";
import { normalize, schema } from "normalizr";
import "whatwg-fetch";
import { fetchEvents, scrape } from "./api";

Vue.use(Vuex);

const venue = new schema.Entity("venues", {}, { idAttribute: "name" });
const event = new schema.Entity("events", { venue: venue });
const eventsSchema = { events: [event] };

const store = new Vuex.Store({
  state: {
    userCoords: null,
    isAskingUserCoords: false,
    isFetchingEvents: false,
    eventsRef: [],
    events: {},
    venues: {},
    index: 0,
    activeDate: new Date(),
    playerState: -1,
    playerRead: 0
  },
  actions: {
    GEOLOCATION: ({ commit, dispatch }) => {
      commit("GEOLOCATION_REQUEST");
      navigator.geolocation.getCurrentPosition(
        response => {
          const { longitude, latitude } = response.coords;
          commit("GEOLOCATION_SUCCESS", { latitude, longitude });
          dispatch("GET_EVENTS");
        },
        error => {
          const { message } = error;
          commit("GEOLOCATION_FAILURE", { message });
        }
      );
    },
    GET_EVENTS: ({ commit, state }) => {
      commit("EVENTS_REQUEST");
      const [lng, lat] = state.userCoords;
      const off = new Date().getTimezoneOffset() * -60;
      const date = state.activeDate.toISOString();
      fetch("/api/shows_prox", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          lng,
          lat,
          off,
          date
        })
      })
        .then(response => response.json())
        .then(response => {
          const data = normalize(response, eventsSchema);
          commit("EVENTS_SUCCESS", data);
          commit("SET_INDEX", { index: 0 });
        })
        .catch(error => {
          const { message } = error;
          commit("EVENTS_FAILURE", { message });
        });
    },
    FETCH_EVENTS: ({ commit, state }, { ids }) => {
      ids = ids.filter(id => {
        const event = state.events[id];
        if (!event) {
          return true;
        }
        return false;
      });
      if (ids.length) {
        return fetchEvents(ids).then(events =>
          commit("SET_EVENTS", { events })
        );
      } else {
        return Promise.resolve();
      }
    },
    NEXT_EVENT: ({ commit, dispatch, state }) => {
      const index = state.index + 1;
      if (index >= state.eventsRef.length) {
        const date = addDays(state.activeDate, 1);
        commit("SET_DATE", { date });
        dispatch("GET_EVENTS");
      } else {
        commit("SET_INDEX", { index });
      }
    },
    PREVIOUS_EVENT: ({ commit, dispatch, state }) => {
      const index = state.index - 1;
      if (index < 0) {
        const date = addDays(state.activeDate, -1);
        commit("SET_DATE", { date });
        dispatch("GET_EVENTS");
      } else {
        commit("SET_INDEX", { index });
      }
    },
    NEXT_DAY: ({ commit, dispatch, state }) => {
      const date = addDays(state.activeDate, 1);
      commit("SET_DATE", { date });
      dispatch("GET_EVENTS");
    },
    PREVIOUS_DAY: ({ commit, dispatch, state }) => {
      const date = addDays(state.activeDate, -1);
      commit("SET_DATE", { date });
      dispatch("GET_EVENTS");
    },
    SCRAPE: () => {
      scrape();
    }
  },
  mutations: {
    SET_INDEX: (state, { index }) => {
      state.index = index;
    },
    SET_DATE: (state, { date }) => {
      state.activeDate = date;
    },
    SET_ACTIVE_VENUE: (state, { venue }) => {
      state.index = state.eventsRef.findIndex(event => {
        return state.events[event].venue == venue;
      });
    },
    SET_EVENTS: (state, { events }) => {
      events.forEach(event => {
        if (event) {
          Vue.set(state.events, event.id, event);
        }
      });
    },
    EVENTS_REQUEST: state => {
      state.isFetchingEvents = true;
    },
    EVENTS_SUCCESS: (state, { result, entities }) => {
      const { events, venues } = entities;

      result.events.forEach(event => {
        if (event) {
          Vue.set(state.events, event, events[event]);
        }
      });
      // state.events = events;
      state.venues = venues;
      state.isFetchingEvents = false;
      state.eventsRef = result.events;
    },
    EVENTS_FAILURE: (state, { message }) => {
      state.isFetchingEvents = false;
      console.warn(message);
    },
    GEOLOCATION_REQUEST: state => {
      state.isAskingUserCoords = true;
    },
    GEOLOCATION_SUCCESS: (state, { longitude, latitude }) => {
      state.isAskingUserCoords = false;
      state.userCoords = [longitude, latitude];
    },
    GEOLOCATION_FAILURE: (state, { message }) => {
      state.isAskingUserCoords = false;
      console.warn(message);
    },
    PLAYER_STATE: (state, code) => {
      state.playerState = code;
    },
    PLAYER_READ: (state, ratio) => {
      state.playerRead = ratio;
    }
  },
  getters: {
    currentEvent: state => {
      return state.events[state.eventsRef[state.index]];
    },
    currentDate: state => {
      const event = state.events[state.eventsRef[state.index]];
      if (event) {
        const stubDate = new Date();
        const utc_date = state.events[state.eventsRef[state.index]].utc_date;
        const date = new Date(utc_date * 1000);
        const str = date.toDateString();
        return str.substring(0, str.length - 5);
      } else {
        return "";
      }
    },
    eventsByVenue: state => {
      const venues = state.venues;
      const events = state.events;
      const results = { ...venues };
      const response = [];
      for (let i in results) {
        results[i].events = [];
      }
      for (let i in events) {
        const event = events[i];
        results[event.venue].events.push(event);
      }
      for (let i in results) {
        response.push(results);
      }
      return response;
    }
  }
});

export default store;
