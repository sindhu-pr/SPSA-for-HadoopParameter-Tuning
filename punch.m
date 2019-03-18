function [theta]=punch(maxval,minval,theta)
fptr=fopen('parameters_val','w');
range=maxval-minval;

% Calculate the current par val for this iteration
parVal=(theta.*range)+minval;
for i=1:length(theta)
		fprintf(fptr,'%f\n',parVal(i));
end;
fclose(fptr);
