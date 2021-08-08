## JobOffers

### Continents grouping

For running this script print next:

```bash
mix deps.get
mix category_continent_job_offers_count
```

### Scaling

In case we have 100 000 000 job offers and 1000 new job offers per second, and still want to receive similar output in the previous section in real-time, we have to:
 - store already computed result and reuse it: do calculatings only for new data
 - if nobody initiate computing during some period, do it by itself (timer or scheduler) to avoid an accumulation of a huge count of unread records
 - on init step (before any computations) try to parallelize calculating
 - maybe separate computing process from client reading at all: calculate continuously in offline mode and store results in cache or db, and when a client makes a request just read prepared result from storage

### API implementation

To check connectivity:
```
http://<host>:8443/ping
```

To get job offers around given location and radius:
```
http://<host>:8443/offers_around_location?latitude=13.7&longitude=100.5&radius=10
```

### Running tests

```bash
mix deps.get
mix test --no-start
```
