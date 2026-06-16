source("data.R")

# Extract 5000 random samples from the whole dataset
set.seed(42)
Y = as.matrix(df_clean[sample(1:nrow(df_clean), 5000), ])
n = nrow(Y); d = ncol(Y); k = 3
R = 10000

# hyperparameters
al = rep(1, k) # non-informative Dirichlet prior on weights

# starting values (via robust K-means)
km = kmeans(Y, centers=k, nstart=10)
mu = km$centers
S = list()
for(u in 1:k) S[[u]] = cov(Y[km$cluster==u, ]) + diag(1e-4, d) # Fixed covariance
la = rep(1/k, k)
z = km$cluster

# Gibbs sampler storage
La = matrix(0, R, k)
Mu = array(0, c(k, d, R))
Z = matrix(0, R, n)

# iterate
for(h in 1:R){
  # update lambda (weights)
  nz = table(factor(z, levels=1:k))
  alt = al + nz
  la = as.vector(rdirichlet(1, alt))
  
  # update mu (means with flat prior -> Normal posterior)
  for(u in 1:k){
    if(nz[u] > 0){
      y_bar = colMeans(Y[z==u, , drop=FALSE])
      mu[u,] = rmvnorm(1, y_bar, S[[u]]/nz[u])
    } else {
      mu[u,] = Y[sample(1:n, 1), ]
    }
  }
  
  # update z (class assignment)
  Pc = matrix(0, n, k)
  for(u in 1:k) Pc[,u] = dmvnorm(Y, mu[u,], S[[u]])
  
  pm = as.vector(Pc %*% la)
  Pp = (1/pm) * (Pc %*% diag(la))
  
  # Numerical safety to avoid NA if probabilities are extremely small
  Pp[is.na(Pp)] = 1/k 
  Pp = sweep(Pp, 1, rowSums(Pp), "/") 
  
  for(i in 1:n) z[i] = sample(1:k, 1, prob=Pp[i,])
  
  # label switching (sorting based on Burnout: column 1)
  ind = order(mu[,1])
  if(any(ind != (1:k))){
    la = la[ind]
    mu = mu[ind,]
    S = S[ind]
    z1 = z
    for(u in 1:k) z[z1==ind[u]] = u
  }
  
  # store parameters
  La[h,] = la
  Mu[,,h] = mu
  Z[h,] = z
}

# output
mla = colMeans(La)
mmu = apply(Mu, c(1,2), mean)

zb = rep(0,n)
for(i in 1:n) zb[i] = which.max(table(factor(Z[,i], levels=1:k)))

print(mla) # Final weights
print(mmu) # Final means (Burnout, PHQ9) per class