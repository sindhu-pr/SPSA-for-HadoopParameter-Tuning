function []=writeGradVal(gradVal)
fptr=fopen('grad_data2.csv','a');
fprintf(fptr,'%e\n',gradVal);
fflush(fptr);
fclose(fptr);

