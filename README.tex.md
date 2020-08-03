# Convex Optimization Cookbook

Unless otherwise stated, we will assume that quadratic coefficient matrices
(e.g., $Q$) are symmetric positive (semi-)definite so that $x^\top Q x$ is a convex function
and that the problem has a unique minimizer.


## 1. Unconstrained quadratic vector optimization

If $Q \in \mathbb{R}^{n \times n}$ is positive definite then problems of the
form:

$$ \min_x \frac{1}{2} x^\top Q x + x^\top f + c $$

are solved by finding the solution to the linear system:

$$ Q x = - f$$

In MATLAB,

```matlab
x = Q \ -f;
```

## 2. Frobenius-norm matrix optimization

Define the squared Frobenius norm of a matrix as $\|M\|_\text{F}^2 = \sum_i \sum_j
x_{ij}^2$, then we may consider problems of the form:

$$ \min_{X \in \mathbb{R}^{n \times m}} \frac{1}{2} \|A X - B\|_\text{F}^2
$$

Using the property $\mathop{\text{trace}}(Y^\top Y) = \|Y\|_\text{F}^2$, we can expand
this to:

$$ \min_{X} \mathop{\text{trace}}(\frac{1}{2}  X^\top A^\top A X - X^\top A^\top
B) + c.$$

