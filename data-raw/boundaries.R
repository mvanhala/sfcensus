
library(dplyr)
library(sf)

#### downloads --------------------------

# https://www.census.gov/geographies/reference-files/2020/demo/popest/2020-fips.html

curl::curl_download(
  "https://www2.census.gov/programs-surveys/popest/geographies/2020/all-geocodes-v2020.xlsx",
  "data-raw/files/all-geocodes-v2020.xlsx"
)


# https://www.census.gov/geographies/reference-files/time-series/geo/relationship-files.2020.html
# https://www2.census.gov/geo/docs/maps-data/data/rel2020/zcta520/tab20_zcta520_county20_natl.txt

curl::curl_download(
  "https://www2.census.gov/geo/docs/maps-data/data/rel2020/zcta520/tab20_zcta520_county20_natl.txt",
  "data-raw/files/tab20_zcta520_county20_natl.txt"
)


# https://www.census.gov/geographies/mapping-files/time-series/geo/cartographic-boundary.2020.html

# urban areas from TIGER/Line, cartographic boundary not available yet
# "Cartographic Boundary Files – May 2023"
# https://www.census.gov/programs-surveys/geography/guidance/geo-areas/urban-rural.html
# https://www.census.gov/geographies/mapping-files/time-series/geo/tiger-line-file.2020.html
# https://www2.census.gov/geo/tiger/TIGER2020/
# https://www2.census.gov/geo/tiger/TIGER2020/UAC/

curl::curl_download(
  "https://www2.census.gov/geo/tiger/GENZ2020/shp/cb_2020_us_state_20m.zip",
  "data-raw/files/cb_2020_us_state_20m.zip"
)

curl::curl_download(
  "https://www2.census.gov/geo/tiger/GENZ2020/shp/cb_2020_us_county_20m.zip",
  "data-raw/files/cb_2020_us_county_20m.zip"
)

curl::curl_download(
  "https://www2.census.gov/geo/tiger/GENZ2020/shp/cb_2020_us_zcta520_500k.zip",
  "data-raw/files/cb_2020_us_zcta520_500k.zip"
)

curl::curl_download(
  "https://www2.census.gov/geo/tiger/GENZ2020/shp/cb_2020_us_place_500k.zip",
  "data-raw/files/cb_2020_us_place_500k.zip"
)

curl::curl_download(
  "https://www2.census.gov/geo/tiger/TIGER2020/UAC/tl_2020_us_uac20.zip",
  "data-raw/files/tl_2020_us_uac20.zip"
)

curl::curl_download(
  "https://www2.census.gov/geo/tiger/TIGER2020/UAC/tl_2020_us_uac10.zip",
  "data-raw/files/tl_2020_us_uac10.zip"
)

unzip("data-raw/files/cb_2020_us_state_20m.zip", exdir = "data-raw/files/cb_2020_us_state_20m")
unzip("data-raw/files/cb_2020_us_county_20m.zip", exdir = "data-raw/files/cb_2020_us_county_20m")
unzip("data-raw/files/cb_2020_us_zcta520_500k.zip", exdir = "data-raw/files/cb_2020_us_zcta520_500k")
unzip("data-raw/files/cb_2020_us_place_500k.zip", exdir = "data-raw/files/cb_2020_us_place_500k")
unzip("data-raw/files/tl_2020_us_uac20.zip", exdir = "data-raw/files/tl_2020_us_uac20")

#### data creation ------------------------------

states <- readxl::read_excel("data-raw/files/all-geocodes-v2020.xlsx", skip = 3) |>
  filter(`Summary Level` == "040") |>
  select(
    state_fips = `State Code (FIPS)`,
    state_name = `Area Name (including legal/statistical area description)`
  ) |>
  inner_join(
    tibble(state_name = state.name, state_abb = state.abb) |>
      add_row(state_name = "District of Columbia", state_abb = "DC"),
    by = "state_name"
  ) |>
  arrange(state_fips)

counties <- read_sf("data-raw/files/cb_2020_us_county_20m") |>
  st_set_geometry(NULL) |>
  transmute(
    state_abb = STUSPS,
    state_fips = STATEFP,
    cty_fips = COUNTYFP,
    cty_name = NAME,
    cty_desc = na_if(stringr::str_replace_all(NAMELSAD, paste0("^", NAME, " ?"), ""), "")
  ) |>
  semi_join(states, by = "state_abb") |>
  arrange(state_fips, cty_fips)

