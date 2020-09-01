# sfcensus

## Installation

```
devtools::install_github("mvanhala/sfcensus")
```

## Overview

This is an R data package with US Census spatial data sets.

It contains several [`sf`](https://github.com/r-spatial/sf)-class data sets:

* `?state_sf`: 2019 boundaries for the 50 US states and DC, at 20M resolution

* `?county_sf`: 2019 boundaries for US counties, at 20M resolution

* `?place_sf`: 2019 boundaries for US places in the 50 states and DC, at 500K resolution

* `?zcta_sf`: 2010 boundaries for Zip Code Tabulation Areas, at 500K resolution

The `sf` objects are all [EPSG:4326](https://epsg.io/4326).

There are also a few other data sets in the package:

* `?states`: data frame of state names, abbreviations, and FIPS codes

* `?counties`: data frame of county names and FIPS codes

* `?zcta_county_rel`: data frame with the relationship between ZCTAs and counties. There is an
observation for each ZCTA-county intersection.


