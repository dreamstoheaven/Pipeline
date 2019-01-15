function [ w_m,w_T_m ] = FillingGaps_Double_Filter_V2( w_m,w_T_m )

% This function fills in all gaps in time and puts in -10 as the
% psuedovalue. Other negative values should work as well, but positive
% values might be a concern as they may in some cases remain in the dataset
% after filtering and be additional artifacts. This function expands the
% array by redefining the array rather than inserting an element into the
% erray; the later would be more intuitive but computationally costly. It is mathematically faster to simply delete all three
% datapoints when they are misaligned, but the find() function
% involved in this operation is extreemly costly and not the best choice
% for large databases and recursive operations. 
w_T_m = int32(w_T_m*3600);

a = [double(w_T_m),double(w_m)];
starttime = a(1,1);
endtime = a(end,1);


a(691200,2) = 0;
a = a';

count = 0;



% Define whatever pseudovalue you would like to assign to missing
% datapoints. Any negative value should work. 
if starttime ~= 1
    inx_a = knnsearch(a(1,:)',starttime);
    a = a(:,inx_a:end);
    rightvalue = a(1,1);

    for i = 1:endtime-rightvalue - 1
        %try
        if a(1,i) ~= rightvalue+i-1
            
            a = [a(:,1:i-1),[rightvalue+i-1;NaN;],a(:,i:691199)];
            count = count + 1;
        end
        if mod(i,2000) == 0
            i
        end
    end
    if length(a(1,:)) < (endtime-rightvalue)
        a(:,endtime - rightvalue) = [rightvalue+i-1;NaN;];
    end
else 
    for i = starttime:endtime -1

        %try
        if a(1,i) ~= i-1 
            a = [a(:,1:i-1),[i-1;NaN;],a(:,i:end-i)];
        end
    end
    if length(a(1,:)) < (endtime-starttime+1)
        a(:,endtime-starttime+1) = [endtime-starttime;NaN;];
    end
    
end
w_T_m = a(:,1)/3600;
w_m = a(:,2);
end