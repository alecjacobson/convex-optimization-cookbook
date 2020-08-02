# Convex Optimization Cookbook

Unless otherwise stated, we will assume that quadratic coefficient matrices
(e.g., $Q$) are positive (semi-)definite so that $x^\top Q x$ is a convex function
and that the problem has a unique minimizer.

## Unconstrained 

If $Q \in \mathbb{R}^{n \times n}$ is positive definite then problems of the
form:

$$ \min_x \frac{1}{2} x^\top Q x + x^\top \ell $$

are solved by finding the solution to the linear system:

$$ Q x = - \ell $$

In MATLAB,

```
x = Q \ -l;
```


## Fixed value constraints

Let $I$ be a set of indices

$$ \min_x \frac{1}{2} x^\top Q x + x^\top \ell $$
