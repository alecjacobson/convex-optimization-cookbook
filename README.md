# Convex Optimization Cookbook

Unless otherwise stated, we will assume that quadratic coefficient matrices
(e.g., <img src="/tex/1afcdb0f704394b16fe85fb40c45ca7a.svg?invert_in_darkmode&sanitize=true" align=middle width=12.99542474999999pt height=22.465723500000017pt/>) are positive (semi-)definite so that <img src="/tex/664cf1886128c5fc05c2213e395b3fb1.svg?invert_in_darkmode&sanitize=true" align=middle width=42.88131539999999pt height=27.91243950000002pt/> is a convex function
and that the problem has a unique minimizer.

## Unconstrained 

If <img src="/tex/46d925a52666f83a6cc30a3149bb09df.svg?invert_in_darkmode&sanitize=true" align=middle width=71.48480955pt height=26.17730939999998pt/> is positive definite then problems of the
form:

<p align="center"><img src="/tex/acf456b1e6a5975ded4d70137bc5149d.svg?invert_in_darkmode&sanitize=true" align=middle width=132.6141795pt height=32.990165999999995pt/></p>

are solved by finding the solution to the linear system:

<p align="center"><img src="/tex/791250a6dba531bc0fe98455637871be.svg?invert_in_darkmode&sanitize=true" align=middle width=63.942844349999994pt height=14.611878599999999pt/></p>

In MATLAB,

```
x = Q \ -l;
```


## Fixed value constraints

Let <img src="/tex/141fcfd320311fee79e05b4f5743a9c4.svg?invert_in_darkmode&sanitize=true" align=middle width=104.01990224999997pt height=24.65753399999998pt/> be a set of indices indicating elements of <img src="/tex/332cc365a4987aacce0ead01b8bdcc0b.svg?invert_in_darkmode&sanitize=true" align=middle width=9.39498779999999pt height=14.15524440000002pt/> that
should be constrained to a particular known value. Then the problem:

<p align="center"><img src="/tex/09b4290d9d4dbb9235c8bd4244020832.svg?invert_in_darkmode&sanitize=true" align=middle width=302.68177664999996pt height=32.990165999999995pt/></p>

can be reduced to an [unconstrained problem](#unconstrained) by substitution.
Introduce the set <img src="/tex/8eb543f68dac24748e65e2e4c5fc968c.svg?invert_in_darkmode&sanitize=true" align=middle width=10.69635434999999pt height=22.465723500000017pt/> to be all indices _not_ in <img src="/tex/21fd4e8eecd6bdf1a4d3d6bd1fb8d733.svg?invert_in_darkmode&sanitize=true" align=middle width=8.515988249999989pt height=22.465723500000017pt/>, then we can first re-order
terms above to collect <img src="/tex/21fd4e8eecd6bdf1a4d3d6bd1fb8d733.svg?invert_in_darkmode&sanitize=true" align=middle width=8.515988249999989pt height=22.465723500000017pt/> and <img src="/tex/8eb543f68dac24748e65e2e4c5fc968c.svg?invert_in_darkmode&sanitize=true" align=middle width=10.69635434999999pt height=22.465723500000017pt/> sets:

<p align="center"><img src="/tex/951abcc1c6048898fdcb92b4f9d8e8d2.svg?invert_in_darkmode&sanitize=true" align=middle width=393.0455199pt height=32.990165999999995pt/></p>
