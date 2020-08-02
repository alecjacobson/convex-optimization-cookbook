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

Let $I \in [1,\dots,n]^m$ be a set of indices indicating elements of $x$ that
should be constrained to a particular known value. Then the problem:

$$ \min_x \frac{1}{2} x^\top Q x + x^\top \ell \\
\text{subject to:} x_i = y_i \forall i \in I
$$

can be reduced to an [unconstrained problem](#unconstrained) by substitution.
Introduce the set $J$ to be all indices _not_ in $I$, then we can first re-order
terms above to collect $I$ and $J$ sets:

$$ \min_x \frac{1}{2} [x_J^\top x_I] 
\begin{bmatrix}
Q_{II}
\end{bmatrix}
[x(J) x(I)] + x^\top \ell \\
\text{subject to:} x(I) = y
$$
