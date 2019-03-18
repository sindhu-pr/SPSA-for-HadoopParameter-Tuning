clear all;
def=load('par_def')';
maxval=load('par_maxval')';
minval=load('par_minval')';
range=maxval-minval;
theta_def=(def-minval)./range;
delta=[0.08*ones(1,length(theta_def)-1),0.17];
theta=theta_def;
iters=50;
step_size=0.01;
checkRange=1;
for i=1:iters
	fprintf("===========================================================\n");
	fprintf("We are in iteration number: %d \n",i);

%	Executing the Hadoop job
	punch(maxval,minval,theta);
	delayp(i)=executeHadoopJob(theta);
	fwrit(theta,delayp(i),minval,maxval);

%	 The SPSA algorithm doing its magic.
	disp("Perturbing the Values")
	Delta=sign(0.5-rand(size(def)));
%	thetan=theta-delta.*Delta;
	thetan=theta;

%	Make sure all the theta within the range
	if(checkRange==1)
	ind=find(thetan>0.99);
	thetan(ind)=0.99;
	ind=find(thetan<0.01);
	thetan(ind)=0.01;
	end
	
%	Executing the Hadoop job
	punch(maxval,minval,thetan);
	delayn(i)=executeHadoopJob(thetan);
	fwrit(thetan,delayn(i),minval,maxval);
	f(i)=delayp(i)-delayn(i);	

	% Calculate the new theta values which will be used in the next iteration of the experiment.
	disp('Calculating the new theta values')
%	theta_last=theta(length(theta));
	gradVal=(f(i))./(delta.*Delta); 
	writeGradVal(gradVal);

	theta=theta-step_size*((f(i))./(delta.*Delta));
%	Why the last value is getting special treatment
%	last=length(theta);
%	theta(last)=theta_last-0.17*sign((f(i)/(delta(last)*Delta(last))));

	if(checkRange==1)
	ind=find(theta>0.99);
	theta(ind)=0.99;
	ind=find(theta<0.01);
	theta(ind)=0.01;
	end
end;


