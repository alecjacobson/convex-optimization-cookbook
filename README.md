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

<p align="center"><img src="/tex/42aedbf54a9b5d2a76488c7884820fd6.svg?invert_in_darkmode&sanitize=true" align=middle width=700.2744869999999pt height=90.5707473pt/></p>
\min_x \frac{1}{2} x^\top Q x + x^\top \ell
<p align="center"><img src="/tex/e7e1fce898b1583cb28cc71db94ffdd5.svg?invert_in_darkmode&sanitize=true" align=middle width=0.0pt height=0.0pt/></p>
\text{subject to: } x_i = y_i \forall i \in I
<p align="center"><img src="/tex/386d2ed2e85d2226163efe6ca21d0878.svg?invert_in_darkmode&sanitize=true" align=middle width=700.2745299000001pt height=35.251144499999995pt/></p>\min_x \frac{1}{2} [x_U^\top x_I^\top] 
<p align="center"><img src="/tex/ff57be1f3c83d35e3ad53f2666194bfc.svg?invert_in_darkmode&sanitize=true" align=middle width=98.71151234999999pt height=39.452455349999994pt/></p>
<p align="center"><img src="/tex/36cf3ae6e6de8c8d23a2b8a504f49587.svg?invert_in_darkmode&sanitize=true" align=middle width=37.757382299999996pt height=39.452455349999994pt/></p>
+
[x_U^\top x_I^\top] 
<p align="center"><img src="/tex/68fbafb72e0955d967a2af48944034f7.svg?invert_in_darkmode&sanitize=true" align=middle width=35.2117656pt height=39.452455349999994pt/></p>
<p align="center"><img src="/tex/e7e1fce898b1583cb28cc71db94ffdd5.svg?invert_in_darkmode&sanitize=true" align=middle width=0.0pt height=0.0pt/></p>
\text{subject to } x_I = y
<p align="center"><img src="/tex/ef75fdd1bc51270863cdbd9c4c031ac8.svg?invert_in_darkmode&sanitize=true" align=middle width=700.2745464pt height=54.9771717pt/></p> \min_{x_U} \frac{1}{2} x_U^\top Q_{UU} x_U + x_U^\top (\ell_U + Q_{UI} x_I)
+ c$$

In MATLAB, 

```
U = setdiff(1:size(Q,1),I);
x = zeros(size(Q,1),1);
x(I) = y;
x(U) = Q(U,U) \ -(l(U) + Q(U,I) x(I));
```

