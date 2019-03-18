function [ output_args ] = checkSavedResult( inp_vec )
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
    %% Run this
    try
    data = load('grad_data.csv');
    catch ME
    disp("Result File Not Found");
    output_args = -1;
    break;
    end

    len=size(data,2);
    param_data = data(:,1:len-1);
    output_args =  -1;
  %  disp("Input to check") 
%    inp_vec = load('parameters_val')';
 %   disp(inp_vec);
    for i = 1:size(param_data,1)	
	        if(inp_vec == param_data(i,:))
	            output_args= data(i,len);
		    disp("MATCHED");
	            break;
		else
%		    disp(param_data(i,:));
%		    disp((inp_vec == param_data(i,:)));
        	end
	end
    
end