zcta_county_rel <- readr::read_delim(
  "data-raw/files/tab20_zcta520_county20_natl.txt",
  delim = "|",
  col_types = readr::cols(
    "GEOID_ZCTA5_20" = "c",
    "GEOID_COUNTY_20" = "c",
    "AREALAND_ZCTA5_20" = "d",
    "AREALAND_PART" = "d",
    .default = "_"
  )
) |>
  filter(!is.na(GEOID_ZCTA5_20)) |>
  mutate(
    state_fips = stringr::str_sub(GEOID_COUNTY_20, end = 2),
    cty_fips = stringr::str_sub(GEOID_COUNTY_20, start = 3)
  ) |>
  inner_join(counties, by = c("state_fips", "cty_fips")) |>
  transmute(
    zcta = GEOID_ZCTA5_20,
    state_abb,
    state_fips,
    cty_fips,
    subset_area_land = AREALAND_PART,
    subset_area_land_pct = AREALAND_PART / AREALAND_ZCTA5_20
  ) |>
  arrange(zcta, state_fips, cty_fips)

zcta_state_rel <- zcta_county_rel |>
  group_by(zcta, state_abb) |>
  summarise(
    area_pct = sum(subset_area_land_pct),
    .groups = "drop"
  ) |>
  group_by(zcta) |>
  filter(row_number(desc(area_pct)) == 1) |>
  select(-area_pct) |>
  ungroup() |>
  arrange(zcta)

state_sf <- read_sf("data-raw/files/cb_2020_us_state_20m") |>
  select(state_fips = STATEFP, state_name =  NAME, state_abb = STUSPS) |>
  semi_join(states, by = "state_fips") |>
  arrange(state_fips) |>
  st_transform(4326)

county_sf <- read_sf("data-raw/files/cb_2020_us_county_20m") |>
  select(state_fips = STATEFP, cty_fips = COUNTYFP) |>
  inner_join(counties, by = c("state_fips", "cty_fips")) |>
  transmute(
    fips = paste0(state_fips, cty_fips),
    state_fips,
    cty_fips,
    state_abb,
    cty_name,
    cty_desc
  ) |>
  arrange(fips) |>
  st_transform(4326)

zcta_sf <- read_sf("data-raw/files/cb_2020_us_zcta520_500k") |>
  inner_join(zcta_state_rel, by = c("ZCTA5CE20" = "zcta")) |>
  select(zcta = ZCTA5CE20, state_abb) |>
  arrange(zcta) |>
  st_transform(4326)

place_sf <- read_sf("data-raw/files/cb_2020_us_place_500k") |>
  semi_join(states, by = c("STUSPS" = "state_abb")) |>
  transmute(
    state_abb = STUSPS,
    state_fips = STATEFP,
    place_fips = PLACEFP,
    place_name = NAME,
    place_desc = na_if(
      stringr::str_replace_all(
        NAMELSAD,
        paste0(
          "^",
          stringr::str_replace_all(NAME, c("\\(" = "\\\\\\(", "\\)" = "\\\\\\)")),
          " ?"
        ),
        ""),
      ""
    )
  ) |>
  arrange(state_fips, place_name, place_fips) |>
  st_transform(4326)

urban_area_sf <-read_sf("data-raw/files/tl_2020_us_uac20")|>
  transmute(
    code = UACE20,
    name = NAME20,
    states = stringr::str_extract_all(NAME20, paste(c(state.abb, "DC"), collapse = "|"))
  ) |>
  rowwise() |>
  filter(length(states) > 0) |>
  arrange(code) |>
  st_transform(4326)

##### save data ----------------------

usethis::use_data(state_sf, overwrite = TRUE)
usethis::use_data(county_sf, overwrite = TRUE)
usethis::use_data(zcta_sf, overwrite = TRUE)
usethis::use_data(place_sf, overwrite = TRUE)
usethis::use_data(urban_area_sf, overwrite = TRUE)

usethis::use_data(states, overwrite = TRUE)
usethis::use_data(counties, overwrite = TRUE)
usethis::use_data(zcta_county_rel, overwrite = TRUE)


