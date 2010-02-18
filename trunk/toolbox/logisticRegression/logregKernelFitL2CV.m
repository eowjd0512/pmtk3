function [model, lambdaStar, mu, se] = logregKernelFitL2CV...
        (X, y, lambdaRange, kernelParamRange, kernelType, nfolds)
    
    switch nargin 
        case 2, args = {};
        case 3, args = {lambdaRange};
        case 4, args = {lambdaRange, kernelParamRange};
        case 5, args = {lambdaRange, kernelParamRange, kernelType};
        case 6, args = {lambdaRange, kernelParamRange, kernelType, nfolds};
    end
    [model, lambdaStar, mu, se] = logregKernelFitCV(X, y, @penalizedL2, args{:}); 
end



%PMTKtest
% load crabs
% model = logregKernelFitL2CV(Xtrain, ytrain)
% yhat = logregPredict(model, Xtest)
% nerrors = sum(yhat ~= ytest)