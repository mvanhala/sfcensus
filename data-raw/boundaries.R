
library(dplyr)
library(sf)

# https://www.census.gov/geographies/reference-files/2019/demo/popest/2019-fips.html

curl::curl_download(
  "https://www2.census.gov/programs-surveys/popest/geographies/2019/all-geocodes-v2019.xlsx",
  "data-raw/files/all-geocodes-v2019.xlsx"
)

states <- readxl::read_excel("data-raw/files/all-geocodes-v2019.xlsx", skip = 3) %>%
  filter(`Summary Level` == "040") %>%
  select(
    state_fips = `State Code (FIPS)`,
    state_name = `Area Name (including legal/statistical area description)`
    ) %>%
  inner_join(
    tibble(state_name = state.name, state_abb = state.abb) %>%
      add_row(state_name = "District of Columbia", state_abb = "DC"),
    by = "state_name"
  )

counties <- readxl::read_excel("data-raw/files/all-geocodes-v2019.xlsx", skip = 3) %>%
  filter(`Summary Level` == "050") %>%
  select(
    state_fips = `State Code (FIPS)`,
    county_fips = `County Code (FIPS)`,
    county_name = `Area Name (including legal/statistical area description)`
  ) %>%
  inner_join(states, by = "state_fips") %>%
  select(state_abb, state_fips, county_fips, county_name)


# https://www.census.gov/geographies/reference-files/time-series/geo/relationship-files.html
# https://www2.census.gov/geo/docs/maps-data/data/rel/zcta_county_rel_10.txt

curl::curl_download(
  "https://www2.census.gov/geo/docs/maps-data/data/rel/zcta_county_rel_10.txt",
  "data-raw/files/zcta_county_rel_10.txt"
)

zcta_county_rel <- readr::read_csv(
  "data-raw/files/zcta_county_rel_10.txt",
  col_types = readr::cols("ZCTA5" = "c", "STATE" = "c", "COUNTY" = "c", "GEOID" = "c", .default = "d")
) %>%
  inner_join(
    select(states, state_fips, state_abb),
    by = c("STATE" = "state_fips")
    ) %>%
  select(
    zcta = ZCTA5,
    state_abb,
    state_fips = STATE,
    county_fips = COUNTY,
    zcta_pop = ZPOP,
    zcta_area = ZAREA,
    zcta_area_land = ZAREALAND,
    subset_pop = POPPT,
    subset_area = AREAPT,
    subset_area_land = AREALANDPT,
    subset_pop_pct = ZPOPPCT,
    subset_area_pct = ZAREAPCT,
    subset_area_land_pct = ZAREALANDPCT
  )

zcta_state_rel <- zcta_county_rel %>%
  group_by(zcta, state_abb) %>%
  summarise(
    pop = first(zcta_pop),
    area = first(zcta_area),
    area_land = first(zcta_area_land),
    pop_pct = sum(subset_pop_pct)
  ) %>%
  group_by(zcta) %>%
  filter(row_number(desc(pop_pct)) == 1) %>%
  select(-pop_pct) %>%
  ungroup()




# https://www.census.gov/geographies/mapping-files/time-series/geo/cartographic-boundary.html

curl::curl_download(
  "https://www2.census.gov/geo/tiger/GENZ2019/shp/cb_2019_us_state_20m.zip",
                    "data-raw/files/cb_2019_us_state_20m.zip"
  )

curl::curl_download(
  "https://www2.census.gov/geo/tiger/GENZ2019/shp/cb_2019_us_county_20m.zip",
  "data-raw/files/cb_2019_us_county_20m.zip"
)

curl::curl_download(
  "https://www2.census.gov/geo/tiger/GENZ2019/shp/cb_2019_us_zcta510_500k.zip",
  "data-raw/files/cb_2019_us_zcta510_500k.zip"
)

curl::curl_download(
  "https://www2.census.gov/geo/tiger/GENZ2019/shp/cb_2019_us_place_500k.zip",
  "data-raw/files/cb_2019_us_place_500k.zip"
)

unzip("data-raw/files/cb_2019_us_state_20m.zip", exdir = "data-raw/files/cb_2019_us_state_20m")
unzip("data-raw/files/cb_2019_us_county_20m.zip", exdir = "data-raw/files/cb_2019_us_county_20m")
unzip("data-raw/files/cb_2019_us_zcta510_500k.zip", exdir = "data-raw/files/cb_2019_us_zcta510_500k")
unzip("data-raw/files/cb_2019_us_place_500k.zip", exdir = "data-raw/files/cb_2019_us_place_500k")

state_sf <- read_sf("data-raw/files/cb_2019_us_state_20m") %>%
  select(state_fips = STATEFP, state_name =  NAME, state_abb = STUSPS) %>%
  st_transform(4326) %>%
  semi_join(states, by = "state_fips") %>%
  arrange(state_fips)

county_sf <- read_sf("data-raw/files/cb_2019_us_county_20m") %>%
  select(state_fips = STATEFP, county_fips = COUNTYFP, county_name = NAME) %>%
  inner_join(select(states, state_fips, state_abb), by = "state_fips") %>%
  transmute(
    fips = paste0(state_fips, county_fips),
    state_fips,
    county_fips,
    state_abb,
    county_name
  ) %>%
  st_transform(4326) %>%
  arrange(fips)

zcta_cb <- read_sf("data-raw/files/cb_2019_us_zcta510_500k") %>%
  select(zcta = ZCTA5CE10) %>%
  st_transform(4326)

##------------
## no new ZCTA in 50 states + DC

zcta_cb %>%
  anti_join(select(zcta_state_rel, zcta, state_abb), by = "zcta") %>%
  st_join(state_sf, left = FALSE)

##--------------

zcta_sf <- zcta_cb %>%
  inner_join(select(zcta_state_rel, zcta, state_abb), by = "zcta") %>%
  select(zcta, state_abb) %>%
  arrange(zcta)

place_sf <- read_sf("data-raw/files/cb_2019_us_place_500k") %>%
  select(state_fips = STATEFP, name = NAME) %>%
  inner_join(select(states, state_fips, state_abb), by = "state_fips") %>%
  select(state_fips, state_abb, name) %>%
  arrange(state_fips, name)

usethis::use_data(state_sf, overwrite = TRUE)
usethis::use_data(county_sf, overwrite = TRUE)
usethis::use_data(zcta_sf, overwrite = TRUE)
usethis::use_data(place_sf, overwrite = TRUE)

usethis::use_data(states, overwrite = TRUE)
usethis::use_data(counties, overwrite = TRUE)
usethis::use_data(zcta_county_rel, overwrite = TRUE)


