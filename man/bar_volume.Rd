% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bars.R
\name{bar_volume}
\alias{bar_volume}
\title{Construct volume bars}
\usage{
bar_volume(dat, vol)
}
\arguments{
\item{dat}{dat input with at least the following columns: Price, Size}

\item{vol}{the volume of each window}
}
\value{
time stamp at the end of each bar (if timestamp is provided), and H,L,O,C,V
}
\description{
Construct volume bars
}
\author{
Larry Lei Hua
}
