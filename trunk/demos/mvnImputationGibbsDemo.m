function mvnImputationGibbsDemo()


setSeed(0);
d = 10;
mu = randn(d,1); Sigma = randpd(d);

% Training data is larger than test data, and is missing data at random
[XfullTrain, XmissTrain] = mkData(mu, Sigma, 100, true);

% Test data omits 'stripe' rather than at random, for easier visualization
[Xfull, Xmiss, Xhid] = mkData(mu, Sigma, 10, false);

for useFull = [false]
  if useFull
    [muSamples, SigmaSamples, dataSamples, LLtrace] = mvnFitGibbs(XfullTrain, 'verbose', false, 'mu0', nanmean(XfullTrain), 'Lambda0', diag(nanvar(XfullTrain)), 'k0', 0.01, 'dof', d + 2);
    muHat = mean(muSamples);
    SigmaHat = mean(SigmaSamples,3);
    [Ximpute, V] = mvnImpute(muHat', SigmaHat, Xmiss);
    Xtrain = XfullTrain;
    fname = 'mvnImputeFull';
  else
    [muSamples, SigmaSamples, dataSamples, LLtrace] = mvnFitGibbs(XmissTrain, 'verbose', false, 'mu0', nanmean(XmissTrain), 'Lambda0', diag(nanvar(XmissTrain)), 'k0', 0.01, 'dof', d + 2);
    muHat = mean(muSamples);
    SigmaHat = mean(SigmaSamples,3);
    figure; plot(LLtrace); title('EM loglik vs iteration')
    [Ximpute, V] = mvnImpute(muHat', SigmaHat, Xmiss);
    Xtrain = XmissTrain;
    fname = 'mvnImputeEm';
  end
  conf = 1./V;
  conf(isinf(conf))=0;
  
  figure;
  hintonScale({Xtrain}, {'-map', 'jet', '-title', 'training data'}, ...
    {Xmiss}, {'-map', 'Jet', '-title', 'observed'}, ...
    {Ximpute, conf}, {'-title', 'imputed'}, ...
    {Xhid}, {'-title', 'hidden truth'});
  printPmtkFigure(fname);
end

end


function [Xfull, Xmiss, Xhid, missing] = mkData(mu, Sigma, n, rnd)


pcMissing = 0.5;
d = length(mu);
Xfull = mvnrnd(mu, Sigma, n);

if rnd
  % Random missing pattern
  missing = rand(n,d) < pcMissing;
else
  % Make the first 3 stripes (features) be completely missing
  missing = false(n,d);
  missing(:, 1:floor(pcMissing*d)) = true;
end

Xmiss = Xfull;
Xmiss(missing) = NaN;
Xhid = Xfull;
Xhid(~missing) = NaN;

end