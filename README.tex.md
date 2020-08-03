# Convex Optimization Cookbook

Unless otherwise stated, we will assume that quadratic coefficient matrices
(e.g., $Q$) are symmetric positive (semi-)definite so that $x^\top Q x$ is a convex function
and that the problem has a unique minimizer.


## Unconstrained quadratic vector optimization

If $Q \in \mathbb{R}^{n \times n}$ is positive definite then problems of the
form:

$$ \min_x \frac{1}{2} x^\top Q x + x^\top f + c $$

are solved by finding the solution to the linear system:

$$ Q x = - f$$

In MATLAB,

```
x = Q \ -f;
```

## Frobenius-norm matrix optimization

Define the squared Frobenius norm of a matrix as $\|M\|_\text{F}^2 = \sum_i \sum_j
x_{ij}^2$, then we may consider problems of the form:

$$ \min_{X \in \mathbb{R}^{n \times m}} \frac{1}{2} \|A X - B\|_\text{F}^2
$$

Using the property $\mathop{\text{trace}}(Y^\top Y) = \|Y\|_\text{F}^2$, we can expand
this to:

$$ \min_{X} \mathop{\text{trace}}(\frac{1}{2}  X^\top A^\top A X - X^\top A^\top
B) + c.$$

Letting $Q = A^\top A$ and $L = -A^\top B$, this can be written in a form
similar to the [unconstrained vector problem](#unconstrained-quadratic-vector-optimization):

$$ \min_{X} \mathop{\text{trace}}(\frac{1}{2}  X^\top Q X + X^\top F) + c.$$

this problem is _separable_ in the columns of $X$ and $L$ and solved by finding
the solution to the multi-column linear system:

$$ Q X = -L$$

In MATLAB,

```
X = Q \ -F;
```

## Fixed value constraints

Let $I \in [1,\dots,n]^k$ be a set of indices indicating elements of $x$ that
should be constrained to a particular known value. Then the problem:

$$
\min_x \frac{1}{2} x^\top Q x + x^\top f
$$

$$
\text{subject to: } x_i = y_i \quad \forall i \in I
$$

can be reduced to an [unconstrained problem](#unconstrained-quadratic-vector-optimization) by substitution.
Introduce the set $U$ to be all indices _not_ in $I$, then we can first re-order
terms above according to $I$ and $U$:

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
f_U \\
f_I
\end{bmatrix}
$$

$$
\text{subject to } x_I = y
$$

where, for example, $Q_{UI} \in \mathbb{R}^{n-k \times k}$ is the submatrix of
$Q$ extracted by slicing the rows by the set $U$ and the columns by the set $I$.

Substituting the constraint $x_I = y$ into the objective then collecting terms
that are quadratic, linear, and constant in the remaining unknowns $x_U$ we
have a simple [unconstrained optimization](#unconstrained-quadratic-vector-optimization) over $x_U$:

$$ \min_{x_U} \frac{1}{2} x_U^\top Q_{UU} x_U + x_U^\top (f_U + Q_{UI} x_I)
+ c$$

In MATLAB, 

```
U = setdiff(1:size(Q,1),I);
x = zeros(size(Q,1),1);
x(I) = y;
x(U) = Q(U,U) \ -(f(U) + Q(U,I) x(I));
```

## Linear equality constraints

Given a matrix $A_\text{eq} \in \R^{n_\text{eq} \times n}$ with linearly
independent rows, consider the problem:

$$ \min_x \frac{1}{2} x^\top Q x + x^\top f,$$

$$ \text{subject to: } A_\text{eq} x = b_\text{eq}.$$

Following the [Lagrange Multiplier
Method](https://en.wikipedia.org/wiki/Lagrange_multiplier), by introducing a
vector of auxiliary variables $\lambda \in \mathbb{R}^n_eq$, the solution will
coincide with the augmented max-min problem:

$$
\max_\lambda \min_x \frac{1}{2} x^\top Q x + x^\top f + \lambda^\top
(A_\text{eq} x - b_\text{eq}).
$$

The [KKT
theorem](https://en.wikipedia.org/wiki/Karush%E2%80%93Kuhn%E2%80%93Tucker_conditions)
states that the solution is given when _all_ partial derivatives of this
quadratic function are zero, or in matrix form, at the solution to the linear
system:

$$
\begin{bmatrix}
Q & A_\text{eq}^\top \\
A_\text{eq} & 0
\end{bmatrix}
\begin{bmatrix}
x \\
\lambda
\end{bmatrix}
 = 
\begin{bmatrix}
-f \\
b_\text{eq}
\end{bmatrix}.
$$

In MATLAB,

```
x = speye(n,n+neq) * ([Q Aeq';Aeq sparse(neq,neq)] \ [-f;beq];
```

or if you're not sure if the rows of `Aeq` are linearly independent:

```
x = quadprog(Q,f,[],[],Aeq,beq);
```

## Linear inequality constraints

Given a matrix $A_\text{leq} \in \R^{n_\text{leq} \times n}$ and 
a matrix $A_\text{geq} \in \R^{n_\text{geq} \times n}$, consider

$$ \min_x \frac{1}{2} x^\top Q x + x^\top f,$$

$$ \text{subject to: } A_\text{leq} x \leq b_\text{leq} 
\text{ and } A_\text{geq} x \geq b_\text{geq}.$$

Multiplying both sides of $A_\text{geq} x \geq b_\text{geq}$ by $-1$ we can
convert all constraints to less-than-or-equals inequalities:

$$ \min_x \frac{1}{2} x^\top Q x + x^\top f,$$

$$ \text{subject to: } 
\begin{bmatrix}
A_\text{leq}  \\
-A_\text{geq} 
\end{bmatrix}
x
\leq
\begin{bmatrix}
b_\text{leq} \\
-b_\text{geq} \\
\end{bmatrix}.$$

In MATLAB,

```
x = quadprog(Q,f,[Aleq;-Ageq],[bleq;-bgeq]);
```


## Box or Bound constraints

A special case of [linear inequality
constraints](#linear-inequality-constraints) happens when
$A_\text{leq}$ is formed with rows of the identity matrix $I$, indicating simple
upper bound constraints on specific elements of $x$.


Letting $J \in [1,\dots,n]^{k}$ be the set of those variables and $U$ be the
complementary set, then this could be written as:


$$ \min_x \frac{1}{2} x^\top Q x + x^\top f,$$

$$ \text{subject to: } 
I_{k \times n} \begin{bmatrix}x_I \\ x_U\end{matrix} \leq b_\text{leq}
$$

More often, we see this written as a per-element constant bound constraint with
upper and lower bounds:

$$ \min_x \frac{1}{2} x^\top Q x + x^\top f,$$

$$ \text{subject to: } 
x_i \geq \ell^i \quad \forall i \in I \text{ and }
x_j \leq u^j \quad \forall j \in J
$$



In MATLAB,

```
l = -inf(size(Q,1),1);
l(I) = bgeq;
u =  inf(size(Q,1),1);
u(I) = bleq;
x = quadprog(Q,f,[],[],[],[],l,u);
```
