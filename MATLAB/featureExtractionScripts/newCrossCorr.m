function [result]=newCrossCorr(a,b)
length_a = length(a);
length_b = length(b);

if (length_a < length_b)
    magT = norm(a);
    T_length = length_a;
    data = zeros(1,(3*length_b -2));
    data(length_b:(2*length_b -1)) = b;
    
else
    magT = norm(b);
    T_length = length_b;
    data = zeros(1,(3*length_a -2));
    data(length_a:(2*length_a -1)) = a;
    
end
c = xcorr(a,b);

for i = 1:length(c)
    temp = data(i:i+T_length-1); 
    magD = norm(temp);
    c(i) = c(i)/( magD * magT) ; 
end
result = c; 