# [Least-Squares Fitting of Two 3-D Point Sets](http://bmi214.stanford.edu/bmiarc/bmi214-2008/articles/arun.pdf)
K.S. Arun, T.S. Huang, and S.D. Blostein
1987 - PAMI


## Short Summary
Given two 3-D point sets $$\{p_i\}$$ and $$\{p^\prime_i\}$$ related by $$p^\prime_i = Rp_i + T + N_i$$ for $$i = 1 .. N$$, where $$R$$ is a $$3 \times 3$$ rotation matrix, and $$T$$ is a translation vector $$T \in \mathbb{R}^3$$ and $$N$$ is a noise-vector (3-D), an algorithm is presented to find the least-squares estimate of $$R$$ and $$T$$. The algorithm is based on the SVD of a $$3 \times 3$$ matrix. The authors claim lower computation time compared to two other existing methods.

## Long(er) Summary

### Problem Formulation

Observe that, if the data is centered, we then have to solve only for the rotation $$R$$. Assume $$\hat{R}, \hat{T}$$ are the least-squares solutions respectively for the rotation and translation between the two point sets. Also, assume that $$p$$ is the centroid of $$\{p_i\}$$, $$p^\prime_i$$ is the centroid of $$\{p^\prime_i\}$$, and $$p^{\prime\prime}$$ is the centroid of $$\{p^{\prime\prime}_i\} = \{\hat{R}p_i + \hat{T}\}$$. Observe that,

$$$
p = \frac{1}{N} \sum_{i=1}^N p_i \\
p^\prime = \frac{1}{N} \sum_{i=1}^N p^\prime_i \\
p^{\prime\prime} = \frac{1}{N} \sum_{i=1}^N p^{\prime\prime}_i = \frac{1}{N} \sum_{i=1}^{N} ( \hat{R}p_i + \hat{T} ) \\ = \hat{R} \frac{1}{N} \sum_{i=1}^{N} p_i + \frac{1}{N} N\hat{T} = \hat{R}p + \hat{T}
$$$

i.e., $$\{p^{\prime\prime}_i\}$$ and $$\{p^\prime_i\}$$ have the same centroid, since we are effectively minimizing the distance between the centroids of the two point-sets (since the least-squares is unweighted).

Now, if we center each point set prior to the least-squares minimization,
$$$
q_i \triangleq p_i - p \\
q^\prime_i \triangleq p^\prime_i - p^\prime \\
$$$

the system to be minimized reduces to

$$$ 
\Sigma^2 = \sum_{i=1}^{N} \| p^\prime_i - (Rp_i + T) \|^2 \\
 = \sum_{i=1}^{N} \| q^\prime_i - Rq_i + p^\prime - Rp - T \|^2 \\
 = \sum_{i=1}^{N} \| q^\prime_i - Rq_i \|^2
$$$

Solving the original least-squares system can now be done in the following two steps:
1. find $$\hat{R}$$ to minimize the above objective
2. compute $$\hat{T}$$ as $$\hat{T} = p^\prime - \hat{R}p$$


### SVD Algorithm to Find $$\hat{R}$$
1. Center the point sets, i.e., compute $$p, p^\prime, \{q_i\}, and \{q^\prime_i\}$$
2. Compute the $$3 \times 3$$ matrix $$$ H \triangleq \sum_{i=1}^N q_i q^{\prime^ T}_i $$$
3. Find the SVD of $$H$$ $$$ H = U \Lambda V^T $$$
4. Calculate $$$X = VU^T$$$
5. Compute $$det(X)$$
	a. If $$det(X) = +1$$, then $$\hat{R} = X$$
	b. If $$det(X) = -1$$, then the algorithm fails

### Derivation of the Algorithm
The given objective simplifies to
$$$
\Sigma^2 = \sum_{i=1}^N [q^\prime_i - Rq_i]^T[q^\prime_i - Rq_i] \\
= \sum_{i=1}^{N} [q^{\prime^T}_iq^\prime_i - q^\prime_iRq_i - q^T_iR^Tq^\prime_i + q^T_iR^TRq_i] \\
= \sum_{i=1}^{N} [q^{\prime^T}_i q^\prime_i + q^T_iq_i - 2q^\prime_iRq_i]
$$$

So, minimizing $$\Sigma^2$$ is equivalent to maximizing
$$$
F = \sum_{i=1}^N q_i^{\prime^T}Rq_i \\
  = Trace(\sum_{i=1}^N Rq_iq_i^{\prime^T}) \\
  = Trace(RH)
$$$
where

$$$
H = \sum_{i=1}^N Rq_iq^{\prime^T}_i
$$$


### Degeneracies

#### Noiseless Case
Assume that all the points are noiseless, i.e., an exact solution for $$R,T$$ exists. Then, there are three possibilities:
1. **$$\{q_i\}$$ are not coplanar:** In this case, the rotation solution is unique. Further, there is no reflection which makes $$\Sigma^2$$ zero. So, the SVD returns the unique solution.
2. **$$\{q_i\}$$ are coplanar but not collinear:** In this case, there is a unique rotation, as well as a unique reflection ($$det(\hat{R}) = -1$$) which will make $$\Sigma^2$$ zero. The SVD may, in this case, return either of the solutions.
3. **$$\{q_i\}$$ are collinear:** In this case, there are infinitely many rotations and reflections which will make $$\Sigma^2$$ zero.

In the coplanar case, one of the singular values of the matrix $$H$$ is zero. So, if $$X = VU^T$$ is a solution, so is $$X^\prime = V^\prime U^T$$, where $$V^\prime = [v_1, v_2, -v_3]$$. So, the correct solution may be obtained by checking whether or not the solution returned by the SVD is a rotation, and if the solution turns out to be a reflection, computing the other solution.

The points are collinear if, and only if, two of the three singular values of $$H$$ are equal.