function [width_count, depth_count_profile,  depth_count_Halfprofile] =...
    compute_tuning_halfwidth(respFVsort)

% for half width calculation

respActive = respFVsort;        
%         idex2 = find(mean(respActive) < 0.5*mean(mean(respActive)));
%         respActive(:, idex2) = [];
respActive(:, all(~respActive, 1)) = [];               
width_iden = zeros(size(respActive, 2), 1);

rProfile = zeros(1, size(respActive, 2));
rHalfProfile = zeros(1, size(respActive, 2));


for i = 1:size(respActive, 2)           
   irespActive = respActive(:, i);
   reshaped_respActive = reshape(irespActive, [25, 8]);
%            [maxV, indexV] = max(max(reshaped_respActive));
   [maxV, indexV] = max(mean(reshaped_respActive));
   indexVN = indexV-1;
   [maxV2, indexV2] = max(mean(reshaped_respActive(:, [1:2 4:5])));           
   index_range = 25*indexVN+1: 25*(indexVN+1);
   respFVsortForView = irespActive(index_range);
   sortRespView = sort(respFVsortForView, 'descend');
   halfwidth = (max(sortRespView) + min(sortRespView))/2;
   stuff = find(sortRespView > halfwidth);
   width_iden(i)= max(stuff);

   [width_count, ~]= hist(width_iden, 25);        


   % for head orientation tuning depth     

   if indexV2 <= 2              
       iRprofile = mean(reshaped_respActive(:, 1));
       iRhalfprofile = mean(reshaped_respActive(:, 2));               
   elseif indexV2 > 2 
       iRprofile = mean(reshaped_respActive(:, 5));
       iRhalfprofile = mean(reshaped_respActive(:, 4));
   end
%            else 
%                iRprofile = mean([reshaped_respActive(:, 1);reshaped_respActive(:, 5)]);
%                iRhalfprofile = mean([reshaped_respActive(:, 2);reshaped_respActive(:, 4)]);
%            end  

   rProfile(i) = iRprofile;
   rHalfProfile(i) = iRhalfprofile;

end

rFrontal = mean(respActive(51:75, :));

%         rProfile = mean(respActive([1:25 101:125], :));
%         rHalfProfile = mean(respActive([26:50 76:100], :));

%         rFrontal = rFrontal+1;
%         rProfile = rProfile+1;

%         figure; hist(rFrontal, 20)
%         figure; hist(rProfile, 20)


tuningDepth_profile = (rFrontal-rProfile)./(rFrontal+rProfile);
tuningDepth_Halfprofile = (rFrontal-rHalfProfile)./(rFrontal+rHalfProfile);

[depth_count_profile, ~] = hist(tuningDepth_profile);
[depth_count_Halfprofile, ~] = hist(tuningDepth_Halfprofile);

end
       
