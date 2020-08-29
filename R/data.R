#' @import tibble
#' @import sf
NULL

#' State names, abbreviations and FIPS codes
#'
#' A data frame containing the names, USPS abbreviations, and
#' FIPS codes of the 50 states and DC for the year 2019
#'
#' @format A data frame with 51 rows and 3 variables:
#' \describe{
#'   \item{state_fips}{FIPS code}
#'   \item{state_name}{name of the state}
#'   \item{state_abb}{two-letter USPS state abbreviation}
#' }
#' @source \url{https://www.census.gov/geographies/reference-files/2019/demo/popest/2019-fips.html}
"states"

#' County names and FIPS codes
#'
#' A data frame containing the names and FIPS codes of counties
#' in the fifty US states and DC for the year 2019
#'
#' @format A data frame with 3,142 rows and 4 variables:
#' \describe{
#'   \item{state_abb}{two-letter USPS state abbreviation}
#'   \item{state_fips}{two-digit state FIPS code}
#'   \item{county_fips}{three-digit county FIPS code}
#'   \item{county_name}{name of the county}
#' }
#' @source \url{https://www.census.gov/geographies/reference-files/2019/demo/popest/2019-fips.html}
"counties"


#' ZCTA-county relationship
#'
#' A data frame with ZCTA to county relationships as of the 2010 Census.
#' There is a separate row for each ZCTA-county intersection record.
#' See \url{https://www2.census.gov/geo/pdfs/maps-data/data/rel/explanation_zcta_county_rel_10.pdf}
#' for additional details.
#'
#' @format A data frame with 44,198 rows and 13 variables:
#' \describe{
#'   \item{zcta}{five-digit ZCTA code}
#'   \item{state_abb}{two-letter USPS state abbreviation}
#'   \item{state_fips}{two-digit state FIPS code}
#'   \item{cty_fips}{three-digit county FIPS code}
#'   \item{zcta_pop}{total population}
#'   \item{zcta_area}{total area, in square meters}
#'   \item{zcta_land_area}{total land area, in square meters}
#'   \item{subset_pop}{population for relationship record}
#'   \item{subset_area}{area for relationship record, in square meters}
#'   \item{subset_area_land}{land area for relationship record, in square meters}
#'   \item{subset_pop_pct}{percentage of total population represented by record}
#'   \item{subset_area_pct}{percentage of total area represented by record}
#'   \item{subset_area_land_pct}{percentage of total land area represented by record}
#' }
#' @source \url{https://www.census.gov/geographies/reference-files/time-series/geo/relationship-files.html}
"zcta_county_rel"

#' sf data frame of US states
#'
#' An sf data frame of the fifty US states and DC.
#' It is the 2019 cartographic boundary file at resolution 20M.
#' The EPSG is 4326.
#'
#' @format An sf data frame with 51 rows and 4 variables:
#' \describe{
#'   \item{state_fips}{two-digit state FIPS code}
#'   \item{state_name}{name of the state}
#'   \item{state_abb}{two-digit USPS abbreviation}
#'   \item{geometry}{an sf geometry column with polygon data}
#' }
#' @source \url{https://www.census.gov/geographies/mapping-files/time-series/geo/cartographic-boundary.html}
"state_sf"

#' sf data frame of US counties
#'
#' An sf data frame of counties in the fifty US states and DC.
#' It is the 2019 cartographic boundary file at resolution 20M.
#' The EPSG is 4326.
#'
#' @format An sf data frame with 3,142 rows and 6 variables:
#' \describe{
#'   \item{fips}{five-digits county FIPS code (i.e., concatenation of state and county FIPS codes)}
#'   \item{state_fips}{two-digit state FIPS code}
#'   \item{county_fips}{three-digit county FIPS code}
#'   \item{state_abb}{two-digit USPS abbreviation}
#'   \item{county_name}{name of the county}
#'   \item{geometry}{an sf geometry column with polygon data}
#' }
#' @source \url{https://www.census.gov/geographies/mapping-files/time-series/geo/cartographic-boundary.html}
"county_sf"

#' sf data frame of US Zip Code Tabulation Areas (ZCTA)
#'
#' An sf data frame of ZCTAs in the fifty US states and DC.
#' It is the 2019 cartographic boundary file at resolution 500K.
#' The EPSG is 4326.
#'
#' @format An sf data frame with 32,989 rows and 5 variables:
#' \describe{
#'   \item{zcta}{five-digit ZCTA code}
#'   \item{state_abb}{two-digit USPS abbreviation of state containing largest percentage of ZCTA population}
#'   \item{geometry}{an sf geometry column with polygon data}
#' }
#' @source \url{https://www.census.gov/geographies/mapping-files/time-series/geo/cartographic-boundary.html}
"zcta_sf"


#' sf data frame of places
#'
#' An sf data frame of places in the fifty US states and DC.
#' It is the 2019 cartographic boundary file at resolution 500K.
#' The EPSG is 4326.
#'
#' @format An sf data frame with 29,321 rows and 4 variables:
#' \describe{
#'   \item{state_fips}{two-digit state FIPS code}
#'   \item{state_abb}{two-digit USPS abbreviation}
#'   \item{name}{place name}
#'   \item{geometry}{an sf geometry column with polygon data}
#' }
#' @source \url{https://www.census.gov/geographies/mapping-files/time-series/geo/cartographic-boundary.html}
"place_sf"


