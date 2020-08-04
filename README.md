# Convex Optimization Cookbook

Unless otherwise stated, we will assume that quadratic coefficient matrices
(e.g., <img src="./tex/1afcdb0f704394b16fe85fb40c45ca7a.svg?invert_in_darkmode" align=middle width=12.99542474999999pt height=22.465723500000017pt/>) are symmetric positive (semi-)definite so that <img src="./tex/664cf1886128c5fc05c2213e395b3fb1.svg?invert_in_darkmode" align=middle width=42.88131539999999pt height=27.91243950000002pt/> is a
convex function and that the stated problem has a unique minimizer.

## 1. Unconstrained quadratic vector optimization

If <img src="./tex/46d925a52666f83a6cc30a3149bb09df.svg?invert_in_darkmode" align=middle width=71.48480955pt height=26.17730939999998pt/> is positive definite then problems of the
form:

<p align="center"><img src="./tex/4a2f953bad9775393c67bbc85f23a7eb.svg?invert_in_darkmode" align=middle width=162.7872213pt height=32.990165999999995pt/></p>

are solved by finding the solution to the linear system:

<p align="center"><img src="./tex/dee05b4ca529fca5ebc1f6023f5b3b10.svg?invert_in_darkmode" align=middle width=66.9108924pt height=14.611878599999999pt/></p>

In MATLAB,

```matlab
x = Q \ -f;
```

## 2. Frobenius-norm matrix optimization

Define the squared Frobenius norm of a matrix as <img src="./tex/8688a80aebaace3691b0359749a7a740.svg?invert_in_darkmode" align=middle width=138.13167059999998pt height=26.76175259999998pt/>, then we may consider problems of the form:

<p align="center"><img src="./tex/bf2f3353f0f0b3b68c803c2be90ba9fa.svg?invert_in_darkmode" align=middle width=156.3488553pt height=34.0919106pt/></p>

Using the property <img src="./tex/9a257f0f674726a40668cc687431265b.svg?invert_in_darkmode" align=middle width=145.97047905pt height=27.91243950000002pt/>, we can expand
this to:

<p align="center"><img src="./tex/bd817c907beee2449169e03e42bb4cb2.svg?invert_in_darkmode" align=middle width=282.00085484999994pt height=32.990165999999995pt/></p>

