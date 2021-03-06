#--------------------#
# LarryHua.com, 2019 #
#--------------------#

#' Meta labeling, including three options: triple barriers, upper and vertical barriers, and lower and vertical barriers.
#'
#' @param x a vector of prices series to be labeled.
#' @param events a dataframe that has the following columns:
#' \itemize{
#'          \item t0: event's starting time index.
#'          \item t1: event's ending time index; if t1==Inf then no vertical barrier, i.e., last observation in x is the vertical barrier.
#'          \item trgt: the unit absolute return used to set up the upper and lower barriers.
#'          \item side: 0: both upper and lower barriers; 1: only upper; -1: only lower.
#'         }
#' @param ptSl a vector of two multipliers for the upper and lower barriers, respectively.
#' @param ex_vert whether exclude the output when the vertical barrier is hit; default is T.
#' @param n_ex number of excluded observations at the begining of x; default is 0.
#' 
#' @return data frame with the following columns:
#' \itemize{
#'         \item T_up: local time index when the upper barrier is hit; Inf means that upper is not hit.
#'         \item T_lo: local time index when the lower barrier is hit; Inf means that lower is not hit.
#'         \item t1: local time index when the vertical barrier is hit.
#'         \item ret: return associated with the event.
#'         \item label: low:-1, vertical:0, upper:1.
#'         \item t0Fea: begining time index of feature bars.
#'         \item t1Fea: ending time index of feature bars.
#'         \item tLabel: ending time index of events, i.e., when the labels are created. Both t1Fea and tLabel will be useful for sequential bootstrap.
#'         }
#'
#' @author Larry Lei Hua
#'
#' @export
label_meta <- function(x, events, ptSl, ex_vert=T, n_ex=0)
{
  nBar <- length(x)
  t0 <- events$t0
  t1 <- sapply(events$t1, function(tt){min(tt,nBar)})
  trgt <- events$trgt
  side <- events$side
  u <- ptSl[1]
  l <- ptSl[2]
  
  T_up <- T_lo <- label <- NULL
  
  out <- sapply(1:length(t0), 
                function(i)
                {
                  i_t0 <- t0[i]
                  i_t1 <- min(t1[i], length(x))
                  i_x <- x[i_t0:i_t1]
                  i_nx <- length(i_x)
                  i_trgt <- trgt[i]
                  i_side <- side[i]
                  if(i_side==0)
                  {
                    up <- i_trgt*u
                    lo <- i_trgt*l
                    isup <- (i_x/i_x[1]-1) >= up
                    islo <- -(i_x/i_x[1]-1) >= lo
                    T_up <- ifelse(sum(isup)>0, min(which(isup)), Inf)
                    T_lo <- ifelse(sum(islo)>0, min(which(islo)), Inf)
                  }else if(i_side == 1)
                  {
                    up <- i_trgt*u
                    isup <- (i_x/i_x[1]-1) >= up
                    T_up <- ifelse(sum(isup)>0, min(which(isup)), Inf)
                    T_lo <- Inf
                  }else
                  {
                    lo <- i_trgt*l
                    islo <- -(i_x/i_x[1]-1) >= lo
                    T_up <- Inf
                    T_lo <- ifelse(sum(islo)>0, min(which(islo)), Inf)
                  }
                  
                  ret <- i_x[min(T_up, T_lo, i_nx)] / i_x[1] - 1
                  label <- which.min(c(T_lo, i_nx+1e-6, T_up)) - 2 # low:-1, vertical:0, upper:1
                                                                   # +1e-6 to avoid when i_nx==T_up, the label is 0 instead of the correct 1

                  rst <- c(T_up, T_lo, length(i_x), ret, label)
                  return(rst)
                }
  )
  out <- data.frame(t(out))
  names(out) <- c("T_up", "T_lo", "t1", "ret", "label")
  
  out$t0Fea <- c(n_ex+1, t0[-length(t0)]-1)
  out$t1Fea <- t0 - 1
  out$tLabel <- t0 - 1 + apply(out[,c("T_up", "T_lo", "t1")], 1, min)

  if(ex_vert==T)
  {
    out <- subset(out, !(is.infinite(T_up) & is.infinite(T_lo)))
  }
  
  return(out)
}
