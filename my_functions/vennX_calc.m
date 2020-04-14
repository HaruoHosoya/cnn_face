function [vec] = vennX_calc(x,y,z) 

%I wrote this little utility that calculate these values if you just input your original sets. %Your original sets can be 3 vectors or 3 cell arrays (with strings). If you leave the 3rd % vector empty you'll get the 2-set diagram. Feedback welcome!
%% Venn diagram for 2 sets; 

if isempty(z) 
if ~isnumeric(x) %cell array of strings; 
if or(size(y,1)>1,size(x,1)>1) %colum vectors; 
all=[x;y]; 
else 
all=[x y]; 
end 
allString = unique(all); 
numericVec = 1:length(allString); 
x = numericVec(ismember(allString,x)); 
y = numericVec(ismember(allString,y)); 
end 
vec = NaN(1,3); 
xNy = length(unique([x; y])); 
vec(1) = xNy - length(y); 

vec(2) = xNy - length(x);
vec(3) = length(x)+length(y)-xNy; 

%% Venn Diagram for 3 Sets; 

else 
if ~isnumeric(x) %cell array of strings; 
if or(size(z,1)>1,or(size(y,1)>1,size(x,1)>1)) %colum vectors; 
all=[x;y;z]; 
else 
all=[x y z]; 
end 
allString = unique(all); 
numericVec = 1:length(allString); 
x = numericVec(ismember(allString,x)); 
y = numericVec(ismember(allString,y)); 
z = numericVec(ismember(allString,z)); 
end 
vec = NaN(1,7); 
xIy = intersect(x,y); 
yIz = intersect(y,z); 
zIx = intersect(z,x); 
xIyIz = intersect(xIy,z); 
vec(7) = length(xIyIz); 
vec(2) = length(xIy) - vec(7); 
vec(4) = length(yIz) - vec(7); 
vec(6) = length(zIx) - vec(7); 
vec(1) = length(x) - vec(2) - vec(6) - vec(7); 
vec(3) = length(y) - vec(2) - vec(4) - vec(7); 
vec(5) = length(z) - vec(4) - vec(6) - vec(7); 

end 