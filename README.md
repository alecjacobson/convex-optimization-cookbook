# Convex Optimization Cookbook

Unless otherwise stated, we will assume that quadratic coefficient matrices
(e.g., <img src="/tex/1afcdb0f704394b16fe85fb40c45ca7a.svg?invert_in_darkmode&sanitize=true" align=middle width=12.99542474999999pt height=22.465723500000017pt/>) are symmetric positive (semi-)definite so that <img src="/tex/664cf1886128c5fc05c2213e395b3fb1.svg?invert_in_darkmode&sanitize=true" align=middle width=42.88131539999999pt height=27.91243950000002pt/> is a convex function
and that the problem has a unique minimizer.


## Unconstrained quadratic vector optimization

If <img src="/tex/46d925a52666f83a6cc30a3149bb09df.svg?invert_in_darkmode&sanitize=true" align=middle width=71.48480955pt height=26.17730939999998pt/> is positive definite then problems of the
form:

<p align="center"><img src="/tex/4a2f953bad9775393c67bbc85f23a7eb.svg?invert_in_darkmode&sanitize=true" align=middle width=162.7872213pt height=32.990165999999995pt/></p>

are solved by finding the solution to the linear system:

<p align="center"><img src="/tex/dee05b4ca529fca5ebc1f6023f5b3b10.svg?invert_in_darkmode&sanitize=true" align=middle width=66.9108924pt height=14.611878599999999pt/></p>

In MATLAB,

```
x = Q \ -f;
```

## Frobenius-norm matrix optimization

Define the squared Frobenius norm of a matrix as <img src="/tex/8688a80aebaace3691b0359749a7a740.svg?invert_in_darkmode&sanitize=true" align=middle width=138.13167059999998pt height=26.76175259999998pt/>, then we may consider problems of the form:

<p align="center"><img src="/tex/bf2f3353f0f0b3b68c803c2be90ba9fa.svg?invert_in_darkmode&sanitize=true" align=middle width=156.3488553pt height=34.0919106pt/></p>

Using the property <img src="/tex/9a257f0f674726a40668cc687431265b.svg?invert_in_darkmode&sanitize=true" align=middle width=145.97047905pt height=27.91243950000002pt/>, we can expand
this to:

<p align="center"><img src="/tex/bd817c907beee2449169e03e42bb4cb2.svg?invert_in_darkmode&sanitize=true" align=middle width=282.00085484999994pt height=32.990165999999995pt/></p>

