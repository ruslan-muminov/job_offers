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

```bash
mix deps.get
iex -S mix
```
```elixir
JobOffers.Api.job_offers_around_location(43, 7, 4000)
```

There are some comments in code connected with radians and kilometers, and how it's handled.
