# Convex Optimization Cookbook

Unless otherwise stated, we will assume that quadratic coefficient matrices
(e.g., <img src="/tex/1afcdb0f704394b16fe85fb40c45ca7a.svg?invert_in_darkmode&sanitize=true" align=middle width=12.99542474999999pt height=22.465723500000017pt/>) are symmetric positive (semi-)definite so that <img src="/tex/664cf1886128c5fc05c2213e395b3fb1.svg?invert_in_darkmode&sanitize=true" align=middle width=42.88131539999999pt height=27.91243950000002pt/> is a convex function
and that the problem has a unique minimizer.


## Unconstrained quadratic vector optimization

If <img src="/tex/46d925a52666f83a6cc30a3149bb09df.svg?invert_in_darkmode&sanitize=true" align=middle width=71.48480955pt height=26.17730939999998pt/> is positive definite then problems of the
form:

<p align="center"><img src="/tex/639507964724df427a0c7065e434056e.svg?invert_in_darkmode&sanitize=true" align=middle width=159.8191749pt height=32.990165999999995pt/></p>

are solved by finding the solution to the linear system:

<p align="center"><img src="/tex/791250a6dba531bc0fe98455637871be.svg?invert_in_darkmode&sanitize=true" align=middle width=63.942844349999994pt height=14.611878599999999pt/></p>

In MATLAB,

```
x = Q \ -l;
```

## Frobenius-norm matrix optimization

Define the squared Frobenius norm of a matrix as <img src="/tex/37a6f5089b6db546cd17b9419e5af093.svg?invert_in_darkmode&sanitize=true" align=middle width=139.75611705pt height=26.76175259999998pt/>, then we may consider problems of the form:

<p align="center"><img src="/tex/ae4e65e59044658f157f021b0850c835.svg?invert_in_darkmode&sanitize=true" align=middle width=157.97330505pt height=34.0919106pt/></p>

Using the property <img src="/tex/de719e9964fc415c5e45e370f97943d5.svg?invert_in_darkmode&sanitize=true" align=middle width=147.5949288pt height=27.91243950000002pt/>, we can expand
this to:

<p align="center"><img src="/tex/e0d634d435335a966459d0dbbc3b7b6c.svg?invert_in_darkmode&sanitize=true" align=middle width=267.09218745pt height=32.990165999999995pt/></p>

Letting <img src="/tex/9eb4767e5eb2c4e40983c4cb0c33fedc.svg?invert_in_darkmode&sanitize=true" align=middle width=70.66656794999999pt height=27.91243950000002pt/> and <img src="/tex/23a3f7407c27e8d5ded6f25888f8b45c.svg?invert_in_darkmode&sanitize=true" align=middle width=82.60842974999998pt height=27.91243950000002pt/>, this can be written in a form
similar to the [unconstrained vector problem](#unconstrained-quadratic-vector-optimization):

<p align="center"><img src="/tex/62d4bd2e6f1d5ca61c5ab8efcb42dffe.svg?invert_in_darkmode&sanitize=true" align=middle width=218.80322474999997pt height=32.990165999999995pt/></p>

this problem is _separable_ in the columns of <img src="/tex/cbfb1b2a33b28eab8a3e59464768e810.svg?invert_in_darkmode&sanitize=true" align=middle width=14.908688849999992pt height=22.465723500000017pt/> and <img src="/tex/ddcb483302ed36a59286424aa5e0be17.svg?invert_in_darkmode&sanitize=true" align=middle width=11.18724254999999pt height=22.465723500000017pt/> and solved by finding
the solution to the multi-column linear system:

<p align="center"><img src="/tex/29a4f160c30f9322be68c54e72355d67.svg?invert_in_darkmode&sanitize=true" align=middle width=73.79439705pt height=14.42921205pt/></p>

In MATLAB,

```
X = Q \ -L;
```

## Fixed value constraints

Let <img src="/tex/48ceffddf7ca918284e3acbb9edeee97.svg?invert_in_darkmode&sanitize=true" align=middle width=99.62108309999999pt height=27.91243950000002pt/> be a set of indices indicating elements of <img src="/tex/332cc365a4987aacce0ead01b8bdcc0b.svg?invert_in_darkmode&sanitize=true" align=middle width=9.39498779999999pt height=14.15524440000002pt/> that
should be constrained to a particular known value. Then the problem:

<p align="center"><img src="/tex/56ac949606f724781f17c4d036bcdc2e.svg?invert_in_darkmode&sanitize=true" align=middle width=132.6141795pt height=32.990165999999995pt/></p>

<p align="center"><img src="/tex/81ca2973b757f21b01c41eae6990f5ee.svg?invert_in_darkmode&sanitize=true" align=middle width=177.37353149999998pt height=14.611878599999999pt/></p>

can be reduced to an [unconstrained problem](#unconstrained-quadratic-vector-optimization) by substitution.
Introduce the set <img src="/tex/6bac6ec50c01592407695ef84f457232.svg?invert_in_darkmode&sanitize=true" align=middle width=13.01596064999999pt height=22.465723500000017pt/> to be all indices _not_ in <img src="/tex/21fd4e8eecd6bdf1a4d3d6bd1fb8d733.svg?invert_in_darkmode&sanitize=true" align=middle width=8.515988249999989pt height=22.465723500000017pt/>, then we can first re-order
terms above to collect <img src="/tex/21fd4e8eecd6bdf1a4d3d6bd1fb8d733.svg?invert_in_darkmode&sanitize=true" align=middle width=8.515988249999989pt height=22.465723500000017pt/> and <img src="/tex/6bac6ec50c01592407695ef84f457232.svg?invert_in_darkmode&sanitize=true" align=middle width=13.01596064999999pt height=22.465723500000017pt/> sets:

<p align="center"><img src="/tex/8860fc71e64090299641b7c22fa31421.svg?invert_in_darkmode&sanitize=true" align=middle width=342.52072635pt height=39.452455349999994pt/></p>

<p align="center"><img src="/tex/e7bd8cff7d3043de8578dab4445d2ba3.svg?invert_in_darkmode&sanitize=true" align=middle width=124.7644827pt height=14.611878599999999pt/></p>

Substituting the constraint <img src="/tex/705583ffbc841720aaa905460dd09b06.svg?invert_in_darkmode&sanitize=true" align=middle width=47.50410884999998pt height=14.15524440000002pt/> into the objective then collecting terms
that are quadratic, linear, and constant in the remaining unknowns <img src="/tex/1e463ef25ae4c019b01284bed29e663a.svg?invert_in_darkmode&sanitize=true" align=middle width=19.58383019999999pt height=14.15524440000002pt/> we
have a simple [unconstrained optimization](#unconstrained-quadratic-vector-optimization) over <img src="/tex/1e463ef25ae4c019b01284bed29e663a.svg?invert_in_darkmode&sanitize=true" align=middle width=19.58383019999999pt height=14.15524440000002pt/>:

<p align="center"><img src="/tex/5508ebf4625f95425c329df99467e137.svg?invert_in_darkmode&sanitize=true" align=middle width=283.58057475pt height=33.230283899999996pt/></p>

In MATLAB, 

```
U = setdiff(1:size(Q,1),I);
x = zeros(size(Q,1),1);
x(I) = y;
x(U) = Q(U,U) \ -(l(U) + Q(U,I) x(I));
```