Letting <img src="/tex/9eb4767e5eb2c4e40983c4cb0c33fedc.svg?invert_in_darkmode&sanitize=true" align=middle width=70.66656794999999pt height=27.91243950000002pt/> and <img src="/tex/23a3f7407c27e8d5ded6f25888f8b45c.svg?invert_in_darkmode&sanitize=true" align=middle width=82.60842974999998pt height=27.91243950000002pt/>, this can be written in a form
similar to the [unconstrained vector problem](#unconstrained-quadratic-vector-optimization):

<p align="center"><img src="/tex/6540175597e7390791d4d169f66c7ba0.svg?invert_in_darkmode&sanitize=true" align=middle width=235.378572pt height=32.990165999999995pt/></p>

this problem is _separable_ in the columns of <img src="/tex/cbfb1b2a33b28eab8a3e59464768e810.svg?invert_in_darkmode&sanitize=true" align=middle width=14.908688849999992pt height=22.465723500000017pt/> and <img src="/tex/ddcb483302ed36a59286424aa5e0be17.svg?invert_in_darkmode&sanitize=true" align=middle width=11.18724254999999pt height=22.465723500000017pt/> and solved by finding
the solution to the multi-column linear system:

<p align="center"><img src="/tex/29a4f160c30f9322be68c54e72355d67.svg?invert_in_darkmode&sanitize=true" align=middle width=73.79439705pt height=14.42921205pt/></p>

In MATLAB,

```
X = Q \ -F;
```

## Fixed value constraints

Let <img src="/tex/48ceffddf7ca918284e3acbb9edeee97.svg?invert_in_darkmode&sanitize=true" align=middle width=99.62108309999999pt height=27.91243950000002pt/> be a set of indices indicating elements of <img src="/tex/332cc365a4987aacce0ead01b8bdcc0b.svg?invert_in_darkmode&sanitize=true" align=middle width=9.39498779999999pt height=14.15524440000002pt/> that
should be constrained to a particular known value. Then the problem:

<p align="center"><img src="/tex/b0a18012e85036daa7cf96798af33157.svg?invert_in_darkmode&sanitize=true" align=middle width=135.58222755pt height=32.990165999999995pt/></p>

<p align="center"><img src="/tex/4b88ab7ee3568bdce44ec44c972ee7fd.svg?invert_in_darkmode&sanitize=true" align=middle width=193.81191224999998pt height=14.611878599999999pt/></p>

can be reduced to an [unconstrained problem](#unconstrained-quadratic-vector-optimization) by substitution.
Introduce the set <img src="/tex/6bac6ec50c01592407695ef84f457232.svg?invert_in_darkmode&sanitize=true" align=middle width=13.01596064999999pt height=22.465723500000017pt/> to be all indices _not_ in <img src="/tex/21fd4e8eecd6bdf1a4d3d6bd1fb8d733.svg?invert_in_darkmode&sanitize=true" align=middle width=8.515988249999989pt height=22.465723500000017pt/>, then we can first re-order
terms above according to <img src="/tex/21fd4e8eecd6bdf1a4d3d6bd1fb8d733.svg?invert_in_darkmode&sanitize=true" align=middle width=8.515988249999989pt height=22.465723500000017pt/> and <img src="/tex/6bac6ec50c01592407695ef84f457232.svg?invert_in_darkmode&sanitize=true" align=middle width=13.01596064999999pt height=22.465723500000017pt/>:

<p align="center"><img src="/tex/f0579ecafb8c119f1e7b13a0b98e975a.svg?invert_in_darkmode&sanitize=true" align=middle width=343.71936554999996pt height=39.452455349999994pt/></p>

<p align="center"><img src="/tex/e7bd8cff7d3043de8578dab4445d2ba3.svg?invert_in_darkmode&sanitize=true" align=middle width=124.7644827pt height=14.611878599999999pt/></p>

where, for example, <img src="/tex/69a27b5b029b1e60af9e0161d7f8a915.svg?invert_in_darkmode&sanitize=true" align=middle width=105.89594729999999pt height=27.91243950000002pt/> is the submatrix of
<img src="/tex/1afcdb0f704394b16fe85fb40c45ca7a.svg?invert_in_darkmode&sanitize=true" align=middle width=12.99542474999999pt height=22.465723500000017pt/> extracted by slicing the rows by the set <img src="/tex/6bac6ec50c01592407695ef84f457232.svg?invert_in_darkmode&sanitize=true" align=middle width=13.01596064999999pt height=22.465723500000017pt/> and the columns by the set <img src="/tex/21fd4e8eecd6bdf1a4d3d6bd1fb8d733.svg?invert_in_darkmode&sanitize=true" align=middle width=8.515988249999989pt height=22.465723500000017pt/>.

Substituting the constraint <img src="/tex/705583ffbc841720aaa905460dd09b06.svg?invert_in_darkmode&sanitize=true" align=middle width=47.50410884999998pt height=14.15524440000002pt/> into the objective then collecting terms
that are quadratic, linear, and constant in the remaining unknowns <img src="/tex/1e463ef25ae4c019b01284bed29e663a.svg?invert_in_darkmode&sanitize=true" align=middle width=19.58383019999999pt height=14.15524440000002pt/> we
have a simple [unconstrained optimization](#unconstrained-quadratic-vector-optimization) over <img src="/tex/1e463ef25ae4c019b01284bed29e663a.svg?invert_in_darkmode&sanitize=true" align=middle width=19.58383019999999pt height=14.15524440000002pt/>:

<p align="center"><img src="/tex/80ea33f5bf6adf66d116299374bccbe4.svg?invert_in_darkmode&sanitize=true" align=middle width=284.77919414999997pt height=33.230283899999996pt/></p>

In MATLAB, 

```
U = setdiff(1:size(Q,1),I);
x = zeros(size(Q,1),1);
x(I) = y;
x(U) = Q(U,U) \ -(f(U) + Q(U,I) x(I));
```

## Linear equality constraints

Given a matrix <img src="/tex/edce993245efb305e317cc35c6ce570a.svg?invert_in_darkmode&sanitize=true" align=middle width=79.67685329999999pt height=26.17730939999998pt/> with linearly
independent rows, consider the problem:

<p align="center"><img src="/tex/771699c7667129e3dbe6d152ce541400.svg?invert_in_darkmode&sanitize=true" align=middle width=139.2352038pt height=32.990165999999995pt/></p>

<p align="center"><img src="/tex/24145f46700c90b2065ec2b76d67fba1.svg?invert_in_darkmode&sanitize=true" align=middle width=166.0616892pt height=16.1187015pt/></p>

Following the [Lagrange Multiplier
Method](https://en.wikipedia.org/wiki/Lagrange_multiplier), by introducing a
vector of auxiliary variables <img src="/tex/fef88965bb6ad4365d38d009a8752231.svg?invert_in_darkmode&sanitize=true" align=middle width=58.42844369999998pt height=22.831056599999986pt/>, the solution will
coincide with the augmented max-min problem:

<p align="center"><img src="/tex/57250e9611b05c01c306207319b2c559.svg?invert_in_darkmode&sanitize=true" align=middle width=303.05938245pt height=32.990165999999995pt/></p>

The [KKT
theorem](https://en.wikipedia.org/wiki/Karush%E2%80%93Kuhn%E2%80%93Tucker_conditions)
states that the solution is given when _all_ partial derivatives of this
quadratic function are zero, or in matrix form, at the solution to the linear
system:

<p align="center"><img src="/tex/dd360d31a505f39dad833a4d5fa6d5d3.svg?invert_in_darkmode&sanitize=true" align=middle width=184.45222785pt height=39.718012949999995pt/></p>

In MATLAB,

```
x = speye(n,n+neq) * ([Q Aeq';Aeq sparse(neq,neq)] \ [-f;beq];
```

or if you're not sure if the rows of `Aeq` are linearly independent:

```
x = quadprog(Q,f,[],[],Aeq,beq);
```

## Linear inequality constraints

Given a matrix <img src="/tex/a74c28e444d9798ed1503a58bee27b40.svg?invert_in_darkmode&sanitize=true" align=middle width=86.70888104999999pt height=26.17730939999998pt/> and 
a matrix <img src="/tex/9148ad1d562c84664b9621a24ad27ca6.svg?invert_in_darkmode&sanitize=true" align=middle width=91.82309234999998pt height=26.17730939999998pt/>, consider

<p align="center"><img src="/tex/771699c7667129e3dbe6d152ce541400.svg?invert_in_darkmode&sanitize=true" align=middle width=139.2352038pt height=32.990165999999995pt/></p>

<p align="center"><img src="/tex/c03d6f00852f6bb93dd4cca00b15f264.svg?invert_in_darkmode&sanitize=true" align=middle width=301.8950979pt height=16.1187015pt/></p>

Multiplying both sides of <img src="/tex/058460591438b600ab9ef92e4967fd40.svg?invert_in_darkmode&sanitize=true" align=middle width=90.12557234999998pt height=22.831056599999986pt/> by <img src="/tex/e11a8cfcf953c683196d7a48677b2277.svg?invert_in_darkmode&sanitize=true" align=middle width=21.00464354999999pt height=21.18721440000001pt/> we can
convert all constraints to less-than-or-equals inequalities:

<p align="center"><img src="/tex/771699c7667129e3dbe6d152ce541400.svg?invert_in_darkmode&sanitize=true" align=middle width=139.2352038pt height=32.990165999999995pt/></p>

<p align="center"><img src="/tex/29e2f1ec810a2cc96e139bbec9462131.svg?invert_in_darkmode&sanitize=true" align=middle width=247.65993119999996pt height=39.452455349999994pt/></p>

In MATLAB,

```
x = quadprog(Q,f,[Aleq;-Ageq],[bleq;-bgeq]);
```


## Box or Bound constraints

A special case of [linear inequality
constraints](#linear-inequality-constraints) happens when
<img src="/tex/dd0f5c7c63cb97076f7abf4e0b712a9d.svg?invert_in_darkmode&sanitize=true" align=middle width=28.801472699999987pt height=22.465723500000017pt/> is formed with rows of the identity matrix <img src="/tex/21fd4e8eecd6bdf1a4d3d6bd1fb8d733.svg?invert_in_darkmode&sanitize=true" align=middle width=8.515988249999989pt height=22.465723500000017pt/>, indicating simple
upper bound constraints on specific elements of <img src="/tex/332cc365a4987aacce0ead01b8bdcc0b.svg?invert_in_darkmode&sanitize=true" align=middle width=9.39498779999999pt height=14.15524440000002pt/>.


Letting <img src="/tex/28fc24e0051dd5378c3d7a83a4fdcb27.svg?invert_in_darkmode&sanitize=true" align=middle width=101.80146734999998pt height=27.91243950000002pt/> be the set of those variables and <img src="/tex/6bac6ec50c01592407695ef84f457232.svg?invert_in_darkmode&sanitize=true" align=middle width=13.01596064999999pt height=22.465723500000017pt/> be the
complementary set, then this could be written as:


<p align="center"><img src="/tex/771699c7667129e3dbe6d152ce541400.svg?invert_in_darkmode&sanitize=true" align=middle width=139.2352038pt height=32.990165999999995pt/></p>

<p align="center"><img src="/tex/6bc6d72dfda86bf3f6f4842aaaa8b286.svg?invert_in_darkmode&sanitize=true" align=middle width=208.69734929999998pt height=39.452455349999994pt/></p>

where <img src="/tex/4b046bb1b60972463ea72c3666c8f78b.svg?invert_in_darkmode&sanitize=true" align=middle width=32.892124649999985pt height=22.465723500000017pt/> is the rectangular identity matrix.

More often, we see this written as a per-element constant bound constraint with
upper and lower bounds:

<p align="center"><img src="/tex/771699c7667129e3dbe6d152ce541400.svg?invert_in_darkmode&sanitize=true" align=middle width=139.2352038pt height=32.990165999999995pt/></p>

<p align="center"><img src="/tex/cd55b63a5b101757f231e53e98efa4cf.svg?invert_in_darkmode&sanitize=true" align=middle width=381.5660112pt height=16.1187015pt/></p>



In MATLAB,

```
l = -inf(size(Q,1),1);
l(I) = bgeq;
u =  inf(size(Q,1),1);
u(I) = bleq;
x = quadprog(Q,f,[],[],[],[],l,u);
```
