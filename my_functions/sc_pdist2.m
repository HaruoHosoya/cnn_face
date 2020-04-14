function Dist = sc_pdist2( X, Y, metric )
% Calculates the pairwise distance between sets of vectors.
%
% Let X be an D-by-M matrix representing m points in D-dimensional space
% and Y be an D-by-N matrix representing another set of points in the same
% space. This function computes the M-by-N distance matrix Dist where Dist(i,j)
% is the distance between X(:,i) and Y(:,j).  This function has been
% optimized where possible, with most of the distance computations
% requiring few or no loops.
%
% The metric can be one of the following:
%
% 'euclidean' / 'sqeuclidean':
%   Euclidean / SQUARED Euclidean distance.  Note that 'sqeuclidean'
%   is significantly faster.
%
% 'chisq' 'cs'
%   The chi-squared distance between two vectors is defined as:
%    d(x,y) = sum( (xi-yi)^2 / (xi+yi) ) / 2;
%   The chi-squared distance is useful when comparing histograms.
%
%  'hell' 'hik'
%   The hellinger's distance is dedined as:
%    d(x,y) = sum (x^.5 - y^.5) .^ 2
% 
% 'cos'
%   Distance is defined as the cosine of the angle between two vectors.
%
% 'emd'
%   Earth Mover's Distance (EMD) between positive vectors (histograms).
%   Note for 1D, with all histograms having equal weight, there is a simple
%   closed form for the calculation of the EMD.  The EMD between histograms
%   x and y is given by the sum(abs(cdf(x)-cdf(y))), where cdf is the
%   cumulative distribution function (computed simply by cumsum).
%
% 'L1','LINF'
%   The L1 distance between two vectors is defined as:  sum(abs(x-y));
%   The L-Inf distance is defined as: max(abs(x-y));
%
% USAGE
%  Dist = sc_pdist2( X, Y, [metric] )
%
% INPUTS
%  X        - [D x M] matrix of M D-dimensional vectors
%  Y        - [D x N] matrix of N D-dimensional vectors
%  metric   - ['sqeuclidean'], 'chisq', 'cosine', 'emd', 'euclidean', 'L0'
%              'L1', 'Linf', 'hik'
%
% OUTPUTS
%  Dist        - [M x N] distance matrix
% % % 
% (C) Shicai Yang, 2012
% Institute of Systems Engineering, Southeast University, Nanjing

if( nargin<3 || isempty(metric) ); 
    metric=0; 
end;

switch metric
    case {0,'sqeuclidean','sqe','seu'}
        Dist = distEucSq(X,Y);
    case {'euclidean','euc','l2','L2'}
        Dist = sqrt(distEucSq(X,Y));
    case {'L0','hamming','ham','l0'}
        Dist = distL0(X,Y);
    case {'L1','cityblock','cit','l1'}
        Dist = distL1(X,Y);
    case {'Linf','linf','chebychev','che'}
        Dist = distLinf(X,Y);
    case {'cosine','cos'}
        Dist = distCosine(X,Y);
    case {'emd','EMD'}
        Dist = distEmd(X,Y);
    case {'chisq','cs','chi2'}
        Dist = distChiSq(X,Y);
    case {'hellingers','hell','hik'}
        Dist = distHell(X,Y);
    case {'corr', 'correlation'}
        Dist = distCorr(X,Y);

    case{'chisq_2'}
        Dist = dist_chisquare_2(X, Y);
    case{'kl_div'}
        Dist = dist_kl(X, Y);
    case{'norm_dist'}
        Dist = dist_cvm(X, Y);
    case{'bhat_dist'}
        Dist = dist_bhattacharyya(X, Y);
    case{'hist_dist'}
        Dist = dist_ks(X, Y);
    case{'norm_dist2'}
        Dist = dist_match(X, Y);
    case{'jeffery'}
        Dist = dist_jeffrey(X, Y);
    case{'correlation2'}
        Dist = dist_correlation(X, Y);
    case{'cosine_similarity'}
        Dist = simCosine(X,Y);
    otherwise
        error(['pdist2 - unknown metric: ' metric]);
end
% Dist = max(0,Dist);
end

function D = distL0( X, Y )
    D=pdist2(X',Y','hamming');
end

function D = distL1( X, Y )
%     m = size(X,2);  n = size(Y,2);
%     mOnes = ones(1,m); D = zeros(m,n);
%     for i=1:n
%         yi = Y(:,i);  yi = yi(:,mOnes);
%         D(:,i) = sum( abs( X-yi));
%     end
    D=pdist2(X',Y','cityblock');
end

