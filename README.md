# Convex Optimization Cookbook

The goal of this cookbook is to serve as a reference for various convex optimization problems (with a bias toward computer graphics and geometry processing). 

Unless otherwise stated, we will assume that quadratic coefficient matrices (e.g., $Q$) are symmetric and positive (semi-)definite so that $x^\top Q x$ is a convex function and that the stated problem has a unique minimizer.

## 1. Unconstrained quadratic vector optimization

If $Q \in \mathbb{R}^{n \times n}$ is (symmetric) positive definite then problems of the form:

$$ \min_x \frac{1}{2} x^\top Q x + x^\top f + c $$

are solved by finding the solution to the linear system:

$$ Q x = - f$$

In MATLAB,

```matlab
x = Q \ -f;
```

## 2. Frobenius-norm matrix optimization

Define the squared Frobenius norm of a matrix as $\lVert X \rVert_\text{F}^2 = \sum_i \sum_j x_{ij}^2$, then we may consider problems of the form:

$$ \min_{X \in \mathbb{R}^{n \times m}} \frac{1}{2} \lVert A X - B \rVert_\text{F}^2
$$

Using the property $\mathop{\text{trace}}(Y^\top Y) = \lVert Y \rVert_\text{F}^2$, we can expand this to:

$$ \min_{X} \mathop{\text{trace}}(\frac{1}{2}  X^\top A^\top A X - X^\top A^\top
B) + c.$$

