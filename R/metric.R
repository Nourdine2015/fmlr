#--------------------#
# LarryHua.com, 2019 #
#--------------------#

#' A function to check whether a classification is better than a guess
#' 
#' @param train_class a vector for the distribution of classes in the training set
#' @param test_class a vector for the distribution of classes in the test set
#' @param my_acc a number between 0 and 1 for the classification accuracy to be evaluated
#' @param s sample size of simulations used to check p-values
#' 
#' @examples 
#' train_class <- c(1223,1322,1144)
#' test_class <- c(345,544,233)
#' my_acc <- 0.45
#' acc_lucky(train_class, test_class, my_acc)
#' 
#' @author Larry Lei Hua
#' 
#' @export
acc_lucky <- function(train_class, test_class, my_acc, s=1000)
{
  acc_random_guess <- acc_educated_guess <- NULL
  nTrain_class <- length(train_class)
  nTest_class <- length(test_class)
  nTrain <- sum(train_class)
  nTest <- sum(test_class)

  if(nTrain_class!=nTest_class) stop("Error: The number of classes in test and train sets are different!")
  true_class <- unlist(sapply(seq_len(nTrain_class), function(i){rep(i, test_class[i])}))

  random_guess <- sample(1:nTrain_class, nTest*s, replace = T)
  random_guess <- matrix(random_guess, s, nTest)

  educated_guess <- sample(1:nTrain_class, nTest*s, prob = train_class/nTrain, replace = T)
  educated_guess <- matrix(educated_guess, s, nTest)

  acc_random_guess <- apply(random_guess, 1, function(xvec){sum(true_class == xvec) / nTest})
  acc_educated_guess <- apply(educated_guess, 1, function(xvec){sum(true_class == xvec) / nTest})
  acc_majority_guess <- sum(true_class == rep(which.max(train_class), nTest)) / nTest

  # one-side p value
  p_random_guess <- sum(my_acc <= acc_random_guess)/length(acc_random_guess)
  p_educated_guess <- sum(my_acc <= acc_educated_guess)/length(acc_educated_guess)
  return(list(my_accuracy=my_acc,
              p_random_guess=p_random_guess,
              p_educated_guess=p_educated_guess,
              mean_random_guess=mean(acc_random_guess),
              mean_educated_guess=mean(acc_educated_guess),
              acc_majority_guess=acc_majority_guess))
}