function D = distLinf( X, Y )
%     m = size(X,2);  n = size(Y,2);
%     mOnes = ones(1,m); D = zeros(m,n);
%     for i=1:n
%         yi = Y(:,i);  yi = yi(:,mOnes);
%         D(:,i) = max( abs( X-yi));
%     end
    D=pdist2(X',Y','chebychev');
end

function D = distCosine( X, Y )
    p=size(X,1);
    XX = sqrt(sum(X.*X))+eps; X = X ./ XX(ones(1,p),:);
    YY = sqrt(sum(Y.*Y))+eps; Y = Y ./ YY(ones(1,p),:);
    D = 1 - X'*Y;
end

function D = simCosine( X, Y )
    p=size(X,1);
    XX = sqrt(sum(X.*X))+eps; X = X ./ XX(ones(1,p),:);
    YY = sqrt(sum(Y.*Y))+eps; Y = Y ./ YY(ones(1,p),:);
    D = X'*Y;
end

function D = distEmd( X, Y )
    Xcdf = cumsum(X,1);
    Ycdf = cumsum(Y,1);
%     m = size(X,2);  n = size(Y,2);
%     mOnes = ones(1,m); D = zeros(m,n);
%     for i=1:n
%       ycdf = Ycdf(:,i);
%       ycdfRep = ycdf(:,mOnes);
%       D(:,i) = sum(abs(Xcdf - ycdfRep));
%     end
    D = zeros(size(X,2),size(Y,2),'double');
    for i=1:size(Y,2)
      D(:,i) = sum(abs(bsxfun(@minus,Xcdf,Ycdf(:,i))));
    end
end

function D = distChiSq( X, Y )
% note: supposedly it's possible to implement this without a loop!
%     m = size(X,2);  n = size(Y,2);
%     mOnes = ones(1,m); D = zeros(m,n);
%     for i=1:n
%       yi = Y(:,i);  yiRep = yi(:,mOnes);
%       s = yiRep + X;    d = yiRep - X;
%       D(:,i) = sum( d.^2 ./ (s+eps));
%     end
%     D = D/2;
    D = zeros(size(X,2),size(Y,2),'double');
    for i=1:size(Y,2)
      yi = Y(:,i);
      s=bsxfun(@plus,X,yi);
      d=bsxfun(@times,X,yi);
      D(:,i) = sum(s-4*d./(s+eps),1);
    end
    D = D/2;
end



function D = distEucSq( X, Y )
    XX = sum(X.*X);
    YY = sum(Y.*Y);
    D = bsxfun(@plus,XX',YY)-2*X'*Y;
end

function D = distHell( X, Y )
    m = size(X,2);  n = size(Y,2);
    D = zeros(m,n,'double');
    X=X.^.5;Y=Y.^.5;
    for i=1:n
      yi = Y(:,i);
      s=bsxfun(@minus,X,yi);
      D(:,i) = sum(s.^2,1);
    end
end

function D = distCorr(X, Y)
    CD = corrcoef(X, Y);
    % CD = corr(X[,Y], 'type', 'pearson');
%     D =1-CD(2);
    D =CD(2);
end


%% rajani Implementaiton

function d = dist_chisquare_2 ( h1 , h2 )
d_item = ( h1 - h2 ).^2 ./  (h1 + h2 );
d_item(isnan(d_item) | isinf(d_item)) = 0;
d = sum(d_item);
end 

function d = dist_kl ( h1 , h2 )
h1(h1==0) = eps;
h2(h2==0) = eps;
d = sum(log(h1./h2).*h1);
end


function d = dist_cvm ( h1 , h2 )
y1 = cumsum(h1);
y2 = cumsum(h2);
d = sum((y1-y2).^2);
% d = d/length(h1);
end

function d = dist_bhattacharyya ( h1 , h2 )
d1 = sum(sqrt(h1.*h2));
d  = sqrt (1 - d1);
end

function d = dist_ks ( h1 , h2 )
y1 = cumsum(h1);
y2 = cumsum(h2);
d = max(abs(y1-y2));
end

function d = dist_match ( h1 , h2 )
y1 = cumsum(h1);
y2 = cumsum(h2);
d = sum(abs(y1-y2));
% d = d / length(h1); % to avoid normalization
end


function d = dist_correlation ( h1 , h2 )

h1_m = mean (h1);
h2_m = mean (h2);

d_enu = (h1-h1_m)*(h2-h2_m)';
d_den = sqrt(((h1-h1_m)*(h1-h1_m)')*((h2-h2_m)*(h2-h2_m)'));

if (d_den ~=0)
    d = d_enu / d_den;
    d = 1 - d;
else
    d = inf;
    disp ('Singularity problem: one of the histograms is zero or uniform');
end

end