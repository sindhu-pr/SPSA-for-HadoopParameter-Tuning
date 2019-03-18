clear all;
def=load('par_def')';
maxval=load('par_maxval')';
minval=load('par_minval')';
range=maxval-minval;
theta_def=(def-minval)./range;
delta=[0.08*ones(1,length(theta_def)-1),0.17]';
step_size=0.0005;
checkRange=1;

n=50;		% Iterations
alpha=1;%0.602;
gamma=1/6;%0.101;
theta=theta_def;

p=length(theta_def);
rateOfChange = 0.001;
A=10;
a=rateOfChange*(((A+1)^alpha)/p);
c=0.1;

thetamax=0.99999;
thetamin=0.00001;
delta=2*round(rand(p,1))-1;
delta=delta';

disp('Running Default Config');
punch(maxval,minval,theta);
perf=executeHadoopJob(theta);
fwrit(theta,perf,minval,maxval);

epsilon=10;
ljCnt=5;
last_perfs=zeros(2,ljCnt);
last_perfs=last_perfs+100;

for k=0:n-1
  fprintf("ROUND 1----------------Iteration Number :%d\n",(k+1));
  ak=a/(k+1+A)^alpha;
  ck=c/(k+1)^gamma;
  currIDx = mod(k,ljCnt)+1;

  thetaplus=theta+ck*delta;
  thetaplus=min(thetaplus,thetamax);
  thetaplus=max(thetaplus,thetamin);
  punch(maxval,minval,thetaplus);
  yplus=executeHadoopJob(thetaplus);
  fwrit(thetaplus,yplus,minval,maxval);
  last_perfs(1,currIDx)=yplus;

  fprintf("ROUND 2----------------Iteration Number :%d\n",(k+1));
  thetaminus=theta-ck*delta;
  thetaminus=min(thetaminus,thetamax);
  thetaminus=max(thetaminus,thetamin);
  punch(maxval,minval,thetaminus);
  yminus=executeHadoopJob(thetaminus);
  fwrit(thetaminus,yminus,minval,maxval);
  last_perfs(2,currIDx)=yminus;

  ghat=(yplus-yminus)./(2*ck*delta);
  theta=theta-ak*ghat;

  theta=min(theta,thetamax);
  theta=max(theta,thetamin);

#  if(abs(diff(last_perfs)) < epsilon && k > 20)
#	disp('THERE IS NO CHANGE IN THE PERFORMANCE TIME. STOPPING THE SPSA');
#	break;
#   endif

end

perf=executeHadoopJob(theta);
fwrit(theta,perf,minval,maxval);

%Notes:	
%If maximum and minimum values on the values of theta can be 
%specified, say thetamax and thetamin, then the following two 
%lines can be added below the theta update line to impose the 
%constraints

%  theta=min(theta,thetamax);
%  theta=max(theta,thetamin);

%The MATLAB feval operation (not used above) is useful in 
%yplus and yminus evaluations to allow for easy change of 
%loss function.

%Algorithm initialization not shown above (see discussion
%in introduction to MATLAB code).

