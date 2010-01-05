function  [trainfolds, testfolds] = Kfold(N, K, randomize)
% Kfold Compute indices for K-fold cross validaiton
% N = num data
% K = num folds, if K=N, use leave-one-out CV 
% [trainfolds{i}, testfolds{i}] = indices of i'th fold
% If randomize = 1, we shuffle the indices first 
%   This is useful in case the data has some special ordering
%   such as all the positive examples before the negative ones
%
% Example:
% [trainfolds, testfolds] = Kfold(100, 3)
% testfolds{1} = 1:33, trainfolds{1} = 34:100
% testfolds{2} = 34:66, trainfolds{2} = [1:33 67:100]
% testfolds{3} = 67:100, trainfolds{3} = [1:66]
% (last fold gets all the left over so has different length)
%

if nargin < 3, randomize = 1; end
if randomize
  seed= 0; setSeed(seed);
  perm = randperm(N);
else
  perm = 1:N;
end

ndx = 1;
for i=1:K
  low(i) = ndx;
  Nbin(i) = fix(N/K);
  if i==K
    high(i) = N;
  else
    high(i) = low(i)+Nbin(i)-1;
  end
  testfolds{i} = low(i):high(i);
  trainfolds{i} = setdiff(1:N, testfolds{i});
  testfolds{i} = perm(testfolds{i});
  trainfolds{i} = perm(trainfolds{i});
  ndx = ndx+Nbin(i);
end

if randomize
  restoreSeed;
end