Letting <img src="./tex/9eb4767e5eb2c4e40983c4cb0c33fedc.svg?invert_in_darkmode" align=middle width=70.66656794999999pt height=27.91243950000002pt/> and <img src="./tex/74088816610eabdf394f5741b51dfc6f.svg?invert_in_darkmode" align=middle width=84.27523500000001pt height=27.91271999999999pt/>, this can be written in a form
similar to the [unconstrained vector problem](#1-unconstrained-quadratic-vector-optimization):

<p align="center"><img src="./tex/6540175597e7390791d4d169f66c7ba0.svg?invert_in_darkmode" align=middle width=235.378572pt height=32.990165999999995pt/></p>

this problem is _separable_ in the columns of <img src="./tex/cbfb1b2a33b28eab8a3e59464768e810.svg?invert_in_darkmode" align=middle width=14.908688849999992pt height=22.465723500000017pt/> and <img src="./tex/b8bc815b5e9d5177af01fd4d3d3c2f10.svg?invert_in_darkmode" align=middle width=12.853995000000003pt height=22.46574pt/> and solved by finding
the solution to the multi-column linear system:

<p align="center"><img src="./tex/a70679fad3e36f1eccf85884db339862.svg?invert_in_darkmode" align=middle width=75.4611pt height=14.429217pt/></p>

In MATLAB,

```matlab
X = Q \ -F;
```

## 3. Fixed value constraints

Let <img src="./tex/48ceffddf7ca918284e3acbb9edeee97.svg?invert_in_darkmode" align=middle width=99.62108309999999pt height=27.91243950000002pt/> be a set of indices indicating elements of <img src="./tex/332cc365a4987aacce0ead01b8bdcc0b.svg?invert_in_darkmode" align=middle width=9.39498779999999pt height=14.15524440000002pt/> that
should be constrained to a particular known value. Then the problem:

<p align="center"><img src="./tex/b0a18012e85036daa7cf96798af33157.svg?invert_in_darkmode" align=middle width=135.58222755pt height=32.990165999999995pt/></p>

<p align="center"><img src="./tex/4b88ab7ee3568bdce44ec44c972ee7fd.svg?invert_in_darkmode" align=middle width=193.81191224999998pt height=14.611878599999999pt/></p>

can be reduced to an [unconstrained problem](#1-unconstrained-quadratic-vector-optimization) by substitution.
Introduce the set <img src="./tex/6bac6ec50c01592407695ef84f457232.svg?invert_in_darkmode" align=middle width=13.01596064999999pt height=22.465723500000017pt/> to be all indices _not_ in <img src="./tex/21fd4e8eecd6bdf1a4d3d6bd1fb8d733.svg?invert_in_darkmode" align=middle width=8.515988249999989pt height=22.465723500000017pt/>, then we can first re-order
terms above according to <img src="./tex/21fd4e8eecd6bdf1a4d3d6bd1fb8d733.svg?invert_in_darkmode" align=middle width=8.515988249999989pt height=22.465723500000017pt/> and <img src="./tex/6bac6ec50c01592407695ef84f457232.svg?invert_in_darkmode" align=middle width=13.01596064999999pt height=22.465723500000017pt/>:

<p align="center"><img src="./tex/f0579ecafb8c119f1e7b13a0b98e975a.svg?invert_in_darkmode" align=middle width=343.71936554999996pt height=39.452455349999994pt/></p>

<p align="center"><img src="./tex/e7bd8cff7d3043de8578dab4445d2ba3.svg?invert_in_darkmode" align=middle width=124.7644827pt height=14.611878599999999pt/></p>

where, for example, <img src="./tex/69a27b5b029b1e60af9e0161d7f8a915.svg?invert_in_darkmode" align=middle width=105.89594729999999pt height=27.91243950000002pt/> is the submatrix of
<img src="./tex/1afcdb0f704394b16fe85fb40c45ca7a.svg?invert_in_darkmode" align=middle width=12.99542474999999pt height=22.465723500000017pt/> extracted by slicing the rows by the set <img src="./tex/6bac6ec50c01592407695ef84f457232.svg?invert_in_darkmode" align=middle width=13.01596064999999pt height=22.465723500000017pt/> and the columns by the set <img src="./tex/21fd4e8eecd6bdf1a4d3d6bd1fb8d733.svg?invert_in_darkmode" align=middle width=8.515988249999989pt height=22.465723500000017pt/>.

Substituting the constraint <img src="./tex/705583ffbc841720aaa905460dd09b06.svg?invert_in_darkmode" align=middle width=47.50410884999998pt height=14.15524440000002pt/> into the objective then collecting terms
that are quadratic, linear, and constant in the remaining unknowns <img src="./tex/1e463ef25ae4c019b01284bed29e663a.svg?invert_in_darkmode" align=middle width=19.58383019999999pt height=14.15524440000002pt/> we
have a simple [unconstrained
optimization](#1-unconstrained-quadratic-vector-optimization) over <img src="./tex/1e463ef25ae4c019b01284bed29e663a.svg?invert_in_darkmode" align=middle width=19.58383019999999pt height=14.15524440000002pt/>:

<p align="center"><img src="./tex/80ea33f5bf6adf66d116299374bccbe4.svg?invert_in_darkmode" align=middle width=284.77919414999997pt height=33.230283899999996pt/></p>

In MATLAB, 

```matlab
U = setdiff(1:size(Q,1),I);
x = zeros(size(Q,1),1);
x(I) = y;
x(U) = Q(U,U) \ -(f(U) + Q(U,I) x(I));
```

## 4. Linear equality constraints

Given a matrix <img src="./tex/a62e636c0a5a0dc7bb27db081d191ac3.svg?invert_in_darkmode" align=middle width=96.11514pt height=26.177579999999978pt/> with linearly
independent rows, consider the problem:

<p align="center"><img src="./tex/771699c7667129e3dbe6d152ce541400.svg?invert_in_darkmode" align=middle width=139.2352038pt height=32.990165999999995pt/></p>

<p align="center"><img src="./tex/24145f46700c90b2065ec2b76d67fba1.svg?invert_in_darkmode" align=middle width=166.0616892pt height=16.1187015pt/></p>

Following the [Lagrange Multiplier
Method](https://en.wikipedia.org/wiki/Lagrange_multiplier), by introducing a
vector of auxiliary variables <img src="./tex/fef88965bb6ad4365d38d009a8752231.svg?invert_in_darkmode" align=middle width=58.42844369999998pt height=22.831056599999986pt/>, the solution will
coincide with the augmented max-min problem:

<p align="center"><img src="./tex/57250e9611b05c01c306207319b2c559.svg?invert_in_darkmode" align=middle width=303.05938245pt height=32.990165999999995pt/></p>

The [KKT
theorem](https://en.wikipedia.org/wiki/Karush%E2%80%93Kuhn%E2%80%93Tucker_conditions)
states that the solution is given when _all_ partial derivatives of this
quadratic function are zero, or in matrix form, at the solution to the linear
system:

<p align="center"><img src="./tex/dd360d31a505f39dad833a4d5fa6d5d3.svg?invert_in_darkmode" align=middle width=184.45222785pt height=39.718012949999995pt/></p>

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

Given a matrix <img src="./tex/fe9962541018ddfc535fc99a23c2b2aa.svg?invert_in_darkmode" align=middle width=103.147275pt height=26.177579999999978pt/> and 
a matrix <img src="./tex/035d3cdcbe2a412c297ab6d27a5c4eeb.svg?invert_in_darkmode" align=middle width=108.26145pt height=26.177579999999978pt/>, consider

<p align="center"><img src="./tex/771699c7667129e3dbe6d152ce541400.svg?invert_in_darkmode" align=middle width=139.2352038pt height=32.990165999999995pt/></p>

<p align="center"><img src="./tex/c03d6f00852f6bb93dd4cca00b15f264.svg?invert_in_darkmode" align=middle width=301.8950979pt height=16.1187015pt/></p>

Multiplying both sides of <img src="./tex/058460591438b600ab9ef92e4967fd40.svg?invert_in_darkmode" align=middle width=90.12557234999998pt height=22.831056599999986pt/> by <img src="./tex/e11a8cfcf953c683196d7a48677b2277.svg?invert_in_darkmode" align=middle width=21.00464354999999pt height=21.18721440000001pt/> we can
convert all constraints to less-than-or-equals inequalities:

<p align="center"><img src="./tex/771699c7667129e3dbe6d152ce541400.svg?invert_in_darkmode" align=middle width=139.2352038pt height=32.990165999999995pt/></p>

<p align="center"><img src="./tex/29e2f1ec810a2cc96e139bbec9462131.svg?invert_in_darkmode" align=middle width=247.65993119999996pt height=39.452455349999994pt/></p>

In MATLAB,

```matlab
x = quadprog(Q,f,[Aleq;-Ageq],[bleq;-bgeq]);
```

## 6. Linear program

In the absence of a quadratic term (e.g., <img src="./tex/664cf1886128c5fc05c2213e395b3fb1.svg?invert_in_darkmode" align=middle width=42.88131539999999pt height=27.91243950000002pt/>) leaving just a linear
term, constraints of some form are required to pin down a finite solution. For
example, we could consider linear inequality constrained linear optimization as
a generic form of linear programming:

<p align="center"><img src="./tex/51162e2f23b4b743593f8e831e92f291.svg?invert_in_darkmode" align=middle width=64.09829909999999pt height=24.64115115pt/></p>

<p align="center"><img src="./tex/9e516f9153628c9962c435f665352409.svg?invert_in_darkmode" align=middle width=168.11653815pt height=16.1187015pt/></p>

Whether a finite, unique solution exists depends on the particular values in
<img src="./tex/190083ef7a1625fbc75f243cffb9c96d.svg?invert_in_darkmode" align=middle width=9.81741584999999pt height=22.831056599999986pt/>, <img src="./tex/dd0f5c7c63cb97076f7abf4e0b712a9d.svg?invert_in_darkmode" align=middle width=28.801472699999987pt height=22.465723500000017pt/>, and <img src="./tex/44a2cb54b57ada7709eed99ce92472f2.svg?invert_in_darkmode" align=middle width=23.52747044999999pt height=22.831056599999986pt/>.

In MATLAB,

```matlab
x = linprog(f,Aleq,bleq);
```


## 7. Box or Bound constraints

A special case of [linear inequality
constraints](#4-linear-inequality-constraints) happens when
<img src="./tex/dd0f5c7c63cb97076f7abf4e0b712a9d.svg?invert_in_darkmode" align=middle width=28.801472699999987pt height=22.465723500000017pt/> is formed with rows of the identity matrix <img src="./tex/21fd4e8eecd6bdf1a4d3d6bd1fb8d733.svg?invert_in_darkmode" align=middle width=8.515988249999989pt height=22.465723500000017pt/>, indicating simple
upper bound constraints on specific elements of <img src="./tex/332cc365a4987aacce0ead01b8bdcc0b.svg?invert_in_darkmode" align=middle width=9.39498779999999pt height=14.15524440000002pt/>.


Letting <img src="./tex/28fc24e0051dd5378c3d7a83a4fdcb27.svg?invert_in_darkmode" align=middle width=101.80146734999998pt height=27.91243950000002pt/> be the set of those variables and <img src="./tex/6bac6ec50c01592407695ef84f457232.svg?invert_in_darkmode" align=middle width=13.01596064999999pt height=22.465723500000017pt/> be the
complementary set, then this could be written as:


<p align="center"><img src="./tex/771699c7667129e3dbe6d152ce541400.svg?invert_in_darkmode" align=middle width=139.2352038pt height=32.990165999999995pt/></p>

<p align="center"><img src="./tex/6bc6d72dfda86bf3f6f4842aaaa8b286.svg?invert_in_darkmode" align=middle width=208.69734929999998pt height=39.452455349999994pt/></p>

where <img src="./tex/4b046bb1b60972463ea72c3666c8f78b.svg?invert_in_darkmode" align=middle width=32.892124649999985pt height=22.465723500000017pt/> is the rectangular identity matrix.

More often, we see this written as a per-element constant bound constraint with
upper and lower bounds. Suppose <img src="./tex/d258dbb976bfc0817fee6aebdba060a3.svg?invert_in_darkmode" align=middle width=14.617642049999988pt height=22.465723500000017pt/> and <img src="./tex/893501db543dae4f3a4edb1cf6f976f4.svg?invert_in_darkmode" align=middle width=16.88744969999999pt height=22.465723500000017pt/> are sets of indices for lower and
upper bound constraints respectively, then consider:

<p align="center"><img src="./tex/771699c7667129e3dbe6d152ce541400.svg?invert_in_darkmode" align=middle width=139.2352038pt height=32.990165999999995pt/></p>

<p align="center"><img src="./tex/a6e4c8bdbbd344ddc88a629709805c35.svg?invert_in_darkmode" align=middle width=397.58791379999997pt height=16.1187015pt/></p>



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


<p align="center"><img src="./tex/771699c7667129e3dbe6d152ce541400.svg?invert_in_darkmode" align=middle width=139.2352038pt height=32.990165999999995pt/></p>

<p align="center"><img src="./tex/11b22ab783ec2b4eaf3347bd9ea46888.svg?invert_in_darkmode" align=middle width=210.70885275pt height=17.031940199999998pt/></p>

can be simply expanded to a [bound constraint](#7-box-or-bound-constraints)
problem:


<p align="center"><img src="./tex/771699c7667129e3dbe6d152ce541400.svg?invert_in_darkmode" align=middle width=139.2352038pt height=32.990165999999995pt/></p>

<p align="center"><img src="./tex/8d1bd394ca4db0a6de11f6a1395464af.svg?invert_in_darkmode" align=middle width=327.5774733pt height=16.1187015pt/></p>

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
generalizes to linear expressions. Given a matrix <img src="./tex/196bd7a2970416338465b81e61685417.svg?invert_in_darkmode" align=middle width=85.9008612pt height=26.17730939999998pt/>, then consider:

<p align="center"><img src="./tex/771699c7667129e3dbe6d152ce541400.svg?invert_in_darkmode" align=middle width=139.2352038pt height=32.990165999999995pt/></p>

<p align="center"><img src="./tex/bb8fe974b75f8d9038616364b461ee61.svg?invert_in_darkmode" align=middle width=158.56442745pt height=16.438356pt/></p>

### 9.1. Linear inequality constraints

Expand the absolute value constraints into two sets of [linear inequality
constraints](#5-linear-inequality-constraints):

<p align="center"><img src="./tex/771699c7667129e3dbe6d152ce541400.svg?invert_in_darkmode" align=middle width=139.2352038pt height=32.990165999999995pt/></p>

<p align="center"><img src="./tex/9c71504e4b9e6c7cb4bda9f2ff027d98.svg?invert_in_darkmode" align=middle width=304.52610374999995pt height=14.611878599999999pt/></p>

the greater-than-or-equals constraints of which can in turn be converted to
less-than-or-equals constraints as [above](#5-linear-inequality-constraints):

<p align="center"><img src="./tex/771699c7667129e3dbe6d152ce541400.svg?invert_in_darkmode" align=middle width=139.2352038pt height=32.990165999999995pt/></p>

<p align="center"><img src="./tex/246fd60c0d7ac71847e2ee71ad12e68a.svg?invert_in_darkmode" align=middle width=210.52784774999998pt height=39.452455349999994pt/></p>

In MATLAB,

```matlab
x = quadprog(Q,f,[Aa;-Aa],[ba;ba]);
```

### 9.2. Auxiliary variables

Introduce an auxiliary set of variables <img src="./tex/2fcb08babe9a41630cce2ddc1386b6d4.svg?invert_in_darkmode" align=middle width=58.24961504999998pt height=22.648391699999998pt/>, then introduce a
[linear equality constraint](#5-linear-equality-constraints) tying <img src="./tex/deceeaf6940a8c7a5a02373728002b0f.svg?invert_in_darkmode" align=middle width=8.649225749999989pt height=14.15524440000002pt/> to <img src="./tex/1b2dfed866baa2ee9bfa2a15ed5cff86.svg?invert_in_darkmode" align=middle width=29.67608159999999pt height=22.465723500000017pt/>
and apply [upper-bound absolute value
constraints](#8-upper-bound-on-absolute-value) on <img src="./tex/deceeaf6940a8c7a5a02373728002b0f.svg?invert_in_darkmode" align=middle width=8.649225749999989pt height=14.15524440000002pt/>:

<p align="center"><img src="./tex/fa0aa225ecc037b9f5d98dcb7deef50f.svg?invert_in_darkmode" align=middle width=139.2352038pt height=33.814738649999995pt/></p>

<p align="center"><img src="./tex/a00b23325fee89c8ba4f0175cbf21dfd.svg?invert_in_darkmode" align=middle width=172.20640799999998pt height=14.611878599999999pt/></p>

<p align="center"><img src="./tex/2ed5c4cbeaa993008a5e19c470e89141.svg?invert_in_darkmode" align=middle width=217.17552120000002pt height=14.611878599999999pt/></p>

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
the <img src="./tex/929ed909014029a206f344a28aa47d15.svg?invert_in_darkmode" align=middle width=17.73978854999999pt height=22.465723500000017pt/> norm of a linear expression (sum of absolute values):

<p align="center"><img src="./tex/400b1af52ddbe3a758972372483de6b6.svg?invert_in_darkmode" align=middle width=101.99772pt height=22.19184pt/></p>


### 10.1. Linear inequalities

Introduce the auxiliary vector variable <img src="./tex/4f4f4e395762a3af4575de74c019ebb5.svg?invert_in_darkmode" align=middle width=5.936097749999991pt height=20.221802699999984pt/>:

<p align="center"><img src="./tex/4839253e32549a5964b2c39409d72e8c.svg?invert_in_darkmode" align=middle width=56.6210205pt height=26.878597349999996pt/></p>

<p align="center"><img src="./tex/9360c01615e6c796333aecc0b92aad32.svg?invert_in_darkmode" align=middle width=169.50903749999998pt height=16.438356pt/></p>

which is a form of [absolute value constrained
optimization](#9-upper-bound-of-absolute-value-of-linear-expression), then solved,
for example, by further transforming to:

<p align="center"><img src="./tex/4839253e32549a5964b2c39409d72e8c.svg?invert_in_darkmode" align=middle width=56.6210205pt height=26.878597349999996pt/></p>

<p align="center"><img src="./tex/4690ce9ee7c851527f56e679d8cfd0e6.svg?invert_in_darkmode" align=middle width=308.3331174pt height=14.611878599999999pt/></p>

In turn, this can be converted into pure less-than-or-equals constraints:

<p align="center"><img src="./tex/2888e0417124dd59bf5fbfadb72235fe.svg?invert_in_darkmode" align=middle width=103.5960552pt height=39.452455349999994pt/></p>

<p align="center"><img src="./tex/9613ca7ccb20f777e8186bed5254ef0e.svg?invert_in_darkmode" align=middle width=255.19420409999998pt height=39.452455349999994pt/></p>

In MATLAB,

```matlab
n = size(A,2);
na = size(A,1);
I = speye(na,na);
x = speye(n,n+na) * linprog([zeros(n,1);ones(na,1)],[A -I;-A -I],[b;-b]);
```

### 10.2. Variable splitting

Introduce the vector variables <img src="./tex/6dbb78540bd76da3f1625782d42d6d16.svg?invert_in_darkmode" align=middle width=9.41027339999999pt height=14.15524440000002pt/>,<img src="./tex/6c4adbc36120d62b98deef2a20d5d303.svg?invert_in_darkmode" align=middle width=8.55786029999999pt height=14.15524440000002pt/> so that the element-wise equalities hold:

<p align="center"><img src="./tex/1c6d6f43b9b5fecca9212bdb2f24b61e.svg?invert_in_darkmode" align=middle width=490.50197295000004pt height=16.438356pt/></p>

Then the problem becomes:

<p align="center"><img src="./tex/257c32646c21bfb4187dd4213d1320cf.svg?invert_in_darkmode" align=middle width=111.9177807pt height=26.878597349999996pt/></p>
<p align="center"><img src="./tex/544e2e5d9ecc7c90123717a2be55d01c.svg?invert_in_darkmode" align=middle width=192.49981739999998pt height=14.611878599999999pt/></p>
<p align="center"><img src="./tex/49f2cd6fa023b43130e4213f9f06a91c.svg?invert_in_darkmode" align=middle width=80.64315435pt height=14.611878599999999pt/></p>

This can be expanded in matrix form to:

<p align="center"><img src="./tex/d65cedafdd11cb5f5934cbe7056d1fc7.svg?invert_in_darkmode" align=middle width=133.915815pt height=59.1786591pt/></p>

<p align="center"><img src="./tex/cd4fe362cb2b3e4e614c3e18004169fe.svg?invert_in_darkmode" align=middle width=242.72074695pt height=59.1786591pt/></p>

<p align="center"><img src="./tex/d6aa786a9018033eb4833dd8f99aa799.svg?invert_in_darkmode" align=middle width=152.7892542pt height=59.1786591pt/></p>

In MATLAB,

```matlab
n = size(A,2);
na = size(A,1);
I = speye(na,na);
x = speye(n,n+2*na) * ...
  linprog([zeros(n,1);ones(2*na,1)],[],[],[A -I I],b,[-inf(n,1);zeros(2*na,1)]);
```

## 11. Convex hull constraint

Consider the problem where the solution <img src="./tex/52729df27072fb95b89c6fe5f01950ed.svg?invert_in_darkmode" align=middle width=49.48432829999999pt height=22.648391699999998pt/> is required to lie in the convex
hull defined by points <img src="./tex/ffcf5c49a968798f43517f1b07626125.svg?invert_in_darkmode" align=middle width=153.32926784999998pt height=22.831056599999986pt/>:

<p align="center"><img src="./tex/771699c7667129e3dbe6d152ce541400.svg?invert_in_darkmode" align=middle width=139.2352038pt height=32.990165999999995pt/></p>

<p align="center"><img src="./tex/b4b0f3f6fa3102d7f295b96580aeba15.svg?invert_in_darkmode" align=middle width=322.7264106pt height=16.438356pt/></p>

A point <img src="./tex/332cc365a4987aacce0ead01b8bdcc0b.svg?invert_in_darkmode" align=middle width=9.39498779999999pt height=14.15524440000002pt/> is in the convex hull of <img src="./tex/6bcc7fcfee94a17aa4b7b892a372fcf4.svg?invert_in_darkmode" align=middle width=112.41801284999998pt height=22.831056599999986pt/> if and only if
there exist a set of positive, unity partitioning weights <img src="./tex/31fae8b8b78ebe01cbfbe2fe53832624.svg?invert_in_darkmode" align=middle width=12.210846449999991pt height=14.15524440000002pt/> such that:

<p align="center"><img src="./tex/82a864bd57676e90bee03febdb560d43.svg?invert_in_darkmode" align=middle width=61.38309209999999pt height=14.42921205pt/></p>

where we collect <img src="./tex/6bcc7fcfee94a17aa4b7b892a372fcf4.svg?invert_in_darkmode" align=middle width=112.41801284999998pt height=22.831056599999986pt/> in the columns of <img src="./tex/de7bb3cc354024021089643be79c171a.svg?invert_in_darkmode" align=middle width=75.32161559999999pt height=26.17730939999998pt/>. 

(As a consequence, <img src="./tex/57957cec8e6d6e7ac3cf46db3d38b7ae.svg?invert_in_darkmode" align=middle width=42.347685599999984pt height=21.18721440000001pt/>).

Introducing these weights as auxiliary variables, we can express the problem as:


<p align="center"><img src="./tex/2e82e718b7cdec815b160787f7cc361a.svg?invert_in_darkmode" align=middle width=139.2352038pt height=33.814738649999995pt/></p>

<p align="center"><img src="./tex/32c6b0a438ec10b1d802509d6f926769.svg?invert_in_darkmode" align=middle width=180.60119385pt height=39.452455349999994pt/></p>

<p align="center"><img src="./tex/c907000384775c1693a9ad7fd6dfb690.svg?invert_in_darkmode" align=middle width=80.703942pt height=13.650669449999999pt/></p>

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

An <img src="./tex/929ed909014029a206f344a28aa47d15.svg?invert_in_darkmode" align=middle width=17.73978854999999pt height=22.465723500000017pt/> term can also appear in the constraints with an upper bound. 

<p align="center"><img src="./tex/f95c7eef47b5400896a422ca13cc45e8.svg?invert_in_darkmode" align=middle width=139.2352038pt height=32.990165999999995pt/></p>

<p align="center"><img src="./tex/f68b34c17171bcf3b7b5b3095082c60f.svg?invert_in_darkmode" align=middle width=138.52741154999998pt height=16.438356pt/></p>


### 12.1. Auxiliary variables

Introduce a set of auxiliary variables <img src="./tex/deceeaf6940a8c7a5a02373728002b0f.svg?invert_in_darkmode" align=middle width=8.649225749999989pt height=14.15524440000002pt/> and require that:

<p align="center"><img src="./tex/5ec4d9af04a71dacc338156bffa632c2.svg?invert_in_darkmode" align=middle width=217.05914999999996pt height=18.887715pt/></p>

This can be incorporated into the optimization, for example, using two linear
sets of inequalities:

<p align="center"><img src="./tex/fa0aa225ecc037b9f5d98dcb7deef50f.svg?invert_in_darkmode" align=middle width=139.2352038pt height=33.814738649999995pt/></p>

<p align="center"><img src="./tex/521a89b6ca5759764600a5a899d99426.svg?invert_in_darkmode" align=middle width=141.822615pt height=17.974439999999998pt/></p>
<p align="center"><img src="./tex/0bb810dbb23ea02edbde9397a45d9355.svg?invert_in_darkmode" align=middle width=280.335pt height=14.611871999999998pt/></p>

In turn, this can be converted into pure less-than-or-equals constraints:

<p align="center"><img src="./tex/fa0aa225ecc037b9f5d98dcb7deef50f.svg?invert_in_darkmode" align=middle width=139.2352038pt height=33.814738649999995pt/></p>

<p align="center"><img src="./tex/521a89b6ca5759764600a5a899d99426.svg?invert_in_darkmode" align=middle width=141.822615pt height=17.974439999999998pt/></p>
<p align="center"><img src="./tex/bc3f51fda609ead8b3abb83700270200.svg?invert_in_darkmode" align=middle width=209.89815pt height=39.45249pt/></p>

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

Geometrically, this constraint is requiring that <img src="./tex/332cc365a4987aacce0ead01b8bdcc0b.svg?invert_in_darkmode" align=middle width=9.39498779999999pt height=14.15524440000002pt/> lie within in the convex
hull of <img src="./tex/a7d0e0605a6acafe642d0b54226ac650.svg?invert_in_darkmode" align=middle width=13.60734374999999pt height=22.831056599999986pt/>-<img src="./tex/929ed909014029a206f344a28aa47d15.svg?invert_in_darkmode" align=middle width=17.73978854999999pt height=22.465723500000017pt/>-norm ball, which is also the [convex
hull](convex-hull-constraint) of the points in the columns of <img src="./tex/e8086ca465222379817decafbc013637.svg?invert_in_darkmode" align=middle width=93.08762594999999pt height=24.65753399999998pt/>.

Introducing an auxiliary weight vectors <img src="./tex/3470bb0ee26884b43898593dd0249c07.svg?invert_in_darkmode" align=middle width=52.91488289999999pt height=26.17730939999998pt/>, the problem can be transformed into:

<p align="center"><img src="./tex/00810526a0fc121554d356509b2f1b49.svg?invert_in_darkmode" align=middle width=165.73470375pt height=35.45857425pt/></p>

<p align="center"><img src="./tex/8ee092afd3727894f3d926a79615cd74.svg?invert_in_darkmode" align=middle width=253.84328804999998pt height=39.452455349999994pt/></p>

<p align="center"><img src="./tex/aa09c3a00c2361d17b95ef6c65370832.svg?invert_in_darkmode" align=middle width=122.22987314999999pt height=17.1069228pt/></p>

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

## 13. L2,1 norm
The <img src="./tex/5b918dca421c871de87c096acfeb29e5.svg?invert_in_darkmode" align=middle width=28.196520000000003pt height=22.46574pt/> norm is defined to be the sum of the Euclidean norms
of a matrix's columns <img src="./tex/4f73b4185b81a335005ed93bb6eac66c.svg?invert_in_darkmode" align=middle width=270.972405pt height=28.603079999999977pt/>. Consider the matrix problem:

<p align="center"><img src="./tex/030c5d9936c66f26a9c02059afb78e73.svg?invert_in_darkmode" align=middle width=116.900685pt height=22.931535pt/></p>

(If <img src="./tex/53d147e7f3fe6e47ee05b88b166bd3f6.svg?invert_in_darkmode" align=middle width=12.328800000000005pt height=22.46574pt/> has only one row, this reduces to [L1
minimization](#10-l1-minimization).)

First, let us move the affine expression in a constraint, leaving the <img src="./tex/5b918dca421c871de87c096acfeb29e5.svg?invert_in_darkmode" align=middle width=28.196520000000003pt height=22.46574pt/>
norm of a matrix of auxiliary variables <img src="./tex/91aac9730317276af725abd8cef04ca9.svg?invert_in_darkmode" align=middle width=13.196370000000005pt height=22.46574pt/> in the objective:

<p align="center"><img src="./tex/65108a9af4de6d535ac471fb5f310f0a.svg?invert_in_darkmode" align=middle width=69.47506499999999pt height=25.168934999999998pt/></p>
<p align="center"><img src="./tex/cafa8156531ce27284a8385f864a8c31.svg?invert_in_darkmode" align=middle width=179.38965pt height=14.611871999999998pt/></p>

Now, introduce a vector of auxiliary variables corresponding to the columns of
<img src="./tex/91aac9730317276af725abd8cef04ca9.svg?invert_in_darkmode" align=middle width=13.196370000000005pt height=22.46574pt/>:

<p align="center"><img src="./tex/2e6b46813a3b87b76a3694f71ddc9e22.svg?invert_in_darkmode" align=middle width=65.617695pt height=27.618359999999996pt/></p>
<p align="center"><img src="./tex/cafa8156531ce27284a8385f864a8c31.svg?invert_in_darkmode" align=middle width=179.38965pt height=14.611871999999998pt/></p>
<p align="center"><img src="./tex/755a94154bdf72e6fa386a23803c7fde.svg?invert_in_darkmode" align=middle width=136.07995499999998pt height=16.438356pt/></p>

Many, solvers will require that variables are vectorized, so we may transform
this yet again to:

<p align="center"><img src="./tex/2e6b46813a3b87b76a3694f71ddc9e22.svg?invert_in_darkmode" align=middle width=65.617695pt height=27.618359999999996pt/></p>
<p align="center"><img src="./tex/fcdf39ef6665f7f1cf2fa13845074f23.svg?invert_in_darkmode" align=middle width=327.63059999999996pt height=16.438356pt/></p>
<p align="center"><img src="./tex/755a94154bdf72e6fa386a23803c7fde.svg?invert_in_darkmode" align=middle width=136.07995499999998pt height=16.438356pt/></p>

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

### 13.1. Transpose

<p align="center"><img src="./tex/1660c365039facfd4ac031db6b1a9e69.svg?invert_in_darkmode" align=middle width=140.782125pt height=25.380795pt/></p>

First, let us move the affine expression in a constraint, leaving the <img src="./tex/5b918dca421c871de87c096acfeb29e5.svg?invert_in_darkmode" align=middle width=28.196520000000003pt height=22.46574pt/>
norm of a matrix of auxiliary variables <img src="./tex/91aac9730317276af725abd8cef04ca9.svg?invert_in_darkmode" align=middle width=13.196370000000005pt height=22.46574pt/> in the objective:

<p align="center"><img src="./tex/65108a9af4de6d535ac471fb5f310f0a.svg?invert_in_darkmode" align=middle width=69.47506499999999pt height=25.168934999999998pt/></p>
<p align="center"><img src="./tex/c28936ccee421e0fed854d70f740ced9.svg?invert_in_darkmode" align=middle width=212.67675pt height=17.974439999999998pt/></p>

Now, introduce a vector of auxiliary variables corresponding to the columns of
<img src="./tex/91aac9730317276af725abd8cef04ca9.svg?invert_in_darkmode" align=middle width=13.196370000000005pt height=22.46574pt/>:

<p align="center"><img src="./tex/2e6b46813a3b87b76a3694f71ddc9e22.svg?invert_in_darkmode" align=middle width=65.617695pt height=27.618359999999996pt/></p>
<p align="center"><img src="./tex/c28936ccee421e0fed854d70f740ced9.svg?invert_in_darkmode" align=middle width=212.67675pt height=17.974439999999998pt/></p>
<p align="center"><img src="./tex/755a94154bdf72e6fa386a23803c7fde.svg?invert_in_darkmode" align=middle width=136.07995499999998pt height=16.438356pt/></p>

Many, solvers will require that variables are vectorized, so we may transform
this yet again to:

<p align="center"><img src="./tex/2e6b46813a3b87b76a3694f71ddc9e22.svg?invert_in_darkmode" align=middle width=65.617695pt height=27.618359999999996pt/></p>
<p align="center"><img src="./tex/253d3f995052390db9e5014e747fe50e.svg?invert_in_darkmode" align=middle width=338.72684999999996pt height=18.887715pt/></p>
<p align="center"><img src="./tex/755a94154bdf72e6fa386a23803c7fde.svg?invert_in_darkmode" align=middle width=136.07995499999998pt height=16.438356pt/></p>

In MATLAB with mosek's conic optimization (and [gptoolbox's
kroneye](https://github.com/alecjacobson/gptoolbox/master/matrix/kroneye.m)):

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

## References

See also: [MOSEK Modeling Cookbook](https://docs.mosek.com/MOSEKModelingCookbook-letter.pdf), [YALMIP](https://yalmip.github.io/)
