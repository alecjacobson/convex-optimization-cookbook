# Convex Optimization Cookbook

Unless otherwise stated, we will assume that quadratic coefficient matrices
(e.g., $Q$) are symmetric positive (semi-)definite so that $x^\top Q x$ is a convex function
and that the problem has a unique minimizer.


## Unconstrained quadratic vector optimization

If $Q \in \mathbb{R}^{n \times n}$ is positive definite then problems of the
form:

$$ \min_x \frac{1}{2} x^\top Q x + x^\top \ell + c $$

are solved by finding the solution to the linear system:

$$ Q x = - \ell $$

In MATLAB,

```
x = Q \ -l;
```

## Frobenius-norm matrix optimization

Define the squared Frobenius norm of a matrix as $\|M\|_F^2 = \sum_i \sum_j
x_{ij}^2$, then we may consider problems of the form:

$$ \min_{X \in \mathbb{R}^{n \times m}} 


## Fixed value constraints

Let $I \in [1,\dots,n]^k$ be a set of indices indicating elements of $x$ that
should be constrained to a particular known value. Then the problem:

$$
\min_x \frac{1}{2} x^\top Q x + x^\top \ell
$$

$$
\text{subject to: } x_i = y_i \forall i \in I
$$

can be reduced to an [unconstrained problem](#unconstrained) by substitution.
Introduce the set $U$ to be all indices _not_ in $I$, then we can first re-order
terms above to collect $I$ and $U$ sets:

$$\min_x \frac{1}{2} [x_U^\top x_I^\top] 
\begin{bmatrix}
Q_{UU} & Q_{UI} \\
Q_{IU} & Q_{II} \\
\end{bmatrix}
\begin{bmatrix}
x_U \\
x_I 
\end{bmatrix}
+
[x_U^\top x_I^\top] 
\begin{bmatrix}
\ell_U \\
\ell_I
\end{bmatrix}
$$

$$
\text{subject to } x_I = y
$$

Substituting the constraint $x_I = y$ into the objective then collecting terms
that are quadratic, linear, and constant in the remaining unknowns $x_U$ we
have a simple [unconstrained optimization](#unconstrained) over $x_U$:

$$ \min_{x_U} \frac{1}{2} x_U^\top Q_{UU} x_U + x_U^\top (\ell_U + Q_{UI} x_I)
+ c$$

In MATLAB, 

```
U = setdiff(1:size(Q,1),I);
x = zeros(size(Q,1),1);
x(I) = y;
x(U) = Q(U,U) \ -(l(U) + Q(U,I) x(I));
```

