for theta = linspace(0,pi)
  rng(0);
  m = 10;
  n = 1;
  dim = 2;
  B = [rand(m-1,dim)*2-1;10 10];
  R = [cos(theta) sin(theta);-sin(theta) cos(theta)];
  B = B*R;
  A = ones(m,1);
  
  % L2
  X_2 = (A'*A)\(A'*B);
  
  
  % L1 
  AA = repdiag(A,2);
  I = speye(2*m,2*m);
  X_1 = reshape(speye(2*n,2*n+2*m)*linprog([zeros(2*n,1);ones(2*m,1)],[AA -I;-AA -I],[B(:);-B(:)]),n,dim);
  
  % L1,2
  
  % min_X | (A*X-B)' |₁,₂
  % min_X | X'*A' - B'|₁,₂
  % min_X,Y | Y |₁,₂  subject to Y = X'*A' - B'
  % min_X,Y,z  z'1  subject to Y = X'*A' - B' and z(i) ≥ |Y(:,i)|
  % min_X,Y,z  z'1  subject to vec(Y) = vec(X'*A' - B') and z(i) ≥ |Y(:,i)|
  % min_X,Y,z  z'1  subject to vec(Y) = vec(X'*A') - vec(B') and z(i) ≥ |Y(:,i)|
  % min_X,Y,z  z'1  subject to vec(Y) = vec((A*X)') - vec(B') and z(i) ≥ |Y(:,i)|
  % min_X,Y,z  z'1  subject to vec(Y) = (A¤I)*vec(X) - vec(B') and z(i) ≥ |Y(:,i)|
  % min_X,Y,z  z'1  subject to vec(Y) = (A¤I)*vec(X) - vec(B') and z(i) ≥ |Y(:,i)|
  % min_x,y,z  z'1  subject to y = (A¤I)*x - bt and z(i) ≥ |Y(:,i)|
  % min_x,y,z  [x;y;z]'[0;0;1]  subject to [(A¤I) -I 0]*[x;y;z] = bt and z(i) ≥ |Y(:,i)|
  
  nb = size(B,2);
  na = size(A,1);
  n = size(A,2);
  prob = struct();
  [r, res] = mosekopt('symbcon echo(0)');
  % linear term
  prob.c = [zeros(n*nb + na*nb,1);ones(na,1)];
  % linear (in)equality matrix
  %prob.a = [kroneye(A,nb) -speye(na*nb,na*nb) sparse(na*nb,na)];
  prob.a = [kroneye(A,nb) -speye(na*nb,na*nb) sparse(na*nb,na)];
  % lower bound
  prob.blc = reshape(B',[],1);
  prob.buc = prob.blc;
  prob.cones.type = repmat(res.symbcon.MSK_CT_QUAD,1,na);
  prob.cones.sub = ...
    reshape([n*nb+na*nb+(1:na);reshape(n*nb+(1:na*nb),nb,na)],[],1);
  prob.cones.subptr = 1:(nb+1):(nb+1)*na;
  [r,res]=mosekopt('minimize echo(0)',prob);%,struct('MSK_DPAR_INTPNT_CO_TOL_REL_GAP',1e-14));
  X_12 = reshape(res.sol.itr.xx(1:n*nb),n,nb);
  
  clf;
  hold on;
  sct(  B*R','.c','SizeData',1000);
  sct(X_2*R','.r','SizeData',1000);
  sct(X_1*R','.k','SizeData',1000);
  sct(X_12*R','.g','SizeData',1000);
  hold off;
  axis tight;
  axis equal;
  axis([-10 10 -10 10]*sqrt(2));
  drawnow;
end
