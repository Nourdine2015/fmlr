% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bars.R
\name{bar_volume_runs}
\alias{bar_volume_runs}
\title{Construct volume runs bars}
\usage{
bar_volume_runs(dat, v_0 = 20, w0 = 10, de = 1, bkw_T = 5,
  bkw_Pb1 = 5, bkw_V = 5, filter = FALSE)
}
\arguments{
\item{dat}{dat input with at least the following column: Price, Size}

\item{v_0}{average volume for each trade, and it is used to create the first bar}

\item{w0}{the time window length of the first bar}

\item{de}{a positive value for adjusting the expected window size, that is, de*E0T; default: 1}

\item{bkw_T}{backward window length when using pracma::movavg for exponentially weighted average T}

\item{bkw_Pb1}{backward window length when using pracma::movavg for exponentially weighted average P[b_t=1]}

\item{bkw_V}{backward window length for exponentially weighted average volumes}

\item{filter}{whether used as a filter; default FALSE. If TRUE, then only i_feabar, the ending time index of feature bars, is returned}
}
\value{
If filter==FALSE, a list of vectors for tStamp (if returned), and HLOCV of volume runs bars. Note that the remaining data after the latest ending time point detected will be formed as a bar.  If filter==TRUE, i_feabar a vector of integers for the time index.
}
\description{
Construct volume runs bars
}
\examples{

set.seed(1)
dat <- data.frame(Price = c(rep(0.5, 4), runif(50)), Size = floor(runif(54)*100))
bar_volume_runs(dat)
bar_volume_runs(dat, filter=TRUE)

}
\author{
Larry Lei Hua
}