Letting $Q = A^\top A$ and $L = -A^\top B$, this can be written in a form
similar to the [unconstrained vector problem](#1-unconstrained-quadratic-vector-optimization):

$$ \min_{X} \mathop{\text{trace}}(\frac{1}{2}  X^\top Q X + X^\top F) + c.$$

this problem is _separable_ in the columns of $X$ and $L$ and solved by finding
the solution to the multi-column linear system:

$$ Q X = -L$$

In MATLAB,

```matlab
X = Q \ -F;
```

## 3. Fixed value constraints

Let $I \in [1,\dots,n]^k$ be a set of indices indicating elements of $x$ that
should be constrained to a particular known value. Then the problem:

$$
\min_x \frac{1}{2} x^\top Q x + x^\top f
$$

$$
\text{subject to: } x_i = y_i \quad \forall i \in I
$$

can be reduced to an [unconstrained problem](#1-unconstrained-quadratic-vector-optimization) by substitution.
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
have a simple [unconstrained
optimization](#1-unconstrained-quadratic-vector-optimization) over $x_U$:

$$ \min_{x_U} \frac{1}{2} x_U^\top Q_{UU} x_U + x_U^\top (f_U + Q_{UI} x_I)
+ c$$

In MATLAB, 

```matlab
U = setdiff(1:size(Q,1),I);
x = zeros(size(Q,1),1);
x(I) = y;
x(U) = Q(U,U) \ -(f(U) + Q(U,I) x(I));
```

## 4. Linear equality constraints

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

```matlab
n = size(Q,1);
neq = size(Aeq,1);
x = speye(n,n+neq) * ([Q Aeq';Aeq sparse(neq,neq)] \ [-f;beq];
```

or if you're not sure if the rows of `Aeq` are linearly independent:

```matlab
x = quadprog(Q,f,[],[],Aeq,beq);
```

## 5. Linear inequality constraints

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

```matlab
x = quadprog(Q,f,[Aleq;-Ageq],[bleq;-bgeq]);
```

## 6. Linear program

In the absence of a quadratic term (e.g., $x^\top Q x$) leaving just a linear
term, constraints of some form are required to pin down a finite solution. For
example, we could consider linear inequality constrained linear optimization as
a generic form of linear programming:

$$ \min_x  x^\top f,$$

$$ \text{subject to: } A_\text{leq} x \leq b_\text{leq}  $$

Whether a finite, unique solution exists depends on the particular values in
$f$, $A_\text{leq}$, and $b_\text{leq}$.

In MATLAB,

```matlab
x = linprog(f,Aleq,bleq);
```


## 7. Box or Bound constraints

A special case of [linear inequality
constraints](#4-linear-inequality-constraints) happens when
$A_\text{leq}$ is formed with rows of the identity matrix $I$, indicating simple
upper bound constraints on specific elements of $x$.


Letting $J \in [1,\dots,n]^{k}$ be the set of those variables and $U$ be the
complementary set, then this could be written as:


$$ \min_x \frac{1}{2} x^\top Q x + x^\top f,$$

$$ \text{subject to: } 
I_{k \times n} \begin{bmatrix}x_I \\ x_U\end{bmatrix} \leq b_\text{leq},
$$

where $I_{k \times n}$ is the rectangular identity matrix.

More often, we see this written as a per-element constant bound constraint with
upper and lower bounds. Suppose $J_\ell$ and $J_u$ are sets of indices for lower and
upper bound constraints respectively, then consider:

$$ \min_x \frac{1}{2} x^\top Q x + x^\top f,$$

$$ \text{subject to: } 
x_j \geq \ell_j \quad \forall i \in J_\ell \quad \text{ and } \quad
x_j \leq u_j \quad \forall j \in J_u
$$



In MATLAB,

```matlab
l = -inf(size(Q,1),1);
l(Jl) = bgeq;
u =  inf(size(Q,1),1);
u(Ju) = bleq;
x = quadprog(Q,f,[],[],[],[],l,u);
```



## 8. Upper-bound on absolute value

Placing an _upper_ bound on the absolute value of an element is a convex
constraint. So the problem 


$$ \min_x \frac{1}{2} x^\top Q x + x^\top f,$$

$$ \text{subject to: } 
|x_j| \leq  a_j \quad \forall j \in J
$$

can be simply expanded to a [bound constraint](#7-box-or-bound-constraints)
problem:


$$ \min_x \frac{1}{2} x^\top Q x + x^\top f,$$

$$ \text{subject to: } 
x_j \leq  a_j \quad \forall j \i J \quad \text{ and } \quad x_j \geq  -a_j.
$$

In MATLAB,

```matlab
l = -inf(size(Q,1),1);
l(J) = -a;
u =  inf(size(Q,1),1);
u(J) = a;
x = quadprog(Q,f,[],[],[],[],l,u);
```

## 9. Upper-bound of absolute value of linear expression

The per-element [upper-bound on absolute value](#8-upper-bound-on-absolute-value)
generalizes to linear expressions. Given a matrix $A_a \in \mathbb{R}^{na \times
n}$, then consider:

$$ \min_x \frac{1}{2} x^\top Q x + x^\top f,$$

$$ \text{subject to: } |A_a x | \leq  b_a $$

### 9.1. Linear inequality constraints

Expand the absolute value constraints into two sets of [linear inequality
constraints](#5-linear-inequality-constraints):

$$ \min_x \frac{1}{2} x^\top Q x + x^\top f,$$

$$ \text{subject to: } A_a x  \leq  b_a  \quad \text{ and } \quad A_a x \geq
-b_a,$$

the greater-than-or-equals constraints of which can in turn be converted to
less-than-or-equals constraints as [above](#5-linear-inequality-constraints):

$$ \min_x \frac{1}{2} x^\top Q x + x^\top f,$$

$$ \text{subject to: } 
\begin{bmatrix} A_a \\ -A_a \end{bmatrix} x  \leq  \begin{bmatrix} b_a \\ b_a \end{bmatrix},$$

In MATLAB,

```matlab
x = quadprog(Q,f,[Aa;-Aa],[ba;ba]);
```

### 9.2. Auxiliary variables

Introduce an auxiliary set of variables $y \in \mathbb{R}^na$, then introduce a
[linear equality constraint](#5-linear-equality-constraints) tying $y$ to $A_a x$
and apply [upper-bound absolute value
constraints](#8-upper-bound-on-absolute-value) on $y$:

$$ \min_{x,y} \frac{1}{2} x^\top Q x + x^\top f,$$

$$ \text{subject to: } 
A_a x - y = 0
$$

$$ \text{and: } 
y \leq  b_a \quad \text{ and } \quad y \geq  -b_a.
$$

In MATLAB,

```matlab
n = size(Q,1);
na = size(Aa,1);
x = speye(n,n+na) * quadprog( ...
  blkdiag(Q,sparse(na,na)),[f;zeros(na,1)], ...
  [],[],[Aa -speye(na,na)],zeros(na,1), ...
  [-inf(n,1);-ba],[inf(n,1);ba]);
```

## 10. L1 minimization 

The absolute value may appear in the objective function such as with minimizing
the $L_1$ norm of a linear expression (sum of absolute values):

$$ \min_x \| A x + b \|_1 $$


### 10.1. Linear inequalities

Introduce the auxiliary vector variable $t$:

$$ \min_{x,t} t^\top \mathbf{1} $$

$$\text{subject to: } |A x - b| \leq t $$

which is a form of [absolute value constrained
optimization](#9-upper-bound-of-absolute-value-of-linear-expression), then solved,
for example, by further transforming to:

$$ \min_{x,t} t^\top \mathbf{1} $$

$$\text{subject to: } A x - b \leq t \quad \text{ and } A x - b \geq -t,$$

In turn, this can be converted into pure less-than-or-equals constraints:

$$ \min_{x,t} [x^\top t^\top] \begin{bmatrix}\mathbf{0} \\ \mathbf{1}
\end{bmatrix}$$

$$\text{subject to: } 
\begin{bmatrix}
A & -I \\
-A & -I 
\end{bmatrix}
\begin{bmatrix}
x \\ 
t
\end{bmatrix}
= 
\begin{bmatrix}
b \\ 
-b
\end{bmatrix}
$$

In MATLAB,

```matlab
n = size(A,2);
na = size(A,1);
I = speye(na,na);
x = speye(n,n+na) * linprog([zeros(n,1);ones(na,1)],[A -I;-A -I],[b;-b]);
```

### 10.2. Variable splitting

Introduce the vector variables $u$,$v$ so that the element-wise equalities hold:

$$ |Ax - b| = u - v \quad \text{ and } u = max(Ax-b,0) \text{ and } v =
max(Ax-b,0)$$

Then the problem becomes:

$$\min_{x,u,v} u^\top \mathbf{1} + v^\top \mathbf{1}$$
$$\text{subject to: } A x - b = u - v$$
$$\text{and: } u, \geq 0 $$

This can be expanded in matrix form to:

$$\min_{x,u,v} [x^\top u^\top v^\top] \begin{bmatrix}\mathbf{0}\\ \mathbf{1} \\
\mathbf{1} \end{bmatrix}$$

$$\text{subject to: } 
\begin{bmatrix}
A & -I & I 
\end{bmatrix}
\begin{bmatrix}
x \\ u \\ v
\end{bmatrix}
= 
b.$$

$$\text{and: } 
\begin{bmatrix}
x \\ u \\ v
\end{bmatrix}
\geq
\begin{bmatrix}
-\mathbf{\infty} \\
\mathbf{0} \\
\mathbf{0} 
\end{bmatrix}.
$$

In MATLAB,

```matlab
n = size(A,2);
na = size(A,1);
I = speye(na,na);
x = speye(n,n+2*na) * ...
  linprog([zeros(n,1);ones(2*na,1)],[],[],[A -I I],b,[-inf(n,1);zeros(2*na,1)]);
```

## 11. Convex hull constraint

Consider the problem where the solution $x \in \mathbb{R}^n$ is required to lie in the convex
hull defined by points $b_1,b_2,\dots,...,b_m \in \mathbb{R}^n$:

$$ \min_x \frac{1}{2} x^\top Q x + x^\top f,$$

$$\text{subject to: } x \in \text{ConvexHull}(b_1,b_2,\dots,...,b_m)$$

A point $x$ is in the convex hull of $b_1,b_2,\dots,...,b_m$ if and only if
there exist a set of positive, unity partitioning weights $w$ such that:

$$ B w = x,$$

where we collect $b_1,b_2,\dots,...,b_m$ in the columns of $B \in \mathbb{R}^{n
\times m}$. 

(As a consequence, $w \leq 1$).

Introducing these weights as auxiliary variables, we can express the problem as:


$$ \min_{x,w} \frac{1}{2} x^\top Q x + x^\top f,$$

$$
\text{subject to:} 
\begin{bmatrix} B \\ \mathbf{1}^\top \end{bmatrix} w =
\begin{bmatrix} x \\ 1 \end{bmatrix}
$$

$$\text{and: } w \geq 0$$

In MATLAB,

```matlab
n = size(Q,1);
m = size(B,2);
x = speye(n,n+m) * quadprog( ...
  blkdiag(Q,sparse(m,m)),[f;zeros(m,1)], ...
  [],[], ...
  [-speye(n,n) B;zeros(1,n) ones(1,m)],[zeros(n,1);1], ...
  [-inf(n,1);zeros(m,1)]);
```

## 12. L1 upper bound

An $L_1$ term can also appear in the constraints with an upper bound. 

$$ \min_{x} \frac{1}{2} x^\top Q x + x^\top f,$$

$$ \text{subject to: } 
| x |_1 \leq b
$$


### 12.1. Auxiliary variables

Introduce a set of auxiliary variables $y$ and require that:

$$ |A x - b| \leq y \quad \text{ and } \quad \mathbf{1}^\top y = b $$

This can be incorporated into the optimization, for example, using two linear
sets of inequalities:

$$ \min_{x,y} \frac{1}{2} x^\top Q x + x^\top f,$$

$$ \text{subject to: } \mathbf{1}^\top y = b $$
$$ \text{and: } Ax - b \leq y \quad \text{ and } \quad Ax - b \geq -y$$

In turn, this can be converted into pure less-than-or-equals constraints:

$$ \min_{x,y} \frac{1}{2} x^\top Q x + x^\top f,$$

$$ \text{subject to: } \mathbf{1}^\top y = b $$
$$ \text{and: } 
\begin{bmatrix}
 A & -I \\
-A & -I 
\end{bmatrix}
\begin{bmatrix}
x \\
y
\end{bmatrix}
=
\begin{bmatrix}
b \\
-b
\end{bmatrix}
$$

In MATLAB,

```matlab
n = size(Q,1);
na = size(A,1);
I = speye(na,na);
x = speye(n,n+na) * quadprog( ...
  blkdiag(Q,sparse(na,na)),[f;zeros(na,1)], ...
  [A -I;-A I],[b;-b], ...
  [zeros(1,n) ones(1,na)], b);
```

### 12.2. Convex hull constraint

Geometrically, this constraint is requiring that $x$ lie within in the convex
hull of $b_1$-$L_1$-norm ball, which is also the [convex
hull](convex-hull-constraint) of the points in the columns of $B := b [I -I]$.

Introducing an auxiliary weight vectors $w^+,w^-$, the problem can be transformed into:

$$ \min_{x,w^+,w^-} \frac{1}{2} x^\top Q x + x^\top f,$$

$$
\text{subject to:} 
\begin{bmatrix} b I & -b I \\ \mathbf{1}^\top & \mathbf{1}^\top \end{bmatrix} 
\begin{bmatrix} w^+ \\ w^- \end{bmatrix}
=
\begin{bmatrix} x \\ 1 \end{bmatrix}
$$

$$\text{and: } w^+,w^- \geq 0$$

In MATLAB,

```matlab
n = size(Q,1);
m = size(B,2);
x = speye(n,n+m) * quadprog( ...
  blkdiag(Q,sparse(2*n,2*n)),[f;zeros(2*n,1)], ...
  [],[], ...
  [-speye(n,n) b*speye(n,n) -b*speye(n,n);zeros(1,n) ones(1,2*n)],[zeros(n,1);1], ...
  [-inf(n,1);zeros(2*n,1)]);
```

## L2,1 norm
The $L_{2,1}$ norm is defined to be the sum of the Euclidean norms
of a matrix's columns $\|M|_{2,1} = \sum_j \|M_j\|_2 = \sum_j \sqrt{\sum_i
(m_{ij})^2}$. Consider the matrix problem:

$$ \min_X |A X - B|_{2,1} $$

(If $X$ has only one column, this reduces to [L1
minimization](#10-l1-minimization).)




See also: [MOSEK Modeling Cookbook](https://docs.mosek.com/MOSEKModelingCookbook-letter.pdf), [YALMIP](https://yalmip.github.io/)
