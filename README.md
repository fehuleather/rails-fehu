# Fehu

Stinks. On Rails.


# Todo

Automatic Currency Conversion — users choose their own country (perhaps, a little flag next to prices?)
  https://github.com/RubyMoney/money
  http://stackoverflow.com/a/3843805/313576

Wholesale
  Text block next to product hero image that Freyja can put [whatever] into — unstructured
  
  Sizes can be a grid under each product build, with many number boxes for quantities
  If possible, let them pick the overall total and leave the selection of sizes up to us
  
  Made to order — no stocks
  
  17 ring sizes are actually based on 4 real sizes
    so in reality, there are 4 quantities for 17 order-able choices
    this might not be feasible at the moment
  
  Email Freyja when an order is delivered
    the body of the email is the linesheet
  
  
## Notes

#### Photos
*	3 sizes: 400 (25k), 800 (75k), 1600 (300k)
*	is a ~90% quality jpeg (after ImageOptim)
*	Group, Hero, Retail (per variation), Wholesale (per variation)


#### Cross Browser
IE does not support vmax — perhaps we serve them a shittier stylesheet that doesn't do the full-fancy totem scaling?


## Dev
Here be the needed env vars:

```
RACK_ENV=development
PORT=3000
SECRET_KEY_BASE=(rake secret)
STRIPE_KEY=(secret — get from stripe)
STINKCODE=s (use a rake secret in prod)
STINKNAME=(rake secret)
IMAGEPATH=/images/content/
```



# Development

### Rebuild the DB from scratch
```bash
pg_ctl restart -m fast && rake db:drop db:create db:migrate db:seed
```



# Deployment

### To erase and rebuild the DB:
```bash
heroku pg:reset DATABASE --app fehu --confirm fehu
heroku run rake db:migrate db:seed --app fehu
```

### Maintenance Mode
```bash
heroku maintenance:on
# Later...
heroku maintenance:off
```
