# Convex Optimization Cookbook

Unless otherwise stated, we will assume that quadratic coefficient matrices
(e.g., $Q$) are symmetric positive (semi-)definite so that $x^\top Q x$ is a convex function
and that the problem has a unique minimizer.

## Unconstrained 

If $Q \in \mathbb{R}^{n \times n}$ is positive definite then problems of the
form:

$$ \min_x \frac{1}{2} x^\top Q x + x^\top \ell + c $$

are solved by finding the solution to the linear system:

$$ Q x = - \ell $$

In MATLAB,

```
x = Q \ -l;
```


## Fixed value constraints

Let $I \in [1,\dots,n]^m$ be a set of indices indicating elements of $x$ that
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
+ \cancelto{x_I^\top (Q_{II} x_I + \ell_I)}{\text{constant}}$$