Letting $Q = A^\top A$ and $F = -A^\top B$, this can be written in a form similar to the [unconstrained vector problem](#1-unconstrained-quadratic-vector-optimization):

$$ \min_{X} \mathop{\text{trace}}(\frac{1}{2}  X^\top Q X + X^\top F) + c.$$

this problem is _separable_ in the columns of $X$ and $F$ and solved by finding the solution to the multi-column linear system:

$$ Q X = -F$$

In MATLAB,

```matlab
X = Q \ -F;
```

### 2.1 Frobenius-norm matrix optimization via second-order cone

Certain second-order cone problems don't provide an explicit interface for adding a quadratic objective term. Therefore it's useful to be able to convert a simple squared Frobenius-norm minimization problem into a second-order cone problem (even though, if this is the only term, then it's usually overkill).

We first introduce a new matrix variable $T = A X - B$:

$$ \min_{X \in \mathbb{R}^{n \times m},\  T \in \mathbb{R}^{q \times n}} \frac{1}{2} \lVert T \rVert_\text{F}^2
$$

$$ \text{subject to: } T = A X - B $$

Then introduce a scalar variable $y$ which we'll used to bound the norm of $T$ from above and then minimize its value:


$$ \min_{X \in \mathbb{R}^{n \times m},\  T \in \mathbb{R}^{q \times n},\  y \in \mathbb{R}} \quad y
$$

$$ \text{subject to: } T = A X - B $$

$$ \text{and } 2 y \ge \lVert T \rVert_\text{F} $$

This last constraint is the (quadratic) cone constraint.

In Mosek:

```matlab
  nb = size(B,2);
  na = size(A,1);
  n = size(A,2);
  prob = struct();
  prob.c = [zeros(n*nb + na*nb,1);1];
  prob.a = [kroneye(A,nb) -speye(na*nb,na*nb) sparse(na*nb,1)];
  prob.blc = reshape(B',[],1);
  prob.buc = prob.blc;
  [~, res] = mosekopt('symbcon echo(0)');
  prob.cones.type = res.symbcon.MSK_CT_QUAD;
  prob.cones.sub = [(n*nb+na*nb+1) (n*nb+(1:na*nb))];
  prob.cones.subptr = 1;
  [r,res]=mosekopt('minimize echo(0)',prob);
  X = reshape(res.sol.itr.xx(1:n*nb),n,nb);
```



## 3. Fixed value constraints

Let $I \in [1,\dots,n]^k$ be a set of indices indicating elements of $x$ that
should be constrained to a particular known value. Then the problem:

$$ \min_x \frac{1}{2} x^\top Q x + x^\top f $$

$$
\text{subject to: } x_i = y_i \quad \forall i \in I
$$

can be reduced to an [unconstrained problem](#1-unconstrained-quadratic-vector-optimization) by substitution. Introduce the set $U$ to be all indices _not_ in $I$, then we can first re-order terms above according to $I$ and $U$:

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

where, for example, $Q_{UI} \in \mathbb{R}^{n-k \times k}$ is the submatrix of $Q$ extracted by slicing the rows by the set $U$ and the columns by the set $I$.

Substituting the constraint $x_I = y$ into the objective then collecting terms that are quadratic, linear, and constant in the remaining unknowns $x_U$ we have a simple [unconstrained optimization](#1-unconstrained-quadratic-vector-optimization) over $x_U$:

$$\min_{x_U} \frac{1}{2} x_U^\top Q_{UU} x_U + x_U^\top (f_U + Q_{UI} x_I) + c$$

In MATLAB, 

```matlab
U = setdiff(1:size(Q,1),I);
x = zeros(size(Q,1),1);
x(I) = y;
x(U) = Q(U,U) \ -(f(U) + Q(U,I) * x(I));
```

> **How to build $Q_{UI}$ etc.?**
>
> In Matlab, python, and Eigen+libigl, one can build the (often large, sparse)
> matrix `Q` and then "slice" it with a list of indices `U` and `I`.
>
> In some settings
> ([pytorch](https://discuss.pytorch.org/t/column-row-slicing-a-torch-sparse-tensor/19130)?),
> slicing is not available, so an alternative and algebraically equivalent
> approach is to build for the index set $I$ a sparse selection matrix 
> $S_I \in \mathbb{R}^{k \times n}$ such that:
>
> $$(S_I)_{ij} = 1 \iff I_i = j$$
>
> This way $x_I = S_I x$. Follow the same construction for 
> $S_U \in \mathbb{R}^{n-k \times n}$, _mutatis mutandis_. Then you have 
> $Q_{UI} = S_U Q S_I^\top$ and so on.
> 
> In MATLAB, 
> 
> ```matlab
> U = setdiff(1:size(Q,1),I);
> S_I = sparse(1:numel(I),I,1,numel(I),size(Q,1));
> S_U = sparse(1:numel(U),U,1,numel(U),size(Q,1));
> Q_UU = S_U * Q * S_U';
> Q_UI = S_U * Q * S_I';
> x = zeros(size(Q,1),1);
> x(I) = y;
> x(U) = Q_UU \ -(f(U) + Q_UI * x(I));
> ```


## 4. Linear equality constraints

Given a matrix $A_\text{eq} \in \mathbb{R}^{n_\text{eq} \times n}$ with linearly independent rows, consider the problem:

$$ \min_x \frac{1}{2} x^\top Q x + x^\top f,$$

$$ \text{subject to: } A_\text{eq} x = b_\text{eq}.$$

Following the [Lagrange Multiplier Method](https://en.wikipedia.org/wiki/Lagrange_multiplier), by introducing a vector of auxiliary variables $\lambda \in \mathbb{R}^n_eq$, the solution will coincide with the augmented max-min problem:

$$
\max_\lambda \min_x \frac{1}{2} x^\top Q x + x^\top f + \lambda^\top
(A_\text{eq} x - b_\text{eq}).
$$

The [KKT theorem](https://en.wikipedia.org/wiki/Karush%E2%80%93Kuhn%E2%80%93Tucker_conditions) states that the solution is given when _all_ partial derivatives of this quadratic function are zero, or in matrix form, at the solution to the linear system:

$$\begin{bmatrix}
Q & A_\text{eq}^\top \\
A_\text{eq} & 0
\end{bmatrix}
\begin{bmatrix} x \\ \lambda \end{bmatrix} = 
\begin{bmatrix}
-f \\
b_\text{eq}
\end{bmatrix}. $$

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

Given a matrix $A_\text{leq} \in \mathbb{R}^{n_\text{leq} \times n}$ and a matrix $A_\text{geq} \in \mathbb{R}^{n_\text{geq} \times n}$, consider

$$ \min_x \frac{1}{2} x^\top Q x + x^\top f,$$

$$ \text{subject to: } A_\text{leq} x \leq b_\text{leq} 
\text{ and } A_\text{geq} x \geq b_\text{geq}.$$

Multiplying both sides of $A_\text{geq} x \geq b_\text{geq}$ by $-1$ we can convert all constraints to less-than-or-equals inequalities:

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

In the absence of a quadratic term (e.g., $x^\top Q x$) leaving just a linear term, constraints of some form are required to pin down a finite solution. For example, we could consider linear inequality constrained linear optimization as a generic form of linear programming:

$$ \min_x  x^\top f,$$

$$ \text{subject to: } A_\text{leq} x \leq b_\text{leq}  $$

Whether a finite, unique solution exists depends on the particular values in $f$, $A_\text{leq}$, and $b_\text{leq}$.

In MATLAB,

```matlab
x = linprog(f,Aleq,bleq);
```


## 7. Box or Bound constraints

A special case of [linear inequality constraints](#4-linear-inequality-constraints) happens when $A_\text{leq}$ is formed with rows of the identity matrix $I$, indicating simple upper bound constraints on specific elements of $x$.


Letting $J \in [1,\dots,n]^{k}$ be the set of those variables and $U$ be the complementary set, then this could be written as:


$$ \min_x \frac{1}{2} x^\top Q x + x^\top f,$$

$$ \text{subject to: } 
I_{k \times n} \begin{bmatrix}x_I \\ x_U\end{bmatrix} \leq b_\text{leq},
$$

where $I_{k \times n}$ is the rectangular identity matrix.

More often, we see this written as a per-element constant bound constraint with upper and lower bounds. Suppose $J_\ell$ and $J_u$ are sets of indices for lower and upper bound constraints respectively, then consider:

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

Placing an _upper_ bound on the absolute value of an element is a convex constraint. So the problem 


$$ \min_x \frac{1}{2} x^\top Q x + x^\top f,$$

$$ \text{subject to: } 
|x_j| \leq  a_j \quad \forall j \in J
$$

can be simply expanded to a [bound constraint](#7-box-or-bound-constraints)
problem:


$$ \min_x \frac{1}{2} x^\top Q x + x^\top f,$$

$$ \text{subject to: } 
x_j \leq  a_j \quad \forall j \in J \quad \text{ and } \quad x_j \geq  -a_j.
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

The per-element [upper-bound on absolute value](#8-upper-bound-on-absolute-value) generalizes to linear expressions. Given a matrix $A_a \in \mathbb{R}^{na \times n}$, then consider:

$$ \min_x \frac{1}{2} x^\top Q x + x^\top f,$$

$$ \text{subject to: } |A_a x | \leq  b_a $$

### 9.1. Linear inequality constraints

Expand the absolute value constraints into two sets of [linear inequality constraints](#5-linear-inequality-constraints):

$$ \min_x \frac{1}{2} x^\top Q x + x^\top f,$$

$$ \text{subject to: } A_a x  \leq  b_a  \quad \text{ and } \quad A_a x \geq
-b_a,$$

the greater-than-or-equals constraints of which can in turn be converted to less-than-or-equals constraints as [above](#5-linear-inequality-constraints):

$$ \min_x \frac{1}{2} x^\top Q x + x^\top f,$$

$$ \text{subject to: } 
\begin{bmatrix} A_a \\ -A_a \end{bmatrix} x  \leq  \begin{bmatrix} b_a \\ b_a \end{bmatrix},$$

In MATLAB,

```matlab
x = quadprog(Q,f,[Aa;-Aa],[ba;ba]);
```

### 9.2. Auxiliary variables

Introduce an auxiliary set of variables $y \in \mathbb{R}^na$, then introduce a [linear equality constraint](#5-linear-equality-constraints) tying $y$ to $A_a x$ and apply [upper-bound absolute value constraints](#8-upper-bound-on-absolute-value) on $y$:

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

The absolute value may appear in the objective function such as with minimizing the $L_1$ norm of a linear expression (sum of absolute values):

$$ \min_x \lVert  A x - b  \rVert_1 $$


### 10.1. Linear inequalities

Introduce the auxiliary vector variable $t$:

$$ \min_{x,t} t^\top \mathbf{1} $$

$$\text{subject to: } |A x - b| \leq t $$

which is a form of [absolute value constrained optimization](#9-upper-bound-of-absolute-value-of-linear-expression), then solved, for example, by further transforming to:

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
\leq
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

Introduce the vector variables $u$, $v$ so that the element-wise equalities hold:

$$ |Ax - b| = u - v \quad \text{ and } u = max(Ax-b,0) \text{ and } v =
max(b-Ax,0)$$

Then the problem becomes:

$$\min_{x,u,v} u^\top \mathbf{1} + v^\top \mathbf{1}$$
$$\text{subject to: } A x - b = u - v$$
$$\text{and: } u,v \geq 0 $$

This can be expanded in matrix form to:

$$\min_{x,u,v} [x^\top u^\top v^\top] \begin{bmatrix}\mathbf{0}\\ \mathbf{1} \\
\mathbf{1} \end{bmatrix}$$

$$\text{subject to: }  \begin{bmatrix} A & -I & I  \end{bmatrix} \begin{bmatrix} x \\ u \\ v \end{bmatrix} =  b.$$

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

Consider the problem where the solution $x \in \mathbb{R}^n$ is required to lie in the convex hull defined by points $b_1,b_2,\dots,...,b_m \in \mathbb{R}^n$:

$$ \min_x \frac{1}{2} x^\top Q x + x^\top f,$$

$$\text{subject to: } x \in \text{ConvexHull}(b_1,b_2,\dots,...,b_m)$$

A point $x$ is in the convex hull of $b_1,b_2,\dots,...,b_m$ if and only if there exist a set of positive, unity partitioning weights $w$ such that:

$$ B w = x,$$

where we collect $b_1,b_2,\dots,...,b_m$ in the columns of $B \in \mathbb{R}^{n \times m}$. 

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

An $L_1$ term can also appear in the constraints with an upper bound.  This form also includes the [LASSO](https://en.wikipedia.org/wiki/Lasso_(statistics)) method from statistics.


$$ \min_{x} \frac{1}{2} x^\top Q x + x^\top f,$$

$$ \text{subject to: } 
\lVert  x  \rVert_1 \leq c
$$

This problem corresponds to $A = I, b = 0$ of a more general problem where affine L1 upper bounds appear. 

$$\min_{x} \frac{1}{2} x^\top Q x + x^\top f,$$

$$ \text{subject to: } 
\lVert  A x - b \rVert_1 \leq c
$$


### 12.1. Auxiliary variables

Introduce a set of auxiliary variables $y$ and require that:

$$ |A x - b| \leq y \quad \text{ and } \quad \mathbf{1}^\top y \leq c $$

This can be incorporated into the optimization, for example, using two linear sets of inequalities:

$$ \min_{x,y} \frac{1}{2} x^\top Q x + x^\top f,$$

$$ \text{subject to: } \mathbf{1}^\top y = c $$
$$ \text{and: } Ax - b \leq y \quad \text{ and } \quad Ax - b \geq -y $$ 

In turn, this can be converted into pure less-than-or-equals constraints:

\begin{align}
\min_{x,y} \;& \frac{1}{2} x^\top Q x + x^\top f,\\
\text{subject to: } & \mathbf{1}^\top y = c \\
\text{and: }  &
\begin{bmatrix}
 A & -I \\
-A & -I 
\end{bmatrix}
\begin{bmatrix}
x \\
y
\end{bmatrix}
\leq
\begin{bmatrix}
b \\
-b
\end{bmatrix} 
\end{align}

In MATLAB,

```matlab
n = size(Q,1);
na = size(A,1);
I = speye(na,na);
x = speye(n,n+na) * quadprog( ...
  blkdiag(Q,sparse(na,na)),[f;zeros(na,1)], ...
  [A -I;-A -I],[b;-b], ...
  [zeros(1,n) ones(1,na)], c);
```

### 12.2. Convex hull constraint

Geometrically, this constraint is requiring that $x$ lie within in the convex hull of $b_1$ - $L_1$-norm ball, which is also the [convex hull](convex-hull-constraint) of the points in the columns of $C := c [I -I]$.

Introducing an auxiliary weight vectors $w^+,w^-$, the problem can be transformed into:

$$ \min_{x,w^+,w^-} \frac{1}{2} x^\top Q x + x^\top f,$$

$$
\text{subject to:} 
\begin{bmatrix} c I & -c I \\ \mathbf{1}^\top & \mathbf{1}^\top \end{bmatrix} 
\begin{bmatrix} w^+ \\ w^- \end{bmatrix} = \begin{bmatrix} x \\ 1 \end{bmatrix}
$$

$$\text{and: } w^+,w^- \geq 0$$

In MATLAB,

```matlab
n = size(Q,1);
x = speye(n,n+2*n) * quadprog( ...
  blkdiag(Q,sparse(2*n,2*n)),[f;zeros(2*n,1)], ...
  [],[], ...
  [-speye(n,n) c*speye(n,n) -c*speye(n,n);zeros(1,n) ones(1,2*n)],[zeros(n,1);1], ...
  [-inf(n,1);zeros(2*n,1)]);
```

## 13. L2,1 norm

The $L_{2,1}$ norm is defined to be the sum of the Euclidean norms of a matrix's columns $\lVert M \rVert_{2,1} = \sum_j \lVert M_j \rVert = \sum_j \sqrt{\sum_i (m_{ij})^2}$. Consider the matrix problem:

$$ \min_X \lVert A X - B \rVert_{2,1} $$

(If $A$ has only one row, this reduces to [L1 minimization](#10-l1-minimization).)

First, let us move the affine expression in a constraint, leaving the $L_{2,1}$ norm of a matrix of auxiliary variables $Y$ in the objective:

$$ \min_{X,Y} \lVert Y \rVert_{2,1} $$
$$ \text{subject to: } A X - B = Y$$

Now, introduce a vector of auxiliary variables corresponding to the columns of $Y$:

$$ \min_{X,Y,z} z^\top \mathbf{1} $$
$$ \text{subject to: } A X - B = Y$$
$$ \text{       and: } z_i \geq \lVert  Y_i  \rVert \quad \forall i$$

Many, solvers will require that variables are vectorized, so we may transform this yet again to:

$$ \min_{X,Y,z} z^\top \mathbf{1} $$
$$ \text{subject to: } 
(I \otimes A) \text{vec}(X) - \text{vec}(B) = \text{vec}(Y)$$
$$ \text{       and: } z_i \geq \lVert  Y_i  \rVert \quad \forall i$$

In MATLAB with mosek's conic solver,

```matlab
nb = size(B,2);
na = size(A,1);
n = size(A,2);
prob = struct();
prob.c = [zeros(n*nb + na*nb,1);ones(nb,1)];
prob.a = [repdiag(A,nb) -speye(na*nb,na*nb) sparse(na*nb,nb)];
prob.blc = B(:);
prob.buc = prob.blc;
[~, res] = mosekopt('symbcon echo(0)');
prob.cones.type = repmat(res.symbcon.MSK_CT_QUAD,1,nb);
prob.cones.sub = ...
  reshape([n*nb+na*nb+(1:nb);reshape(n*nb+(1:na*nb),na,nb)],[],1);
prob.cones.subptr = 1:(na+1):(na+1)*nb;
[r,res]=mosekopt('minimize echo(0)',prob);
X = reshape(res.sol.itr.xx(1:n*nb),n,nb);
```

### 13.1. Transpose (L1,2 norm)

Consider also the $L_{2,1}$ norm of the transpose of an affine expression, i.e., measuring the sum of Euclidean norms of each _row_ of $A X - B$:

$$ \min_X \lVert (A X - B)^\top \rVert_{2,1} $$

First, let us move the affine expression in a constraint, leaving the $L_{2,1}$ norm of a matrix of auxiliary variables $Y$ in the objective:

$$ \min_{X,Y} \lVert Y \rVert_{2,1} $$
$$ \text{subject to: } X^\top A^\top - B^\top = Y$$

Now, introduce a vector of auxiliary variables corresponding to the columns of $Y$:

$$ \min_{X,Y,z} z^\top \mathbf{1} $$
$$ \text{subject to: } X^\top A^\top - B^\top = Y$$
$$ \text{       and: } z_i \geq \lVert  Y_i  \rVert \quad \forall i$$

Many, solvers will require that variables are vectorized, so we may transform this yet again to:

$$ \min_{X,Y,z} z^\top \mathbf{1} $$
$$ \text{subject to: } 
(A \otimes I) \text{vec}(X) - \text{vec}(B^\top) = \text{vec}(Y)$$
$$ \text{       and: } z_i \geq \lVert  Y_i  \rVert \quad \forall i$$

In MATLAB with mosek's conic optimization (and [gptoolbox's kroneye](https://github.com/alecjacobson/gptoolbox/blob/master/matrix/kroneye.m)):

```matlab
nb = size(B,2);
na = size(A,1);
n = size(A,2);
prob = struct();
prob.c = [zeros(n*nb + na*nb,1);ones(na,1)];
prob.a = [kroneye(A,nb) -speye(na*nb,na*nb) sparse(na*nb,na)];
prob.blc = reshape(B',[],1);
prob.buc = prob.blc;
[~, res] = mosekopt('symbcon echo(0)');
prob.cones.type = repmat(res.symbcon.MSK_CT_QUAD,1,na);
prob.cones.sub = ...
  reshape([n*nb+na*nb+(1:na);reshape(n*nb+(1:na*nb),nb,na)],[],1);
prob.cones.subptr = 1:(nb+1):(nb+1)*na;
[r,res]=mosekopt('minimize echo(0)',prob);
X = reshape(res.sol.itr.xx(1:n*nb),n,nb);
```

## Bonus: Orthogonal Procrustes

Orthogonal Procrustes problem asks to find an orthogonal matrix $R$ that approximately maps a set of vectors in $A$ to another set of vectors $B$:

$$ \min_{R} \lVert  R A - B  \rVert_F^2$$
$$ \text{subject to } R^\top R = I$$

While _not convex_, this problem can be solved efficiently via singular value decomposition. First, transform the minimization of the Frobenius into a maximization of a matrix-product trace:

$$ \max_{R} \text{trace}(R X)$$
$$ \text{subject to: } R^\top R = I$$

where $X = BA^\top$. Let $X$ have a SVD decomposition $X = USV^\top$, then the optimal $R$ can be computed as

$$R = VU^\top.$$

up to changing the sign of the last column of $U$ associated with the smallest singular value so that $det(R) > 0$

In MATLAB,

```matlab
[U,S,V] = svd(B*A');
R = V*U';
if( det(R) < 0 )
    U(:,end) = -U(:,end);
    R = V*U';
end
```

## References

See also: [MOSEK Modeling Cookbook](https://docs.mosek.com/MOSEKModelingCookbook-letter.pdf), [YALMIP](https://yalmip.github.io/)


