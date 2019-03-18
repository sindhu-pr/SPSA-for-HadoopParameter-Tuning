clear all;
def=load('par_def');
no_change_ind=[5 8];

maxval=load('par_maxval');
minval=load('par_minval');
range=maxval-minval;

fptr=fopen('spread.csv','w');
delta=0.05;
theta_def=(def-minval)./range;
iters=30;
step_size=0.001;
for i=1:iters
	theta=rand(size(def));
	ind=find(theta<0);theta(ind)=0.01;ind=[];
	ind=find(theta>1); theta(ind)=0.99;ind=[];
	punch(def,maxval,minval,no_change_ind,theta);
	for k=1:10
		system('java -cp /root/exp_testing/mysrc_old/commons-exec-1.0.jar:/root/exp_testing/mysrc_old/spsa_terasort/  config');
		delay(i)=load('finishTime');
		for j=1:length(theta)
			fprintf(fptr,'%e\t',theta(j));
		end;
		fprintf(fptr,'%e\n',delay(i));
		fflush(fptr); 
	end;
end;
fclose(fptr);
