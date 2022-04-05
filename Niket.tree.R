
# For a particular day, given I infectious nodes and new exposures N
# These values (100 and 80) are just examples and don't mean anything
I <- 100  # number of infectious individuals
N <- 99   # new infections

# write a length I vector of parent-child connections, g, that sums to N.
# construct a vector in accordance with the associated contact distribution p(T), 
# we start by writing:  g = (1,1,1,...,1,0,0,0,...,0),
g <- c( rep(1, N), rep(0, (I-N)) )  # vector of 1s and 0s, length = I, sum = N

i <- I

# Starting at g’s first entry (i = 0) and defining the rolling sum
# G = Sigma, j=0, i-1, g(j)

G <- cumsum(g)
# G[j]

# Then, draw a sample, k, from
# p(T | N,G) = p(T) / ( 1 − Sigma(T>N-G) p(T) )
# the conditionally re-normalized degree distribution
# i.e. k for only those situations in which N-G < T


ttt <- 

probability of a negative binomial achieves each of the potential values

test.v <- dnbinom(n=(0:N-G), size = 0.077, mu = 1)   
divide that whole vector by pnbinom( of maximum G)

# Niket cycles through "g", giving each I a "T" number of transmissions, using
# the negative binomial. 
# But of course the total transmissions ( sum(g) ) can't be greater than N.
# So Niket adjusts the probability distribution ("conditionally renormalized degree distribution")
# to make sure T is not greater than the rolling N-G value.
# i.e. The rolling sum, G, with each new addition of T transmissions, can't be greater 
# than the total number of transmissions (which is N).

# Pseudo-code:
# draw from nbinom distribution for g[i] (i is defined by the length of N)
# put new value in g vector at position i
# check to see if G (rolling sum of g up until i) is greater than N
# if G < N, goto 1
# if G > N

# Or, draw I values from a negative binomial until their sum = N

test <- function(I, N)
{
  repeat {
    g <-  rnbinom(n=I, size=0.077, mu=1)
    G <- sum(g)
    if (G == N) 
      return(g)
    }
  }

g <- test(I=100, N=99)
    

