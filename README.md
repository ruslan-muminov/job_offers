## JobOffers

### Continents grouping

For running this script print next:

```bash
mix deps.get
mix category_continent_job_offers_count
```

### Scaling

In case we have 100 000 000 job offers or even more and still want to receive similar output in the previous section in real-time, we have to delegate calculating to separate processes. We could use a data parallelism and split our huge csv file into different parts and handle every part by separate process. As a result we will have a few answers, which we could just combine.

### API implementation

To check connectivity:
```
http://<host>:8443/ping
```

To get job offers around given location and radius:
```
http://<host>:8443/offers_around_location?latitude=43&longitude=7&radius=4000
```

There are some comments in code connected with radians and kilometers, and how it's handled.

### Running tests

```bash
mix deps.get
mix test --no-start
```
