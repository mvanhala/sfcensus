% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{county_sf}
\alias{county_sf}
\title{sf data frame of US counties}
\format{
An sf data frame with 3,142 rows and 6 variables:
\describe{
\item{fips}{five-digits county FIPS code (i.e., concatenation of state and county FIPS codes)}
\item{state_fips}{two-digit state FIPS code}
\item{county_fips}{three-digit county FIPS code}
\item{state_abb}{two-digit USPS abbreviation}
\item{county_name}{name of the county}
\item{geometry}{an sf geometry column with polygon data}
}
}
\source{
\url{https://www.census.gov/geographies/mapping-files/time-series/geo/cartographic-boundary.html}
}
\usage{
county_sf
}
\description{
An sf data frame of counties in the fifty US states and DC.
It is the 2019 cartographic boundary file at resolution 20M.
The EPSG is 4326.
}
\keyword{datasets}
