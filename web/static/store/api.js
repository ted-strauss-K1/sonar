export function fetchEvent(id) {
  return fetch(`/api/events/${id}`).then(response => response.json());
}

export function fetchEvents(ids) {
  return Promise.all(ids.map(id => fetchEvent(id)));
}

export function scrape() {
  return fetch(`/api/scrape`).then(response => response.json());
}
