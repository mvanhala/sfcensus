#' @import tibble
#' @import sf
NULL

#' State names, abbreviations and FIPS codes
#'
#' A data frame containing the names, USPS abbreviations, and
#' FIPS codes of the 50 states and DC for the year 2020
#'
#' @format A data frame with 51 rows and 3 variables:
#' \describe{
#'   \item{state_fips}{FIPS code}
#'   \item{state_name}{name of the state}
#'   \item{state_abb}{two-letter USPS state abbreviation}
#' }
#' @source <https://www.census.gov/geographies/reference-files/2020/demo/popest/2020-fips.html>
"states"

#' County names and FIPS codes
#'
#' A data frame containing the names and FIPS codes of counties
#' in the fifty US states and DC for the year 2020
#'
#' @format A data frame with 3,143 rows and 5 variables:
#' \describe{
#'   \item{state_abb}{two-letter USPS state abbreviation}
#'   \item{state_fips}{two-digit state FIPS code}
#'   \item{cty_fips}{three-digit county FIPS code}
#'   \item{cty_name}{name of the county}
#'   \item{cty_desc}{county entity type}
#' }
#' @source <https://www.census.gov/geographies/reference-files/2020/demo/popest/2020-fips.html>
"counties"


#' ZCTA-county relationship
#'
#' A data frame with ZCTA to county relationships as of the 2020 Census.
#' There is a separate row for each ZCTA-county intersection record.
#' See <https://www2.census.gov/geo/pdfs/maps-data/data/rel2020/zcta520/explanation_tab20_zcta520_county20_natl.pdf>
#' for additional details.
#'
#' @format A data frame with 46,690 rows and 6 variables:
#' \describe{
#'   \item{zcta}{five-digit ZCTA code}
#'   \item{state_abb}{two-letter USPS state abbreviation}
#'   \item{state_fips}{two-digit state FIPS code}
#'   \item{cty_fips}{three-digit county FIPS code}
#'   \item{subset_area_land}{land area for relationship record, in square meters}
#'   \item{subset_area_land_pct}{percentage of total land area represented by record}
#' }
#' @source <https://www.census.gov/geographies/reference-files/time-series/geo/relationship-files.2020.html#list-tab-E7GGIXHXQT6PO7VYWR>
"zcta_county_rel"

#' sf data frame of US states
#'
#' An sf data frame of the fifty US states and DC.
#' It is the 2020 cartographic boundary file at resolution 20M.
#' The EPSG is 4326.
#'
#' @format An sf data frame with 51 rows and 4 variables:
#' \describe{
#'   \item{state_fips}{two-digit state FIPS code}
#'   \item{state_name}{name of the state}
#'   \item{state_abb}{two-digit USPS abbreviation}
#'   \item{geometry}{an sf geometry column with polygon data}
#' }
#' @source <https://www.census.gov/geographies/mapping-files/time-series/geo/cartographic-boundary.2020.html>
"state_sf"

#' sf data frame of US counties
#'
#' An sf data frame of counties in the fifty US states and DC.
#' It is the 2020 cartographic boundary file at resolution 20M.
#' The EPSG is 4326.
#'
#' @format An sf data frame with 3,143 rows and 7 variables:
#' \describe{
#'   \item{fips}{five-digit county FIPS code (i.e., concatenation of state and county FIPS codes)}
#'   \item{state_fips}{two-digit state FIPS code}
#'   \item{cty_fips}{three-digit county FIPS code}
#'   \item{state_abb}{two-digit USPS abbreviation}
#'   \item{cty_name}{name of the county}
#'   \item{cty_desc}{county entity type}
#'   \item{geometry}{an sf geometry column with polygon data}
#' }
#' @source <https://www.census.gov/geographies/mapping-files/time-series/geo/cartographic-boundary.2020.html>
"county_sf"

#' sf data frame of US Zip Code Tabulation Areas (ZCTA)
#'
#' An sf data frame of ZCTAs in the fifty US states and DC.
#' It is the 2020 cartographic boundary file at resolution 500K.
#' The EPSG is 4326.
#'
#' @format An sf data frame with 33,642 rows and 3 variables:
#' \describe{
#'   \item{zcta}{five-digit ZCTA code}
#'   \item{state_abb}{two-digit USPS abbreviation of state containing largest percentage of ZCTA population}
#'   \item{geometry}{an sf geometry column with polygon data}
#' }
#' @source <https://www.census.gov/geographies/mapping-files/time-series/geo/cartographic-boundary.2020.html>
"zcta_sf"


#' sf data frame of places
#'
#' An sf data frame of places in the fifty US states and DC.
#' It is the 2020 cartographic boundary file at resolution 500K.
#' The EPSG is 4326.
#'
#' @format An sf data frame with 31,617 rows and 6 variables:
#' \describe{
#'   \item{state_fips}{two-digit state FIPS code}
#'   \item{state_abb}{two-digit USPS abbreviation}
#'   \item{place_fips}{five-digit place FIPS code}
#'   \item{place_name}{place name}
#'   \item{place_desc}{place entity type}
#'   \item{geometry}{an sf geometry column with polygon data}
#' }
#' @source <https://www.census.gov/geographies/mapping-files/time-series/geo/cartographic-boundary.2020.html>
"place_sf"


#' sf data frame of urban areas
#'
#' An sf data frame of urban areas in the fifty US states and DC.
#' It is the 2020 TIGER/Line file.
#' The EPSG is 4326.
#'
#' @format An sf data frame with 2,613 rows and 4 variables:
#' \describe{
#'   \item{code}{five-digit urban area code}
#'   \item{name}{urban area name}
#'   \item{states}{vector of states of the urban area}
#'   \item{geometry}{an sf geometry column with polygon data}
#' }
#' @source <https://www.census.gov/geographies/mapping-files/time-series/geo/cartographic-boundary.2020.html>
"urban_area_sf"


