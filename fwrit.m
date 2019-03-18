function []=fwrit(theta,delay,minval,maxval)
fptr=fopen('grad_data.csv','a');
fptr2=fopen('grad_data_par_val.csv','a');

range = maxval-minval;
parVal=(theta.*range)+minval;

for i=1:length(theta)
fprintf(fptr,'%f\t',theta(i));
end;
fprintf(fptr,'%f\n',delay);

for i=1:length(parVal)
fprintf(fptr2,'%f\t',parVal(i));
end;
fprintf(fptr2,'\n');


fflush(fptr);
fflush(fptr2);
fclose(fptr);
fclose(fptr2);

